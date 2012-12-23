//
//  MTDJViewController.m
//  CleanYourScreen
//
//  Created by Jeff Harrison on 12/18/12.
//  Copyright (c) 2012 Magnet Tree. All rights reserved.
//

#import "ViewController.h"

@interface MTDJViewController ()

@property (strong, nonatomic) UILocalNotification *cleanMeNotifier;

@end

@implementation MTDJViewController

@synthesize cleanMeNotifier = _cleanMeNotifier;

- (void)setCleanMeNotfier:(UILocalNotification *)cleanMeNotifier {
    _cleanMeNotifier = cleanMeNotifier;
}

- (UILocalNotification *)cleanMeNotifier {
    if(!_cleanMeNotifier) {
        _cleanMeNotifier = [[UILocalNotification alloc] init];        
    }
    return _cleanMeNotifier;
}

- (NSDate *)nextFireDate {
    //TODO Placeholder -- determine based on user preferences
    return [NSDate dateWithTimeIntervalSinceNow:10];
}

- (IBAction)cleanButtonPressed:(id)sender {
    [self.cleanMeNotifier setFireDate:self.nextFireDate]; // need method that gets time requested
    [self.cleanMeNotifier setAlertBody:@"Clean me again!"];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0]; // overlaps with cancelAllLocalNotifications in a funky way. Doing both just in case.
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [[UIApplication sharedApplication] scheduleLocalNotification:self.cleanMeNotifier];
    // Clean up any UI goodness and save stats
}

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
