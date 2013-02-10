//
//  ImmediateSegue.m
//  CleanYourScreen
//
//  Created by Jeff Harrison on 1/5/13.
//  Copyright (c) 2013 Magnet Tree. All rights reserved.
//

#import "ImmediateSegue.h"

@implementation ImmediateSegue

- (void)perform
{
    [[self sourceViewController] presentModalViewController:[self destinationViewController] animated:NO];
}

@end
