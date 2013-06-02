//
//  PortMeAppDelegate.m
//  PortMe
//
//  Created by Ray Wenderlich on 5/10/10.
//  Copyright Ray Wenderlich 2010. All rights reserved.
//

#import "PortMeAppDelegate.h"
#import "Game.h"

@implementation PortMeAppDelegate

@synthesize window;
@synthesize navController = _navController;
@synthesize gameListController = _gameListController;
@synthesize splitViewController = _splitViewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    

    // Create some games and pass into game list controller
    Game *game1 = [[[Game alloc] initWithName:@"Dominion" type:@"Card game" descr:@"Gather a powerful hand and victory points by using an ever-shifting strategy."] autorelease];
    Game *game2 = [[[Game alloc] initWithName:@"Munchkin" type:@"Card game" descr:@"Kill monsters, gather loot, and backstab your friends."] autorelease];
    Game *game3 = [[[Game alloc] initWithName:@"Ticket to Ride" type:@"Board game" descr:@"Build long-reaching train tracks and connect your destinations!"] autorelease];
    Game *game4 = [[[Game alloc] initWithName:@"Bang!" type:@"Card game" descr:@"Take the role of a sherrif, deputy, renegade, or outlaw and become the king of the west."] autorelease];
    Game *game5 = [[[Game alloc] initWithName:@"Bohnanza" type:@"Card game" descr:@"Become the best bean farmer in town through negotiations and hilarity."] autorelease];
    NSArray *games = [NSArray arrayWithObjects:game1, game2, game3, game4, game5, nil];
    _gameListController.games = games;
    
    // Start up window
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {      
        UIView *view = [_splitViewController view];
        [window addSubview:view];
    } else {
        [window addSubview:_navController.view];	
    }
    [window makeKeyAndVisible];
	
	return YES;
}


- (void)dealloc {
    self.gameListController = nil;
    self.navController = nil;
    self.splitViewController = nil;
    [window release];
    [super dealloc];
}


@end
