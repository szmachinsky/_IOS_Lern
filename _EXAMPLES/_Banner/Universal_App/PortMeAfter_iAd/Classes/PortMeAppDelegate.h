//
//  PortMeAppDelegate.h
//  PortMe
//
//  Created by Ray Wenderlich on 5/10/10.
//  Copyright Ray Wenderlich 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PortMeGameListController.h"

@interface PortMeAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    UINavigationController *_navController;
    PortMeGameListController *_gameListController;
    id _splitViewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navController;
@property (nonatomic, retain) IBOutlet PortMeGameListController *gameListController;
@property (nonatomic, retain) IBOutlet id splitViewController;

@end

