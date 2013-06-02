//
//  NSTimerDemoAppDelegate.m
//  NSTimerDemo
//
//  Created by Collin Ruffenach on 7/21/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "NSTimerDemoAppDelegate.h"
#import "NSTimerDemoViewController.h"

@implementation NSTimerDemoAppDelegate

@synthesize window;
@synthesize viewController;


- (void)applicationDidFinishLaunching:(UIApplication *)application {    
    
    // Override point for customization after app launch    
    [window addSubview:viewController.view];
    [window makeKeyAndVisible];
}


- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}


@end
