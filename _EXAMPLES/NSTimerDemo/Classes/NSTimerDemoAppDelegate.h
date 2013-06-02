//
//  NSTimerDemoAppDelegate.h
//  NSTimerDemo
//
//  Created by Collin Ruffenach on 7/21/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NSTimerDemoViewController;

@interface NSTimerDemoAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    NSTimerDemoViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet NSTimerDemoViewController *viewController;

@end

