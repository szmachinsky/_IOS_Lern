//
//  PortMeGameListController.h
//  PortMe
//
//  Created by Ray Wenderlich on 5/10/10.
//  Copyright 2010 Ray Wenderlich. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameSelectionDelegate.h"

@class PortMeGameDetailsController;

@interface PortMeGameListController : UITableViewController {
    NSArray *_games;
    PortMeGameDetailsController *_detailsController;
    id<GameSelectionDelegate> _delegate;
}

@property (nonatomic, retain) NSArray *games;
@property (nonatomic, retain) PortMeGameDetailsController *detailsController;
@property (nonatomic, assign) IBOutlet id<GameSelectionDelegate> delegate;

@end
