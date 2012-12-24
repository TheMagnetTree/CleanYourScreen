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

@synthesize faceState = _faceState;
@synthesize bodyState = _bodyState;
@synthesize faceLayer = _faceLayer;
@synthesize bodyLayer = _bodyLayer;

- (void)setBodyLayer:(CALayer *)bodyLayer {
    _bodyLayer = bodyLayer;
}

- (CALayer *)bodyLayer {
    if(!_bodyLayer) {
        _bodyLayer = [CALayer layer];
    }
    return _bodyLayer;
}

- (void)setFaceLayer:(CALayer *)faceLayer {
    _faceLayer = faceLayer;
}

- (CALayer *)faceLayer {
    if(!_faceLayer) {
        _faceLayer = [CALayer layer];
    }
    return _faceLayer;
}

+ (GermView *)createGermViewWithBody:(NSString *)pathToBodyAtlas andFaces:(NSString *) pathToFaceAtlas {
    CGImageRef face = [UIImage imageWithContentsOfFile:pathToFaceAtlas].CGImage;
    CGImageRef body = [UIImage imageWithContentsOfFile:pathToFaceAtlas].CGImage;
    
    GermView *_germView = [[GermView alloc]init];
    [_germView setFaceAtlas:face];
    [_germView setBodyAtlas:body];
    
    return [_germView copy];
}

- (void)initBody {
    CGSize size = CGSizeMake(100, 100);
    CGSize normalizedSize = CGSizeMake(size.width / CGImageGetWidth(self.bodyAtlas), size.height / CGImageGetHeight(self.bodyAtlas));
    self.bodyLayer.bounds = CGRectMake(0, 0, size.width, size.height);
    self.bodyLayer.contentsRect = CGRectMake(0, 0, normalizedSize.width, normalizedSize.height);
}

- (void)initFace {
    CGSize size = CGSizeMake(100, 100);
    CGSize normalizedSize = CGSizeMake(size.width / CGImageGetWidth(self.faceAtlas), size.height / CGImageGetHeight(self.faceAtlas));
    self.faceLayer.bounds = CGRectMake(0, 0, size.width, size.height);
    self.faceLayer.contentsRect = CGRectMake(0, 0, normalizedSize.width, normalizedSize.height);
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
