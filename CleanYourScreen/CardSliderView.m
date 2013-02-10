//
//  CardSliderView.m
//  CleanYourScreen
//
//  Created by Jeff Harrison on 2/9/13.
//  Copyright (c) 2013 Magnet Tree. All rights reserved.
//

#import "CardSliderView.h"

@interface CardSliderView()
@property (strong, nonatomic) NSArray *cardArray;
@property (atomic) NSInteger currentArrayPosition;
@end

@implementation CardSliderView

@synthesize cardArray = _cardArray;

- (void)transitionLeft
{
    self.currentArrayPosition --;
    if(self.currentArrayPosition < 0)
    {
        NSLog(@"CardView's position cannot go below 0.\n");
        self.currentArrayPosition = 0;
    }
    [UIView animateWithDuration:0.233f // 7 frames @ 30fps, David determined this duration to be optimal
        animations:^{
            // Move in new UIView
            UIView *currentView = [self.cardArray objectAtIndex:self.currentArrayPosition];
            [currentView setHidden:NO];
            [currentView setAlpha: 1.0f];
            currentView.frame = CGRectMake(currentView.frame.origin.x + 50,
                                            currentView.frame.origin.y,
                                            currentView.frame.size.width,
                                            currentView.frame.size.height);
            // Move out old UIView
            UIView *oldView = [self.cardArray objectAtIndex:(self.currentArrayPosition + 1)];
            [oldView setHidden:YES];
            [oldView setAlpha:0.0f];
            currentView.frame = CGRectMake(currentView.frame.origin.x + 50,
                                           currentView.frame.origin.y,
                                           currentView.frame.size.width,
                                           currentView.frame.size.height);
            }
        completion:^(BOOL finished){ }];
}

- (void)transitionRight
{
    self.currentArrayPosition ++;
    if(self.currentArrayPosition > self.cardArray.count)
    {
        NSLog(@"CardView's position cannot exceed current array size of %d.\n",
              self.cardArray.count);
        self.currentArrayPosition = self.cardArray.count;
    }
    [UIView animateWithDuration:0.233f // 7 frames @ 30fps, David determined this duration to be optimal
        animations:^{
            // Move in new UIView
            UIView *currentView = [self.cardArray objectAtIndex:self.currentArrayPosition];
            [currentView setHidden:NO];
            [currentView setAlpha: 1.0f];
            currentView.frame = CGRectMake(currentView.frame.origin.x - 50,
                                            currentView.frame.origin.y,
                                            currentView.frame.size.width,
                                            currentView.frame.size.height);
            // Move out old UIView
            UIView *oldView = [self.cardArray objectAtIndex:(self.currentArrayPosition - 1)];
            [oldView setHidden:YES];
            [oldView setAlpha:0.0f];
            currentView.frame = CGRectMake(currentView.frame.origin.x - 50,
                                           currentView.frame.origin.y,
                                           currentView.frame.size.width,
                                           currentView.frame.size.height);
            }
        completion:^(BOOL finished){ }];
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
