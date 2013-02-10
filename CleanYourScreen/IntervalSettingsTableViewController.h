//
//  IntervalSettingsTableViewController.h
//  CleanYourScreen
//
//  Created by Jeff Harrison on 1/18/13.
//  Copyright (c) 2013 Magnet Tree. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IntervalSettingsTableViewController : UITableViewController

// Keys are the cell's text and values are the cell's values
- (void) setIntervalList:(NSArray *) intervalList;

@end
