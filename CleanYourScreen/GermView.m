//
//  GermView.m
//  CleanYourScreen
//
//  Created by Jeff Harrison on 12/23/12.
//  Copyright (c) 2012 Magnet Tree. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "GermView.h"

@interface GermView ()

@property CGImageRef faceAtlas;
@property CGImageRef bodyAtlas;
@property CALayer *faceLayer;
@property CALayer *bodyLayer;


@end

@implementation GermView

@synthesize velocityMagnitude = _velocityMagnitude;
@synthesize velocityDirectionInRadians = _velocityDirectionInRadians;
@synthesize targetMagnitude = _targetMagnitude;
@synthesize targetDirectionInRadians = _targetDirectionInRadians;
@synthesize maxMagnitudeIncrement = _maxMagnitudeIncrement;
@synthesize maxDirectionIncrement = _maxDirectionIncrement;

@synthesize faceAtlas = _faceAtlas;
@synthesize bodyAtlas = _bodyAtlas;
@synthesize faceLayer = _faceLayer;
@synthesize bodyLayer = _bodyLayer;

// I basically do the same thing twice with face/body... DERP lernan
#define BODY_WIDTH 256
#define BODY_HEIGHT 256

- (void)setBodyAtlasWithPath:(NSString *)pathToBodyAtlas {
    NSString *path = [[NSBundle mainBundle] pathForResource:pathToBodyAtlas ofType:nil];
    self.bodyAtlas = [UIImage imageWithContentsOfFile:path].CGImage;
    [self initBodyLayer];
}

- (void)initBodyLayer {
    CGSize size = CGSizeMake(BODY_WIDTH, BODY_HEIGHT);
    CGSize normalizedSize = CGSizeMake(size.width / CGImageGetWidth(self.bodyAtlas), size.height / CGImageGetHeight(self.bodyAtlas));
    CALayer *bodyLayer = [[CALayer alloc]init];
    bodyLayer.bounds = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    bodyLayer.anchorPoint = CGPointMake(0, 0);
    bodyLayer.contentsRect = CGRectMake(0, 0, normalizedSize.width, normalizedSize.height);
    bodyLayer.contents = (id) self.bodyAtlas;
    [self.layer addSublayer:bodyLayer];
    [self setBodyLayer:[self.layer.sublayers objectAtIndex:0]];
    NSMutableDictionary *newActions = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                       [NSNull null], @"contentsRect",
                                       nil];
    self.faceLayer.actions = newActions;
}

#define FACE_WIDTH 256
#define FACE_HEIGHT 256

- (void)setFaceAtlasWithPath:(NSString *)pathToFaceAtlas {
    NSString *path = [[NSBundle mainBundle] pathForResource:pathToFaceAtlas ofType:nil];
    self.faceAtlas = [UIImage imageWithContentsOfFile:path].CGImage;
    [self initFaceLayer];
}

- (void)initFaceLayer {
    CGSize size = CGSizeMake(FACE_WIDTH, FACE_HEIGHT);
    CGSize normalizedSize = CGSizeMake(size.width / CGImageGetWidth(self.faceAtlas), size.height / CGImageGetHeight(self.faceAtlas));
    CALayer *faceLayer = [[CALayer alloc] init];
    faceLayer.bounds = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    faceLayer.contentsRect = CGRectMake(0, 0, normalizedSize.width, normalizedSize.height);
    faceLayer.anchorPoint = CGPointMake(0, 0);
    faceLayer.contents = (id) self.faceAtlas;
    [self.layer addSublayer:faceLayer];
    [self setFaceLayer:[self.layer.sublayers objectAtIndex:1]];
    NSMutableDictionary *newActions = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[NSNull null], @"contentsRect",
                                       nil];
    self.faceLayer.actions = newActions;
}

- (void)openEyes {
    self.faceLayer.contentsRect = CGRectMake(0, 0, .5, 1);
}

- (void)closeEyes {
    self.faceLayer.contentsRect = CGRectMake(.5, 0, .5, 1);
}

- (void)blinkForSeconds:(NSNumber *)seconds {
    
    self.faceLayer.contentsRect = CGRectMake(.5, 0, .5, 1);
    [NSTimer scheduledTimerWithTimeInterval:seconds.floatValue target:self selector:@selector(openEyes) userInfo:nil repeats:NO];
}

- (void)blinkEyes:(NSNumber *)numTimes withOpenDuration:(NSNumber *)openSeconds
                                       withCloseDuration:(NSNumber *)closeSeconds
                                       withStartDelay:(NSNumber *)delaySeconds
{
    float nextClose = 0;
    float nextOpen = 0;
    for(int blinkNum=0; blinkNum<numTimes.intValue; blinkNum++){
        nextClose = delaySeconds.floatValue + blinkNum * (openSeconds.floatValue + 0.1f);
        nextOpen = nextClose + 0.1f;
        [NSTimer scheduledTimerWithTimeInterval:nextClose target:self selector:@selector(closeEyes) userInfo:nil repeats:NO];
        [NSTimer scheduledTimerWithTimeInterval:nextOpen target:self selector:@selector(openEyes) userInfo:nil repeats:NO];
    }
}

- (void)randomizeTargetVelocity {
    [self setTargetMagnitude:[NSNumber numberWithDouble:(arc4random() % 300 / 1200 + .5)]];
    [self setTargetDirectionInRadians:[NSNumber numberWithDouble:(arc4random() % 3600) * M_PI / 1800]];
}

- (void)incrementVelocityToTarget {
    double targetMag = self.targetMagnitude.doubleValue;
    double targetDir = self.targetDirectionInRadians.doubleValue;
    double currMag = self.velocityMagnitude.doubleValue;
    double currDir = self.velocityDirectionInRadians.doubleValue;
    double mag = self.maxMagnitudeIncrement.doubleValue;
    double dir = self.maxDirectionIncrement.doubleValue;
    
    if(targetMag - currMag > mag/2) currMag += mag;
    else if(targetMag - currMag < mag/2) currMag -= mag;
    else currMag = targetMag;
    
    if(targetDir - currDir > dir/2) currDir += dir;
    else if(targetDir - currDir < dir/2) currDir -= dir;
    else currDir = targetDir;
    
    [self setVelocityMagnitude:[NSNumber numberWithDouble:currMag]];
    [self setVelocityDirectionInRadians:[NSNumber numberWithDouble:currDir]];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

/*
- (void)drawRect:(CGRect)rect
{
}
 */

@end
