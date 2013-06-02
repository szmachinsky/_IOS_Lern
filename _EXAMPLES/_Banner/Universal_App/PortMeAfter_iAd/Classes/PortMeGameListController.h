//
//  PortMeGameListController.h
//  PortMe
//
//  Created by Ray Wenderlich on 5/10/10.
//  Copyright 2010 Ray Wenderlich. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameSelectionDelegate.h"
#import "iAd/ADBannerView.h"

@class PortMeGameDetailsController;

///@interface PortMeGameListController : UITableViewController { //zs
@interface PortMeGameListController : UIViewController <UITableViewDelegate, UITableViewDataSource, ADBannerViewDelegate>  
{
    NSArray *_games;
    PortMeGameDetailsController *_detailsController;
    id<GameSelectionDelegate> _delegate;
    
    // Add inside class //zs
    UITableView *_tableView;
    UIView *_contentView;
    
}

@property (nonatomic, retain) NSArray *games;
@property (nonatomic, retain) PortMeGameDetailsController *detailsController;
@property (nonatomic, assign) IBOutlet id<GameSelectionDelegate> delegate;


// Add after class //zs
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) IBOutlet UIView *contentView;    
@property (nonatomic, retain) id adBannerView; //zs
@property (nonatomic) BOOL adBannerViewIsVisible; //zs


@end
