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

@synthesize faceAtlas = _faceAtlas;
@synthesize bodyAtlas = _bodyAtlas;
@synthesize faceLayer = _faceLayer;
@synthesize bodyLayer = _bodyLayer;
@synthesize faceState = _faceState;
@synthesize bodyState = _bodyState;

#define BODY_WIDTH 100
#define BODY_HEIGHT 100

- (void)setBodyAtlasWithPath:(NSString *)pathToBodyAtlas {
    NSString *path = [[NSBundle mainBundle] pathForResource:pathToBodyAtlas ofType:nil];
    self.bodyAtlas = [UIImage imageWithContentsOfFile:path].CGImage;
    [self initBodyLayer];
}

- (void)initBodyLayer {
    CGSize size = CGSizeMake(BODY_WIDTH, BODY_HEIGHT);
    CGSize normalizedSize = CGSizeMake(size.width / CGImageGetWidth(self.bodyAtlas), size.height / CGImageGetHeight(self.bodyAtlas));
    CALayer *bodyLayer = [[CALayer alloc]init];
    NSLog(@"%f", self.bounds.size.width);
    bodyLayer.bounds = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    bodyLayer.contentsRect = CGRectMake(0, 0, normalizedSize.width, normalizedSize.height);
    bodyLayer.contents = (id) self.bodyAtlas;
    [self.layer addSublayer:bodyLayer];
    [self setBodyLayer:[self.layer.sublayers objectAtIndex:0]];
    NSMutableDictionary *newActions = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                       [NSNull null], @"contentsRect",
                                       nil];
    self.faceLayer.actions = newActions;
}

#define FACE_WIDTH 100
#define FACE_HEIGHT 100

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
    faceLayer.contents = (id) self.faceAtlas;
    [self.layer addSublayer:faceLayer];
    [self setFaceLayer:[self.layer.sublayers objectAtIndex:1]];
    NSMutableDictionary *newActions = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[NSNull null], @"onOrderIn",
                                       [NSNull null], @"onOrderOut",
                                       [NSNull null], @"sublayers",
                                       [NSNull null], @"contentsRect",
                                       [NSNull null], @"bounds",
                                       nil];
    self.faceLayer.actions = newActions;
}

- (void)openEyes {
    self.faceLayer.contentsRect = CGRectMake(0, 0, .5, 1);
}

- (void)blinkForSeconds:(NSNumber *)seconds {
    self.faceLayer.contentsRect = CGRectMake(.5, 0, .5, 1);
    [NSTimer scheduledTimerWithTimeInterval:seconds.floatValue target:self selector:@selector(openEyes) userInfo:nil repeats:NO];
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
