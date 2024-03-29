//
//  MTDJViewController.m
//  CleanYourScreen
//
//  Created by Jeff Harrison on 12/18/12.
//  Copyright (c) 2012 Magnet Tree. All rights reserved.
//

#import "ViewController.h"
#import "GermView.h"
#import "CardSliderView.h"

@interface ViewController ()

@property (strong, nonatomic) UILocalNotification *cleanMeNotifier;
@property (strong, nonatomic) NSMutableArray *myGerms; // keep track of the views that are germs
@property (strong, nonatomic) NSUserDefaults *defaults;
@property (weak, nonatomic) IBOutlet CardSliderView *cardSliderView;
@end

@implementation ViewController

@synthesize cleanMeNotifier = _cleanMeNotifier;
@synthesize myGerms = _myGerms;
@synthesize defaults = _defaults;

- (void)setMyGerms:(NSMutableArray *)myGerms {
    _myGerms = myGerms;
}

- (NSMutableArray *)myGerms {
    if(!_myGerms) {
        _myGerms = [[NSMutableArray alloc]init];
    }
    return _myGerms;
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

- (void)setCleanMeNotfier:(UILocalNotification *)cleanMeNotifier {
    _cleanMeNotifier = cleanMeNotifier;
}

- (UILocalNotification *)cleanMeNotifier {
    if(!_cleanMeNotifier) {
        _cleanMeNotifier = [[UILocalNotification alloc] init];        
    }
    return _cleanMeNotifier;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1)
        [self cleanTheScreen];
}

// when to remind user to clean screen
- (NSDate *)nextFireDate {
    NSNumber *reminderInterval = [self.defaults objectForKey:@"reminderInterval"];
    return [NSDate dateWithTimeIntervalSinceNow:[reminderInterval integerValue]];
}

- (IBAction)swipeRightOnCardView:(id)sender {
    [self.cardSliderView transitionLeft];
}

- (IBAction)swipeLeftOnCardView:(id)sender {
    [self.cardSliderView transitionRight];
}

- (IBAction)cleanButtonPressed:(id)sender {
    
    UIAlertView *cleanAlert= [[UIAlertView alloc] initWithTitle:@"Clean your screen!"
                                             message:@"Press Done when finished cleaning"
                                                       delegate:self
                                    cancelButtonTitle:@"Cancel"
                                   otherButtonTitles:@"Done", nil];
    [cleanAlert show];
}

- (void)germPressed:(id)sender {
    if([sender isKindOfClass:[GermView class]]) {
        [sender blinkEyes:[NSNumber numberWithInt:2] withOpenDuration:[NSNumber numberWithFloat:0.15f]
                                                    withCloseDuration:[NSNumber numberWithFloat:0.05f]
                                                       withStartDelay:[NSNumber numberWithFloat:0.2f]];
        NSLog(@"I have path:%@", [sender path]);
    }
}

- (void)cleanTheScreen
{
    [self.cleanMeNotifier setFireDate:self.nextFireDate];
    [self.cleanMeNotifier setRepeatInterval:[[self.defaults objectForKey:@"repeatInterval"] integerValue]];
    [self.cleanMeNotifier setAlertBody:@"Time to clean your screen"];
    
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
                             sender.frame = CGRectMake(moveX,
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
                             sender.frame = CGRectMake(moveX,
                                                       moveY,
                                                       sender.frame.size.width,
                                                       sender.frame.size.height);
                         }
                         completion:^(BOOL finished){
                             [self startRandomMovement:sender];
                         }];
    }
}

- (void)initCardSliderView {
    NSMutableArray *cards = [[NSMutableArray alloc]init];
    CGRect cardRect = CGRectMake(0
                                ,0
                                ,self.cardSliderView.frame.size.width
                                ,self.cardSliderView.frame.size.height);
    
    // Create cards and add to array
    UIView *card1 = [[UIView alloc] initWithFrame:cardRect];
    UIImage *cardImage1 = [UIImage imageNamed:@"test card.png"];
    UIImageView *cardImageView1 = [[UIImageView alloc] initWithFrame:cardRect];
    [cardImageView1 setContentMode:UIViewContentModeScaleAspectFill];
    [cardImageView1 setImage:cardImage1];
    [card1 addSubview:cardImageView1];
    [cards addObject:card1];
    
    UIView *card = [[UIView alloc] initWithFrame:cardRect];
    UIImage *cardImage = [UIImage imageNamed:@"test card.png"];
    UIImageView *cardImageView = [[UIImageView alloc] initWithFrame:cardRect];
    [cardImageView setContentMode:UIViewContentModeScaleAspectFill];
    [cardImageView setImage:cardImage];
    [card addSubview:cardImageView];
    [cards addObject:card];
    
    [self.cardSliderView setCardArray:[NSArray arrayWithArray:cards]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    if([[self.defaults objectForKey:@"firstRun"] boolValue] == YES) {
        [self.cardSliderView setHidden:NO];
        [self.defaults setObject:[NSNumber numberWithBool:NO] forKey:@"firstRun"];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    [self initCardSliderView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    const double sizemodifier = 1;
    
    // TODO: Determine how many germs will spawn when loaded
    for(int i = 0; i < 100; i++) {
        GermView *myGerm = [[GermView alloc]init];
        int germsize = 80;// - arc4random() % 10;
        
        germsize = germsize * sizemodifier;
        [myGerm setBounds:CGRectMake(0, 0, germsize, germsize)];
        //[myGerm setCenter:CGPointMake(arc4random() % (int)self.view.frame.size.width + germsize/2 - 5, arc4random() % (int)(self.view.frame.size.height - 50) - germsize/2 + 5 + 50)]; // prevent spawning in walls
        [myGerm setCenter:CGPointMake(arc4random() % (int)(self.view.frame.size.width - germsize) + germsize/2, arc4random() % (int)(self.view.frame.size.height - 50 - germsize) + germsize/2 + 50)]; // prevent spawning in walls
        
        
        //Decide Type of Germ
        int randomnumber = 0;
        
        if(randomnumber == 0) {
            [myGerm setBodyAtlasWithPath:@"Atlas1Blob100.png"];
            [myGerm setFaceAtlasWithPath:@"Atlas1Blob100.png"];
        }
        
        [myGerm addTarget:self action:@selector(germPressed:) forControlEvents:UIControlEventTouchUpInside];
        [myGerm randomizeTargetVelocity];
        [myGerm setMaxMagnitudeIncrement:[NSNumber numberWithDouble:0.001f * sizemodifier]];
        [myGerm setMaxDirectionIncrement:[NSNumber numberWithDouble:(M_PI / 16 / sizemodifier)]];
        [self.view insertSubview:myGerm atIndex:0];
        [self.myGerms addObject:[self.view.subviews objectAtIndex:0]];
        
        [self startLinearMovement:myGerm magnitude:[NSNumber numberWithDouble:(arc4random() % 300 / 100 + .5)] directionInRadians:[NSNumber numberWithDouble:(arc4random() % 3600) * M_PI / 1800]];
        
        //[NSTimer scheduledTimerWithTimeInterval:1.0f target:myGerm selector:@selector(randomizeTargetVelocity) userInfo:nil repeats:YES];   //Periodically Changes Target Velocity
        
        //[self startRandomMovement:myGerm];
        
        //Start timers for velocity changes
        
        //[NSTimer scheduledTimerWithTimeInterval:0.1f target:myGerm selector:@selector(incrementVelocityToTarget) userInfo:nil repeats:YES];     //Periodically Updates Velocity
    }
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
