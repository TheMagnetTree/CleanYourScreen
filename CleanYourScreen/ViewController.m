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

- (void)setMyGerms:(NSMutableArray *)myGerms {
    _myGerms = myGerms;
}

- (NSMutableArray *)myGerms {
    if(!_myGerms) {
        _myGerms = [[NSMutableArray alloc]init];
    }
    return _myGerms;
}

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
    
    // Hide and remove all GermViews
    NSArray *germsToFade = [NSArray arrayWithArray:[self.myGerms copy]]; //Hold references so indexes don't move around when deleted from the mutablearray
    for(int i = 0; i  < [germsToFade count]; i++) {
        if([[self.myGerms objectAtIndex:i] isKindOfClass:[GermView class]]) {
            [UIView animateWithDuration:1.0f
                             animations:^{
                                 [[germsToFade objectAtIndex:i] setAlpha:0.0f];
                             }
                             completion:^(BOOL finished){
                                 [self.myGerms removeObject:[germsToFade objectAtIndex:i]];
                             }];
        }
    }
    // TODO Clean up any UI goodness and save stats
}


- (void)germPressed:(id)sender {
    /*
    if([sender isKindOfClass:[GermView class]]) {
        [sender blinkForSeconds:[NSNumber numberWithFloat:0.5]];
    }
    */
    if([sender isKindOfClass:[GermView class]]) {
        [sender blinkEyes:[NSNumber numberWithInt:2] withOpenDuration:[NSNumber numberWithFloat:0.15f]
                                                    withCloseDuration:[NSNumber numberWithFloat:0.05f]
                                                       withStartDelay:[NSNumber numberWithFloat:0.2f]];
    }
    
}

