//
//  GradientView.m
//  CleanYourScreen
//
//  Created by Jeff Harrison on 12/19/12.
//  Copyright (c) 2012 Magnet Tree. All rights reserved.
//

#import "GradientView.h"

@interface GradientView ()

@property CGContextRef context;

@end

@implementation GradientView

@synthesize context     = _context;
@synthesize startColor  = _startColor;
@synthesize endColor    = _endColor;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setContext:UIGraphicsGetCurrentContext()];
    }
    return self;
}

void drawLinearGradient(CGContextRef context, CGRect rect, CGColorRef startColor, CGColorRef endColor){
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat locations[] = { 0.0, 1.0 };
    
    NSArray *colors = [NSArray arrayWithObjects:(__bridge id)startColor, (__bridge id)endColor, nil];
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef) colors, locations);
    CGPoint startPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect));
    CGPoint endPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect));
    
    CGContextSaveGState(context);
    CGContextAddRect(context, rect);
    CGContextClip(context);
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    CGContextRestoreGState(context);
    
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
}


- (void)drawRect:(CGRect)rect
{
    drawLinearGradient(self.context, self.bounds, self.startColor, self.endColor);
}

@end
