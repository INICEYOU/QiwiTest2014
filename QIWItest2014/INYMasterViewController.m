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
  //  UITableView * dataTable;
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

    self.detailViewController = (INYDetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
 
    UIBarButtonItem *addButtonRefresh = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                                                                      target:self action:@selector(refreshTable)];
    self.navigationItem.rightBarButtonItem = addButtonRefresh;
    
    refreshControl = [[UIRefreshControl alloc]init];
    [dataTable addSubview:refreshControl];
    [refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
    
    [self refreshTable];
}

- (void)refreshTable
{
    [[INYLibraryAPI sharedInstance]RequestWithURL:ULRshowUsers option:@""];
    allUsers = [[INYLibraryAPI sharedInstance] getUsers];
    [refreshControl endRefreshing];
    [dataTable reloadData];
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
    //return _objects.count;
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
