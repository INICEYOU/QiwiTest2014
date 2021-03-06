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
static NSString * const refreshUsersViewAfterConnection = @"refreshUsersViewAfterConnection";

@interface INYMasterViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    NSArray * allUsers;
    UIRefreshControl *refreshControl;
    UIActivityIndicatorView *spinner;
}

- (void)refreshViewAfterConnection;
- (void)refreshTable;

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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshViewAfterConnection) name:refreshUsersViewAfterConnection object:nil];

    self.detailViewController = (INYDetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
 
    UIBarButtonItem *addButtonRefresh = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                                                                      target:self action:@selector(refreshTable)];
    self.navigationItem.rightBarButtonItem = addButtonRefresh;
    
    refreshControl = [[UIRefreshControl alloc]init];
    [self.view addSubview:refreshControl];
    [refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
    
    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    spinner.center = CGPointMake(self.view.center.x,self.view.center.y);
    spinner.hidesWhenStopped = YES;
    [self.tableView addSubview:spinner];
    
    [self refreshTable];
}

- (void)refreshViewAfterConnection
{
    allUsers = [[INYLibraryAPI sharedInstance] users];
    [self.tableView reloadData];
    
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
                                              cancelButtonTitle:@"Отменить"
                                              otherButtonTitles:@"Повторить",nil];
        [alert show];
    }
}

- (void)refreshTable
{
    if(![refreshControl isRefreshing]){
        [spinner startAnimating];
    }
    [[INYLibraryAPI sharedInstance]requestWithURL:ULRshowUsers option:@""];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        [self refreshTable];
    }
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
    INYUser *users = allUsers[indexPath.row];
    cell.textLabel.text = [[NSString alloc] initWithFormat:@"%@ %@",users.secondName,users.name];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.detailViewController.detailItem = [[INYLibraryAPI sharedInstance] userIdWithIndex:indexPath];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        [[segue destinationViewController] setDetailItem:[[INYLibraryAPI sharedInstance] userIdWithIndex:indexPath]];
    }
}

@end
