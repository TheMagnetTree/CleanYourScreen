//
//  GermView.h
//  CleanYourScreen
//
//  Created by Jeff Harrison on 12/23/12.
//  Copyright (c) 2012 Magnet Tree. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GermView : UIButton

@property NSNumber *velocityMagnitude;
@property NSNumber *velocityDirectionInRadians;
@property NSNumber *targetMagnitude;
@property NSNumber *targetDirectionInRadians;
@property NSNumber *maxMagnitudeIncrement;
@property NSNumber *maxDirectionIncrement;
@property NSString *path; // Get debug info, what germ is this?


- (void)blinkForSeconds:(NSNumber *)seconds;
- (void)blinkEyes:(NSNumber *)numTimes withOpenDuration:(NSNumber *)openSeconds
                                       withCloseDuration:(NSNumber *)closeSeconds
                                       withStartDelay:(NSNumber *)delaySeconds;
- (void)randomizeTargetVelocity;


- (void)setFaceAtlasWithPath:(NSString *)pathToFaceAtlas;
- (void)setBodyAtlasWithPath:(NSString *)pathToBodyAtlas;

@end
