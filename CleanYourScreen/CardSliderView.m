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

#define CARD_TRANSITION_OFFSET 50

- (NSArray *)cardArray
{
    if(!_cardArray)
        _cardArray = [[NSArray alloc]init];
    return _cardArray;
}

- (void)setCardArray:(NSArray *)cardArray
{
    _cardArray = cardArray;
    for(int i = 0; i < [self.cardArray count]; i++)
        [self addSubview:[cardArray objectAtIndex:i]];
    // Hide all cards except the first
    for(int i = 1; i < [self.cardArray count]; i++)
    {
        if([[self.cardArray objectAtIndex:i] isKindOfClass:[UIView class]])
        {
            UIView *view = [self.cardArray objectAtIndex:i];
            [view setAlpha:0.0f];
            view.frame = CGRectMake(view.frame.origin.x + CARD_TRANSITION_OFFSET,
                                    view.frame.origin.y,
                                    view.frame.size.width,
                                    view.frame.size.height);
        }
    }
    // Reset current array position
    self.currentArrayPosition = 0;
}

- (UIView *)currentCard
{
    return [self.cardArray objectAtIndex:self.currentArrayPosition];
}

- (void)transitionLeft
{
    self.currentArrayPosition --;
    if(self.currentArrayPosition < 0)
    {
        NSLog(@"CardView's position cannot go below 0.\n");
        self.currentArrayPosition = 0;
        return;
    }
    [UIView animateWithDuration:0.233f // 7 frames @ 30fps, David determined this duration to be optimal
        animations:^{
            // Move in new UIView
            UIView *currentView = [self.cardArray objectAtIndex:self.currentArrayPosition];
            [currentView setAlpha: 1.0f];
            currentView.frame = CGRectMake(currentView.frame.origin.x + CARD_TRANSITION_OFFSET,
                                            currentView.frame.origin.y,
                                            currentView.frame.size.width,
                                            currentView.frame.size.height);
            // Move out old UIView
            UIView *oldView = [self.cardArray objectAtIndex:(self.currentArrayPosition+1)];
            [oldView setAlpha:0.0f];
            oldView.frame = CGRectMake(oldView.frame.origin.x + CARD_TRANSITION_OFFSET,
                                           oldView.frame.origin.y,
                                           oldView.frame.size.width,
                                           oldView.frame.size.height);
            }
        completion:^(BOOL finished){ }];
}

- (void)transitionRight
{
    self.currentArrayPosition ++;
    if(self.currentArrayPosition > self.cardArray.count-1)
    {
        NSLog(@"CardView's position cannot exceed current array size of %d.\n",
              self.cardArray.count);
        self.currentArrayPosition = self.cardArray.count-1;
        return;
    }
    [UIView animateWithDuration:0.233f // 7 frames @ 30fps, David determined this duration to be optimal
        animations:^{
            // Move in new UIView
            UIView *currentView = [self.cardArray objectAtIndex:self.currentArrayPosition];
            [currentView setAlpha:1.0f];
            currentView.frame = CGRectMake(currentView.frame.origin.x - CARD_TRANSITION_OFFSET,
                                            currentView.frame.origin.y,
                                            currentView.frame.size.width,
                                            currentView.frame.size.height);
            // Move out old UIView
            UIView *oldView = [self.cardArray objectAtIndex:(self.currentArrayPosition - 1)];
            [oldView setAlpha:0.0f];
            oldView.frame = CGRectMake(oldView.frame.origin.x - CARD_TRANSITION_OFFSET,
                                           oldView.frame.origin.y,
                                           oldView.frame.size.width,
                                           oldView.frame.size.height);
            }
        completion:^(BOOL finished){ }];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // init
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
