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
    
    
    //////////////////////////////////////////////////////////////////////
    //[dataTable reloadData];
    //////////////////////////////////////////////////////////////////////
    
    /*
    
    
    
    HTTPClient = [INYHTTPClient new];
    [HTTPClient RequestWithURL:ULRshowUsers option:@""];
    NSLog(@"viewDidLoad %@",HTTPClient.name);
    */
    
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    //self.navigationItem.leftBarButtonItem = self.editButtonItem;

    //UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    //self.navigationItem.rightBarButtonItem = addButton;
    self.detailViewController = (INYDetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
 
    
    
    
    
    allUsers = [[INYLibraryAPI sharedInstance] getUsers];
    
    
    
 //   dataTable = [UITableView new];
    
    UIBarButtonItem *addButtonRefresh = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshTable)];
    self.navigationItem.rightBarButtonItem = addButtonRefresh;
    [self refreshTable];
}

- (void)refreshTable
{
    [[INYLibraryAPI sharedInstance]RequestWithURL:ULRshowUsers option:@""];
    [dataTable reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)insertNewObject:(id)sender
{
    /*
     
     
     
     
     
    if (!_objects) {
        _objects = [[NSMutableArray alloc] init];
    }
    [_objects insertObject:[NSDate date] atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    */
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
 //   currentUsersData = [users tr_tableRepresentation];
    
    
    cell.textLabel.text = [[NSString alloc] initWithFormat:@"%@ %@",users.name,users.secondName];
 //   cell.detailTextLabel.text = currentUsersData[@"values"];
  /*
    
    
    

    //NSDate *object = _objects[indexPath.row];
    //cell.textLabel.text = [object description];
    
    cell.textLabel.text = [HTTPClient.name stringByAppendingString:[NSString stringWithFormat:@" %@", HTTPClient.secondName]];
   */
   return cell;
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
    
    
    
    
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
    */
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        //INYUsers *cellDidSelected = allUsers[indexPath.row];
        //self.detailViewController.detailItem = cellDidSelected.idUser;
        self.detailViewController.detailItem = [[INYLibraryAPI sharedInstance] getUserIdWithIndex:indexPath];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        [[segue destinationViewController] setDetailItem:[[INYLibraryAPI sharedInstance] getUserIdWithIndex:indexPath]];
        //[[segue destinationViewController] setDetailItem:HTTPClient.idUser];
    }
}

@end
