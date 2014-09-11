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
    //    INYHTTPClient *HTTPClient;
    NSArray *balances;
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
    //HTTPClient = [INYHTTPClient new];
    //[HTTPClient RequestWithURL:ULRgetMoneyWithUserId option:self.detailItem];
    [self configureView];
}

- (void)configureView
{
    balances = [[INYLibraryAPI sharedInstance] getBalanceWithUserId:_detailItem];
 //   NSLog(@"_detailItem %@",_detailItem);
 //   NSLog(@"balances %d",[balances count]);
    // Update the user interface for the detail item.

    if (self.detailItem) {
        self.detailDescriptionLabel.text = [self.detailItem description];
        
        
 //       HTTPClient = [INYHTTPClient new];
 //       [HTTPClient RequestWithURL:ULRgetMoneyWithUserId option:self.detailItem];
        
  //      self.Balance.text = HTTPClient.money;
  //      self.Currency.text = HTTPClient.currency;
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
    
    INYBalance *cellBalance = balances[indexPath.row];
    
    NSNumberFormatter *formatter = [NSNumberFormatter new];
    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [formatter setLocale:[self findLocaleByCurrencyCode:cellBalance.currency]];
    [formatter setCurrencyCode:cellBalance.currency];
    NSString *currencyString = [formatter stringFromNumber:@([cellBalance.balance floatValue])];
    cell.textLabel.text = currencyString;
    return cell;
}

- (NSLocale *) findLocaleByCurrencyCode:(NSString *)_currencyCode
{
    NSArray *locales = [NSLocale availableLocaleIdentifiers];
    NSLocale *locale = nil;
    NSString *localeId;
    
    for (localeId in locales) {
        locale = [[NSLocale alloc] initWithLocaleIdentifier:localeId] ;
        NSString *code = [locale objectForKey:NSLocaleCurrencyCode];
        if ([code isEqualToString:_currencyCode])
            break;
        else
            locale = nil;
    }
    
    /* For some codes that locale cannot be found, init it different way. */
    if (locale == nil) {
        NSDictionary *components = [NSDictionary dictionaryWithObject:_currencyCode
                                                               forKey:NSLocaleCurrencyCode];
        
        localeId = [NSLocale localeIdentifierFromComponents:components];
        locale = [[NSLocale alloc] initWithLocaleIdentifier:localeId];
    }
    return locale;
}

@end
