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
@property (strong, nonatomic) NSMutableArray *myGerms; // keep track of the views that are germs

@end

@implementation ViewController

@synthesize cleanMeNotifier = _cleanMeNotifier;
@synthesize myGerms = _myGerms;

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
    for(int i = 0; i < 20; i++) {
        GermView *myGerm = [[GermView alloc]init];
        [myGerm setBounds:CGRectMake(0, 0, 50, 50)];
        [myGerm setCenter:self.view.center];
        [myGerm setBodyAtlasWithPath:@"GermBodyPlaceholder.png"];
        [myGerm setFaceAtlasWithPath:@"GermFaceAtlas.png"];
        [myGerm addTarget:self action:@selector(germPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.view insertSubview:myGerm atIndex:0];
        [self.myGerms addObject:[self.view.subviews objectAtIndex:0]];
        [self startLinearMovement:myGerm magnitude:[NSNumber numberWithDouble:(arc4random() % 300 / 100 + .5)] directionInRadians:[NSNumber numberWithDouble:(arc4random() % 360) * M_PI / 180]];
    }
}

- (void)germPressed:(id)sender {
    if([sender isKindOfClass:[GermView class]]) {
        [sender blinkForSeconds:[NSNumber numberWithFloat:0.5]];
    }
}

- (void)startLinearMovement:(UIView *)sender magnitude:(NSNumber *)magnitude directionInRadians:(NSNumber *)direction {
    if(magnitude && direction) {
        double moveX = sender.frame.origin.x + ([magnitude doubleValue] * cos([direction doubleValue]));
        if(moveX < 0 && ([magnitude doubleValue] > M_PI/2 || [magnitude doubleValue] < M_PI/2*3)) {
            direction = [NSNumber numberWithDouble:M_PI + [direction doubleValue]];
        }
        else if(moveX > self.view.frame.size.width - sender.frame.size.width) {
            direction = [NSNumber numberWithDouble:M_PI + [direction doubleValue]];
        }
        
        double moveY = sender.frame.origin.y + ([magnitude integerValue] * sin([direction doubleValue]));
        if(moveY < 0) {
            direction = [NSNumber numberWithDouble:M_PI + [direction doubleValue]];
        }
        else if(moveY > self.view.frame.size.height - sender.frame.size.height) {
            direction = [NSNumber numberWithDouble:M_PI + [direction doubleValue]];
        }
        
        
        [UIView animateWithDuration:0.1
                              delay:0.0
                            options: UIViewAnimationOptionAllowUserInteraction
                         animations:^{
                             sender.frame = CGRectMake( moveX,
                                                     moveY,
                                                     sender.frame.size.width,
                                                     sender.frame.size.height);
                         }
                         completion:^(BOOL finished){
                             [self startLinearMovement:sender magnitude:magnitude directionInRadians:direction];
                         }];
    }
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