- (void)startLinearMovement:(UIView *)sender magnitude:(NSNumber *)magnitude directionInRadians:(NSNumber *)direction {
    if(magnitude && direction) {
        // What's our next move?
        double moveX = sender.frame.origin.x + ([magnitude doubleValue] * cos([direction doubleValue]));
        double moveY = sender.frame.origin.y + ([magnitude integerValue] * sin([direction doubleValue]));
        
        // If out of bounds and moving farther out of bounds then mirror them by adding PI radians
        if(moveX < 0 && ([direction doubleValue] > M_PI/2 || [direction doubleValue] < M_PI/2*3)) {
            direction = [NSNumber numberWithDouble:M_PI + [direction doubleValue]]; // add some variance
            if([direction doubleValue] >= 360)
                direction = [NSNumber numberWithDouble:[direction doubleValue] - 360 ];
        }
        else if(moveX > self.view.frame.size.width - sender.frame.size.width && ([direction doubleValue] > M_PI/2*3 || [direction doubleValue] < M_PI/2)) {
            direction = [NSNumber numberWithDouble:M_PI + [direction doubleValue]];
            if([direction doubleValue] >= 360)
                direction = [NSNumber numberWithDouble:[direction doubleValue] - 360 ];
        }
        else if(moveY < 0 && ([direction doubleValue] > M_PI || [direction doubleValue] < 0)) {
            direction = [NSNumber numberWithDouble:M_PI + [direction doubleValue]];
            if([direction doubleValue] >= 360)
                direction = [NSNumber numberWithDouble:[direction doubleValue] - 360 ];
        }
        else if(moveY > self.view.frame.size.height - sender.frame.size.height && ([direction doubleValue] > 0 || [direction doubleValue] < M_PI)) {
            direction = [NSNumber numberWithDouble:M_PI + [direction doubleValue]];
            if([direction doubleValue] >= 360)
                direction = [NSNumber numberWithDouble:[direction doubleValue] - 360 ];
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

- (void)startRandomMovement:(GermView *)sender{
    //NSLog(@"Starting Random Movement...\n");
    if(YES) {
        // What's our next move?
        double moveX = sender.frame.origin.x + ([sender.velocityMagnitude doubleValue] * cos([sender.velocityDirectionInRadians doubleValue]));
        double moveY = sender.frame.origin.y + ([sender.velocityMagnitude doubleValue] * sin([sender.velocityDirectionInRadians doubleValue]));
        
        NSNumber* direction = sender.velocityDirectionInRadians;
        
        // If out of bounds and moving farther out of bounds then mirror them by adding PI radians
        if(moveX < 0 && ([direction doubleValue] > M_PI/2 || [direction doubleValue] < M_PI/2*3)) {
            direction = [NSNumber numberWithDouble:M_PI + [direction doubleValue]]; // add some variance
            if([direction doubleValue] >= 360)
                direction = [NSNumber numberWithDouble:[direction doubleValue] - 360 ];
        }
        else if(moveX > self.view.frame.size.width - sender.frame.size.width && ([direction doubleValue] > M_PI/2*3 || [direction doubleValue] < M_PI/2)) {
            direction = [NSNumber numberWithDouble:M_PI + [direction doubleValue]];
            if([direction doubleValue] >= 360)
                direction = [NSNumber numberWithDouble:[direction doubleValue] - 360 ];
        }
        else if(moveY < 50 && ([direction doubleValue] > M_PI || [direction doubleValue] < 0)) {
            direction = [NSNumber numberWithDouble:M_PI + [direction doubleValue]];
            if([direction doubleValue] >= 360)
                direction = [NSNumber numberWithDouble:[direction doubleValue] - 360 ];
        }
        else if(moveY > self.view.frame.size.height - sender.frame.size.height && ([direction doubleValue] > 0 || [direction doubleValue] < M_PI)) {
            direction = [NSNumber numberWithDouble:M_PI + [direction doubleValue]];
            if([direction doubleValue] >= 360)
                direction = [NSNumber numberWithDouble:[direction doubleValue] - 360 ];
        }
        
        [sender setVelocityDirectionInRadians:direction];
        
        
        [UIView animateWithDuration:1/30
                              delay:0.0
                            options: UIViewAnimationOptionAllowUserInteraction
                         animations:^{
                             sender.frame = CGRectMake( moveX,
                                                       moveY,
                                                       sender.frame.size.width,
                                                       sender.frame.size.height);
                         }
                         completion:^(BOOL finished){
                             [self startRandomMovement:sender];
                         }];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
    double sizemodifier = 1;
    
    for(int i = 0; i < 80; i++) {
        GermView *myGerm = [[GermView alloc]init];
        int germsize = 80 - arc4random()%10;
        
        germsize = germsize * sizemodifier;
        [myGerm setBounds:CGRectMake(0, 0, germsize, germsize)];
        //[myGerm setCenter:CGPointMake(arc4random() % (int)self.view.frame.size.width + germsize/2 - 5, arc4random() % (int)(self.view.frame.size.height - 50) - germsize/2 + 5 + 50)]; // prevent spawning in walls
        [myGerm setCenter:CGPointMake(arc4random() % (int)(self.view.frame.size.width - germsize) + germsize/2, arc4random() % (int)(self.view.frame.size.height - 50 - germsize) + germsize/2 + 50)]; // prevent spawning in walls
        
        
        //Decide Type of Germ
        int randomnumber = i%3;
        
        if(randomnumber == 0) {
            [myGerm setBodyAtlasWithPath:@"Atlas1Skull.png"];
            [myGerm setFaceAtlasWithPath:@"Atlas1Skull.png"];
        }
        else if(randomnumber == 1){
            [myGerm setBodyAtlasWithPath:@"Atlas1Blob.png"];
            [myGerm setFaceAtlasWithPath:@"Atlas1Blob.png"];
        }
        else {
            [myGerm setBodyAtlasWithPath:@"Atlas1EColi.png"];
            [myGerm setFaceAtlasWithPath:@"Atlas1EColi.png"];
        }
        
        [myGerm addTarget:self action:@selector(germPressed:) forControlEvents:UIControlEventTouchUpInside];
        [myGerm randomizeTargetVelocity];
        [myGerm setMaxMagnitudeIncrement:[NSNumber numberWithDouble:0.001f*sizemodifier]];
        [myGerm setMaxDirectionIncrement:[NSNumber numberWithDouble:(M_PI / 16 / sizemodifier)]];
        [self.view insertSubview:myGerm atIndex:0];
        [self.myGerms addObject:[self.view.subviews objectAtIndex:0]];
        
        
        //[self startLinearMovement:myGerm magnitude:[NSNumber numberWithDouble:(arc4random() % 300 / 100 + .5)] directionInRadians:[NSNumber numberWithDouble:(arc4random() % 3600) * M_PI / 1800]];
        
        [NSTimer scheduledTimerWithTimeInterval:1.0f target:myGerm selector:@selector(randomizeTargetVelocity) userInfo:nil repeats:YES];   //Periodically Changes Target Velocity
        
        
        
        [self startRandomMovement:myGerm];
        
        //Start timers for velocity changes
        
        [NSTimer scheduledTimerWithTimeInterval:0.1f target:myGerm selector:@selector(incrementVelocityToTarget) userInfo:nil repeats:YES];     //Periodically Updates Velocity
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
