//
//  SettingsViewController.m
//  CleanYourScreen
//
//  Created by Jeff Harrison on 1/18/13.
//  Copyright (c) 2013 Magnet Tree. All rights reserved.
//

#import "SettingsViewController.h"
#import "IntervalSettingsTableViewController.h"

@interface SettingsViewController ()
@property (weak, nonatomic) IBOutlet UISwitch *notificationEnableSwitch;
@property (strong, nonatomic) NSUserDefaults *defaults;

@end

@implementation SettingsViewController

@synthesize notificationEnableSwitch = _notificationEnableSwitch;
@synthesize defaults = _defaults;

- (void)setDefaults:(NSUserDefaults *)defaults {
    _defaults = defaults;
}

- (NSUserDefaults *)defaults {
    if(!_defaults) {
        _defaults = [NSUserDefaults standardUserDefaults];
    }
    return _defaults;
}

- (IBAction)notificationSwitchChanged:(id)sender {
    NSLog(@"Notification toggled to %d", [self.notificationEnableSwitch isOn]);
    [self.defaults setObject:[NSNumber numberWithBool:[self.notificationEnableSwitch isOn]]
                      forKey:@"enableNotifications"];
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
    if([[self.defaults objectForKey:@"enableNotifications"]boolValue] == YES)
    {
        [self.notificationEnableSwitch setOn:YES];
    }
    else
    {
        [self.notificationEnableSwitch setOn:NO];
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureView];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSDictionary *optionsDictionary;
    if([[segue identifier] isEqualToString:@"reminderSegue"])
    {
        optionsDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                             // Order is reversed in settings menu
                             // Create Dictionary with bottom option first
                             [NSNumber numberWithInteger:60 * 60], @"1 Hour"
                            ,[NSNumber numberWithInteger:60 * 30], @"30 Minutes [optimal]"
                            ,nil];
        IntervalSettingsTableViewController * dest =
        (IntervalSettingsTableViewController *)[segue destinationViewController];
        [dest setIntervalList:[optionsDictionary copy]];
    }
    
    else if([[segue identifier] isEqualToString:@"intervalSegue"])
    {
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
 */

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
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
