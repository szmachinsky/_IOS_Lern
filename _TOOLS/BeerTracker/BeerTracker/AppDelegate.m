//  AppDelegate.m
//  BeerTracker
//  Copyright (c) 2013 Ray Wenderlich. All rights reserved.

#import "AppDelegate.h"
#import "ImageSaver.h"

#import "Beer.h" //zs
#import "BeerDetails.h" //zs

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	self.window.tintColor = [UIColor whiteColor];
	[[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:0.22f green:0.17f blue:0.13f alpha:1.00f]];
	[[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor greenColor]}];
    
    [MagicalRecord setupCoreDataStackWithStoreNamed:@"BeerModel"]; //zs
    [self addDemoData];
    return YES;
}

- (void)addDemoData
{
    // Setup App with prefilled Beer items.
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"MR_HasPrefilledBeers"]) {
        // Create Blond Ale
        Beer *blondAle = [Beer createEntity];
        blondAle.name  = @"Blond Ale";
        blondAle.beerDetails = [BeerDetails createEntity];
        blondAle.beerDetails.rating = @4;
        [ImageSaver saveImageToDisk:[UIImage imageNamed:@"blond.jpg"] andToBeer:blondAle];
        
        // Create Wheat Beer
        Beer *wheatBeer = [Beer createEntity];
        wheatBeer.name  = @"Wheat Beer";
        wheatBeer.beerDetails = [BeerDetails createEntity];
        wheatBeer.beerDetails.rating = @2;
        [ImageSaver saveImageToDisk:[UIImage imageNamed:@"wheat.jpg"] andToBeer:wheatBeer];
        
        // Create Pale Lager
        Beer *paleLager = [Beer createEntity];
        paleLager.name  = @"Pale Lager";
        paleLager.beerDetails = [BeerDetails createEntity];
        paleLager.beerDetails.rating = @3;
        [ImageSaver saveImageToDisk:[UIImage imageNamed:@"pale.jpg"] andToBeer:paleLager];
        
        // Create Stout
        Beer *stout = [Beer createEntity];
        stout.name  = @"Stout Lager";
        stout.beerDetails = [BeerDetails createEntity];
        stout.beerDetails.rating = @5;
        [ImageSaver saveImageToDisk:[UIImage imageNamed:@"stout.jpg"] andToBeer:stout];
        
        // Save Managed Object Context
        [[NSManagedObjectContext defaultContext] saveToPersistentStoreWithCompletion:nil];
        
        // Set User Default to prevent another preload of data on startup.
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"MR_HasPrefilledBeers"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
   
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
