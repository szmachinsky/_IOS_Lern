//
//  facebookAppAppDelegate.h
//  facebookApp
//
//  Created by Alximik on 27.06.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class facebookAppViewController;

@interface facebookAppAppDelegate : NSObject <UIApplicationDelegate> {

}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet facebookAppViewController *viewController;

@end
