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

@end

@implementation GermView

@synthesize bodyAtlas = _bodyAtlas;
@synthesize faceAtlas = _faceAtlas;
@synthesize faceState = _faceState;
@synthesize bodyState = _bodyState;

#define BODY_WIDTH 100
#define BODY_HEIGHT 100

- (void)initBodyLayer {
    CGSize size = CGSizeMake(BODY_WIDTH, BODY_HEIGHT);
    CGSize normalizedSize = CGSizeMake(size.width / CGImageGetWidth(self.bodyAtlas), size.height / CGImageGetHeight(self.bodyAtlas));
    CALayer *bodyLayer = [[CALayer alloc]init];
    bodyLayer.bounds = CGRectMake(0, 0, size.width, size.height);
    bodyLayer.contentsRect = CGRectMake(0, 0, normalizedSize.width, normalizedSize.height);
    bodyLayer.contents = (id) self.bodyAtlas;
    [self.layer addSublayer:bodyLayer];
}

#define FACE_WIDTH 100
#define FACE_HEIGHT 100

- (void)initFaceLayer {
    CGSize size = CGSizeMake(FACE_WIDTH, FACE_HEIGHT);
    CGSize normalizedSize = CGSizeMake(size.width / CGImageGetWidth(self.faceAtlas), size.height / CGImageGetHeight(self.faceAtlas));
    CALayer *faceLayer = [[CALayer alloc] init];
    faceLayer.bounds = CGRectMake(0, 0, size.width, size.height);
    faceLayer.contentsRect = CGRectMake(0, 0, normalizedSize.width, normalizedSize.height);
    faceLayer.contents = (id) self.faceAtlas;
    [self.layer addSublayer:faceLayer];
}

- (void)setFaceAtlasWithPath:(NSString *)pathToFaceAtlas {
    NSString *path = [[NSBundle mainBundle] pathForResource:pathToFaceAtlas ofType:nil];
    self.faceAtlas = [UIImage imageWithContentsOfFile:path].CGImage;
    [self initFaceLayer];
}

- (void)setBodyAtlasWithPath:(NSString *)pathToBodyAtlas {
    NSString *path = [[NSBundle mainBundle] pathForResource:pathToBodyAtlas ofType:nil];
    self.bodyAtlas = [UIImage imageWithContentsOfFile:path].CGImage;
    [self initBodyLayer];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // init code
    }
    return self;
}

/*
- (void)drawRect:(CGRect)rect
{
}
 */

@end
