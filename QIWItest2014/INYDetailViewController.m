//
//  INYDetailViewController.m
//  QIWItest2014
//
//  Created by Nice on 09/09/2014.
//  Copyright (c) 2014 INICEYOU. All rights reserved.
//

#import "INYDetailViewController.h"
#import "INYHTTPClient.h"

static NSString * const ULRgetMoneyWithUserId = @"http://je.su/test?mode=showuser&id=";

@interface INYDetailViewController (){
        INYHTTPClient *HTTPClient;
}
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
@property (weak, nonatomic) IBOutlet UILabel *Balance;
@property (weak, nonatomic) IBOutlet UILabel *Currency;

- (IBAction)refreshBalance:(id)sender;


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

- (IBAction)refreshBalance:(id)sender {
    HTTPClient = [INYHTTPClient new];
    [HTTPClient RequestWithURL:ULRgetMoneyWithUserId option:self.detailItem];
}

- (void)configureView
{
    // Update the user interface for the detail item.

    if (self.detailItem) {
        self.detailDescriptionLabel.text = [self.detailItem description];
        
        
        HTTPClient = [INYHTTPClient new];
        [HTTPClient RequestWithURL:ULRgetMoneyWithUserId option:self.detailItem];
        
        self.Balance.text = HTTPClient.money;
        self.Currency.text = HTTPClient.currency;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"Master", @"Master");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}

@end
