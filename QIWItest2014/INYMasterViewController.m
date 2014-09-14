//
//  INYMasterViewController.m
//  QIWItest2014
//
//  Created by Nice on 09/09/2014.
//  Copyright (c) 2014 INICEYOU. All rights reserved.
//

#import "INYMasterViewController.h"
#import "INYDetailViewController.h"
#import "INYLibraryAPI.h"

static NSString * const ULRshowUsers = @"http://je.su/test";

@interface INYMasterViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    NSArray * allUsers;
    IBOutlet UITableView *dataTable;
    UIRefreshControl *refreshControl;
    UIActivityIndicatorView *spinner;
}
@property (strong, nonatomic) UIPopoverController *masterPopoverController;

@end

@implementation INYMasterViewController

- (void)awakeFromNib
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.clearsSelectionOnViewWillAppear = NO;
        self.preferredContentSize = CGSizeMake(320.0, 600.0);
    }
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshViewAfterConnection) name:@"refreshUsersViewAfterConnection" object:nil];


    self.detailViewController = (INYDetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
 
    UIBarButtonItem *addButtonRefresh = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                                                                      target:self action:@selector(refreshTable)];
    self.navigationItem.rightBarButtonItem = addButtonRefresh;
    
    refreshControl = [[UIRefreshControl alloc]init];
    [dataTable addSubview:refreshControl];
    [refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
    
    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    spinner.center = CGPointMake(self.view.center.x,self.view.center.y);
    spinner.hidesWhenStopped = YES;
    [self.view addSubview:spinner];
    
    [self refreshTable];
}

- (void)refreshViewAfterConnection
{
    allUsers = [[INYLibraryAPI sharedInstance] getUsers];
    [dataTable reloadData];
    
    if(![refreshControl isRefreshing]){
        [spinner stopAnimating];
    } else {
        [refreshControl endRefreshing];
    }
    
    NSString *message = [[INYLibraryAPI sharedInstance] codeMessageRequest];
    if (![message isEqualToString:@""]) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ошибка"
                                                        message:message
                                                       delegate:self
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

- (void)refreshTable
{
    if(![refreshControl isRefreshing]){
        [spinner startAnimating];
    }
    [[INYLibraryAPI sharedInstance]RequestWithURL:ULRshowUsers option:@""];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [allUsers count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    INYUsers *users = allUsers[indexPath.row];
    cell.textLabel.text = [[NSString alloc] initWithFormat:@"%@ %@",users.name,users.secondName];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.detailViewController.detailItem = [[INYLibraryAPI sharedInstance] getUserIdWithIndex:indexPath];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        [[segue destinationViewController] setDetailItem:[[INYLibraryAPI sharedInstance] getUserIdWithIndex:indexPath]];
    }
}

#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title =NSLocalizedString(@"Пользователи", @"Пользователи");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    
    self.masterPopoverController = popoverController;
   // [splitViewController setHidesMasterViewInPortrait:NO];
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    //self.masterPopoverController = nil;
}

@end
