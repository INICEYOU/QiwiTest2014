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
}
@property (strong, nonatomic) UIPopoverController *masterPopoverController;

- (void)configureView;

@end

@implementation INYDetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }

    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }        
}

- (void)configureView
{
    balances = [[INYLibraryAPI sharedInstance] getBalanceWithUserId:_detailItem];

    if (self.detailItem) {
        self.detailDescriptionLabel.title = [self.detailItem description];
        
 //       HTTPClient = [INYHTTPClient new];
 //       [HTTPClient RequestWithURL:ULRgetMoneyWithUserId option:self.detailItem];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    UIBarButtonItem *addButtonRefresh = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshTable:)];
    self.navigationItem.rightBarButtonItem = addButtonRefresh;
    
    [self configureView];
}

- (void)refreshTable:(id)sender
{
    [dataTable reloadData];
    //[self configureView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"Master", @"Master");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:NO];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
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
