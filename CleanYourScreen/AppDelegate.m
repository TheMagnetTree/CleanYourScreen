//
//  AppDelegate.m
//  CleanYourScreen
//
//  Created by Jeff Harrison on 12/18/12.
//  Copyright (c) 2012 Magnet Tree. All rights reserved.
//

#import "AppDelegate.h"

@implementation MTDJAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    NSDictionary *appDefaults = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithInt:10000000], @"reminderInterval", // TODO: Find good default values
                                    [NSNumber numberWithInt:60 * 60 * 2], @"repeatInterval",
                                    [NSNumber numberWithBool:YES], @"firstRun",
                                    [NSNumber numberWithBool:YES], @"enableNotifications",
                                     nil]; //add any defaults here
    [[NSUserDefaults standardUserDefaults] registerDefaults:appDefaults];
    /*
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    // iPhone only for now. Programatically set initial view controller
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil];
    UIViewController *initialViewController;
    if([[defaults objectForKey:@"firstRun"] boolValue] == YES) {
        initialViewController = [storyBoard instantiateViewControllerWithIdentifier:@"tutorial"];
    }
    else {
        initialViewController = [storyBoard instantiateViewControllerWithIdentifier:@"main"];
    }
    UIWindow *window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    window.rootViewController = initialViewController;
    [window makeKeyAndVisible];
     */
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
