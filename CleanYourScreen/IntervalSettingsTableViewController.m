//
//  IntervalSettingsTableViewController.m
//  CleanYourScreen
//
//  Created by Jeff Harrison on 1/18/13.
//  Copyright (c) 2013 Magnet Tree. All rights reserved.
//

#import "IntervalSettingsTableViewController.h"

@interface IntervalSettingsTableViewController ()

@property (strong, nonatomic) NSArray *intervalList;
@property (strong, nonatomic) NSUserDefaults *defaults;
@property (strong, nonatomic) NSIndexPath *lastIndexPath;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation IntervalSettingsTableViewController

@synthesize intervalList = _intervalList;
@synthesize tableView = _tableView;
@synthesize defaults = _defaults;
@synthesize lastIndexPath = _lastIndexPath;

- (NSArray *)intervalList {
    if(!_intervalList)
        _intervalList = [[NSArray alloc] init];
    return _intervalList;
}

- (void)setIntervalList:(NSArray *)intervalList {
    _intervalList = intervalList;
}

- (void)setDefaults:(NSUserDefaults *)defaults {
    _defaults = defaults;
}

- (NSUserDefaults *)defaults {
    if(!_defaults) {
        _defaults = [NSUserDefaults standardUserDefaults];
    }
    return _defaults;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)configureView
{
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

/*
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.intervalList count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [[self.intervalList allKeys] objectAtIndex:section];
}
 */

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.intervalList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"intervalSelectionCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    if([indexPath compare:self.lastIndexPath] == NSOrderedSame) //(cellLabel == [self.defaults objectForKey:@"notificationInterval"])
    {
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    }
    else
    {
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
    NSString *cellLabel = [self.intervalList objectAtIndex:[indexPath row]];
    cell.textLabel.text = cellLabel;
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

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

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    [self.defaults setObject:[self.intervalList objectAtIndex:[indexPath row]] forKey:@"notificationInterval"];
     */
    self.lastIndexPath = indexPath;
    [tableView reloadData];
}

@end
