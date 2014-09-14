//
//  INYDetailViewController.m
//  QIWItest2014
//
//  Created by Nice on 09/09/2014.
//  Copyright (c) 2014 INICEYOU. All rights reserved.
//

#import "INYDetailViewController.h"
#import "INYLibraryAPI.h"

static NSString * const ULRgetMoneyWithUserId = @"http://je.su/test?mode=showuser&id=";

@interface INYDetailViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    NSArray *balances;
    IBOutlet UITableView *dataTable;
    UIRefreshControl *refreshControl;
    UIActivityIndicatorView *spinner;
}

- (void)configureView;

@end

@implementation INYDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshViewAfterConnection) name:@"refreshBalanceViewAfterConnection" object:nil];

	
    UIBarButtonItem *addButtonRefresh = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshTable)];
    self.navigationItem.rightBarButtonItem = addButtonRefresh;
    
    refreshControl = [[UIRefreshControl alloc]init];
    [dataTable addSubview:refreshControl];
    [refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
    
    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    spinner.center = CGPointMake(self.view.center.x,self.view.center.y);
    spinner.hidesWhenStopped = YES;
    [self.view addSubview:spinner];
    
    if (_detailItem == nil){
        _detailItem = @"0";
    }
    
    [self configureView];
    [self refreshTable];
}

- (void)refreshViewAfterConnection
{
    balances = [[INYLibraryAPI sharedInstance] getBalanceWithUserId:_detailItem];
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
    
    [[INYLibraryAPI sharedInstance]RequestWithURL:ULRgetMoneyWithUserId option:_detailItem];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        [self configureView];
    }
    /*
    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }
     */
}

- (void)configureView
{
    if (self.detailItem) {
        self.detailDescriptionLabel.title = [NSString stringWithFormat:@"# %@",self.detailItem];
    }
}



#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [balances count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell2" forIndexPath:indexPath];
    
    cell.textLabel.text = [[INYLibraryAPI sharedInstance] getBalanceUserFriendlyWithBalance:balances[indexPath.row]];
    return cell;
}

@end
