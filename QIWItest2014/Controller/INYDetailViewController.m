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
static NSString * const refreshBalanceViewAfterConnection = @"refreshBalanceViewAfterConnection";

@interface INYDetailViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    NSArray *balances;
    IBOutlet UITableView *dataTable;
    UIRefreshControl *refreshControl;
    UIActivityIndicatorView *spinner;
}
@property (strong, nonatomic) UIPopoverController *masterPopoverController;

- (void)configureView;

@end

@implementation INYDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshViewAfterConnection) name:refreshBalanceViewAfterConnection object:nil];

	
    UIBarButtonItem *addButtonRefresh = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshTable)];
    self.navigationItem.rightBarButtonItem = addButtonRefresh;
    
    refreshControl = [[UIRefreshControl alloc]init];
    [dataTable addSubview:refreshControl];
    [refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
    
    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    spinner.center = CGPointMake(self.view.center.x,self.view.center.y);
    spinner.hidesWhenStopped = YES;
    [self.view addSubview:spinner];
    
    if (self.detailItem == nil){
        self.detailItem = @"0";
    }

    [self configureView];
}

- (void)refreshViewAfterConnection
{
    balances = [[INYLibraryAPI sharedInstance] balanceWithUserId:self.detailItem];
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
    
    [[INYLibraryAPI sharedInstance]requestWithURL:ULRgetMoneyWithUserId option:self.detailItem];
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

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (self.detailItem != newDetailItem) { // 1
        self.detailItem = newDetailItem;
        
        [self configureView];
        [self refreshTable];
    }
    
    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }
}

- (void)configureView
{
    if (self.detailItem) {
        self.detailDescriptionLabel.title = [NSString stringWithFormat:@"Баланс # %@",self.detailItem];
    }
}

#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    
    barButtonItem.title =NSLocalizedString(@"Пользователи", @"Пользователи");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
     
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    self.masterPopoverController = nil;
}

- (BOOL)splitViewController:(UISplitViewController *)svc
   shouldHideViewController:(UIViewController *)vc
              inOrientation:(UIInterfaceOrientation)orientation
{
    return NO;
}

- (void)splitViewController:(UISplitViewController*)svc
          popoverController:(UIPopoverController*)pc
  willPresentViewController:(UIViewController *)aViewController{
    if ([pc isPopoverVisible]) {
        [pc dismissPopoverAnimated:YES];
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
    
    cell.textLabel.text = [[INYLibraryAPI sharedInstance] balanceUserFriendlyWithBalance:balances[indexPath.row]];
    return cell;
}

@end
