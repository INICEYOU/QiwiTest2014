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
}
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
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshViewAfterConnection) name:@"refreshUsersViewAfterConnection" object:nil];


    self.detailViewController = (INYDetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
 
    UIBarButtonItem *addButtonRefresh = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                                                                      target:self action:@selector(refreshTable)];
    self.navigationItem.rightBarButtonItem = addButtonRefresh;
    
    refreshControl = [[UIRefreshControl alloc]init];
    [dataTable addSubview:refreshControl];
    [refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
    

    
    [self refreshTable];
}

- (void)refreshViewAfterConnection
{
    allUsers = [[INYLibraryAPI sharedInstance] getUsers];
    [dataTable reloadData];
}

- (void)refreshTable
{

    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    spinner.center = CGPointMake(self.view.center.x,self.view.center.y);
    spinner.hidesWhenStopped = YES;
    [self.view addSubview:spinner];
    [spinner startAnimating];
    

    dispatch_queue_t downloadQueue = dispatch_queue_create("downloader", NULL);
    dispatch_sync(downloadQueue, ^{
        
        [[INYLibraryAPI sharedInstance]RequestWithURL:ULRshowUsers option:@""];
       // [NSThread sleepForTimeInterval:1];
        
        

        dispatch_async(dispatch_get_main_queue(), ^{
            [self refreshViewAfterConnection];
            [refreshControl endRefreshing];
            [spinner stopAnimating];
            
            NSString *message = [[INYLibraryAPI sharedInstance] codeMessageRequest];
            if (![message isEqualToString:@""]) {
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Код сообщения"
                                                                message:message
                                                               delegate:self
                                                      cancelButtonTitle:@"Ok"
                                                      otherButtonTitles:nil];
                [alert show];
            }
        });
        
    });
    
    
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

@end
