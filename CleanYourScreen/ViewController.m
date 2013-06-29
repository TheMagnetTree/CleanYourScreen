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

- (void)startMovement:(UIView*)sender vecX:(float)x vecY:(float)y {
    float nextX = sender.frame.origin.x + x;
    float nextY = sender.frame.origin.y + y;
    
    bool reflect = NO;
    float normal[2] = {0, 0};
    
    if(nextX < 0 - sender.frame.size.width) {
        reflect = YES;
        normal[0] = 1;
    }
    else if(nextX > self.view.frame.size.width) {
        reflect = YES;
        normal[0] = -1;
    }
    if(nextY < 0 - sender.frame.size.height) {
        reflect = YES;
        normal[1] = 1;
    }
    else if(nextY > self.view.frame.size.height) {
        reflect = YES;
        normal[1] = -1;
    }
    
    if(reflect == YES) {
        // r = d - 2(d dot n)n
        float normalMagnitude = sqrtf((float)abs(normal[0]) + (float)abs(normal[1]));
        float dot_product = normal[0] * x + normal[1] * y;
        dot_product *= 2;
        dot_product /= (normalMagnitude * normalMagnitude);
        normal[0] *= dot_product;
        normal[1] *= dot_product;
        x -= normal[0];
        y -= normal[1];
        // vector is now reflected
        nextX = sender.frame.origin.x + x;
        nextY = sender.frame.origin.y + y;
    }
    
    [UIView animateWithDuration:0.1
            delay:0.0
            options: UIViewAnimationOptionAllowUserInteraction
            animations:^{
                sender.frame = CGRectMake(nextX,
                                          nextY,
                                          sender.frame.size.width,
                                          sender.frame.size.height);
                 }
                 completion:^(BOOL finished){
                     [self startMovement:sender vecX:x vecY:y];
                 }];
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
        
        [myGerm setCenter:CGPointMake(arc4random() % ((int)self.view.frame.size.width - germsize) + germsize/2,
                                      arc4random() % ((int)self.view.frame.size.height - germsize * 2) + germsize)];
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
        
        [self startMovement:myGerm vecX: arc4random() % 5 + 1 vecY: arc4random() % 5 + 1];
        
    }
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
