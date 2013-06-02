//
//  PortMeGameRatingController.h
//  PortMe
//
//  Created by Ray Wenderlich on 5/10/10.
//  Copyright 2010 Ray Wenderlich. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Game;

@interface PortMeGameRatingController : UITableViewController {
    Game *_game;
}

@property (nonatomic, retain) Game *game;

@end
