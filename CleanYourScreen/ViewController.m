//
//  MTDJViewController.m
//  CleanYourScreen
//
//  Created by Jeff Harrison on 12/18/12.
//  Copyright (c) 2012 Magnet Tree. All rights reserved.
//

#import "ViewController.h"
#import "GermView.h"

@interface ViewController ()

@property (strong, nonatomic) UILocalNotification *cleanMeNotifier;
@property (strong, nonatomic) NSMutableArray *myGerms;

@end

@implementation ViewController

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
    //TODO Placeholder -- determine based on user preferences / whatever
    return [NSDate dateWithTimeIntervalSinceNow:10];
}

- (IBAction)cleanButtonPressed:(id)sender {
    [self.cleanMeNotifier setFireDate:self.nextFireDate];
    [self.cleanMeNotifier setAlertBody:@"Clean me again!"];
    
    // overlaps with cancelAllLocalNotifications in a funky way. Doing both just in case.
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0]; 
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    [[UIApplication sharedApplication] scheduleLocalNotification:self.cleanMeNotifier];
    // TODO Clean up any UI goodness and save stats
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    GermView *myGerm = [[GermView alloc]init];
    [myGerm setBounds:CGRectMake(0, 0, 75, 75)];
    [myGerm setCenter:self.view.center];
    [myGerm setBodyAtlasWithPath:@"GermBodyPlaceholder.png"];
    [myGerm setFaceAtlasWithPath:@"GermFaceAtlas.png"];
    [myGerm addTarget:self action:@selector(germPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:myGerm];
}

- (void)germPressed:(id)sender {
    [sender blinkForSeconds:[NSNumber numberWithFloat:0.5]];
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
