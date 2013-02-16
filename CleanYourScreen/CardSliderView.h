//
//  CardSliderView.h
//  CleanYourScreen
//
//  Created by Jeff Harrison on 2/9/13.
//  Copyright (c) 2013 Magnet Tree. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CardSliderView : UIView 
- (void)transitionLeft;
- (void)transitionRight;
- (void)setCardArray:(NSArray *) cards;
- (UIView *)currentCard;

@end
