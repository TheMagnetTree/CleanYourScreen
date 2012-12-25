//
//  GermView.h
//  CleanYourScreen
//
//  Created by Jeff Harrison on 12/23/12.
//  Copyright (c) 2012 Magnet Tree. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GermView : UIView

@property (strong, nonatomic) NSString * faceState;
@property (strong, nonatomic) NSString * bodyState;

- (void)setFaceState:(NSString *)faceState;
- (void)setBodyState:(NSString *)bodyState;

- (void)setFaceAtlasWithPath:(NSString *)pathToFaceAtlas;
- (void)setBodyAtlasWithPath:(NSString *)pathToBodyAtlas;

@end
