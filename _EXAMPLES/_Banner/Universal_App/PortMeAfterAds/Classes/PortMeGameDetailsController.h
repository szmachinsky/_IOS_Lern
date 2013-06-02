//
//  PortMeGameDetailsController.h
//  PortMe
//
//  Created by Ray Wenderlich on 5/10/10.
//  Copyright 2010 Ray Wenderlich. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameSelectionDelegate.h"
#import "iAd/ADBannerView.h"

@class Game;
@class PortMeGameRatingController;

@interface PortMeGameDetailsController : UIViewController <GameSelectionDelegate, UISplitViewControllerDelegate, ADBannerViewDelegate> {
    UILabel *_nameLabel;
    UILabel *_typeLabel;
    UITextView *_descrView;
    UILabel *_ratingLabel;
    Game *_game;
    PortMeGameRatingController *_ratingController;
    id _popover;
    id _ratingPopover;
    UIView *_contentView;
    id _adBannerView;
    BOOL _adBannerViewIsVisible;
}

@property (nonatomic, retain) IBOutlet UILabel *nameLabel;
@property (nonatomic, retain) IBOutlet UILabel *typeLabel;
@property (nonatomic, retain) IBOutlet UITextView *descrView;
@property (nonatomic, retain) IBOutlet UILabel *ratingLabel;
@property (nonatomic, retain) Game *game;
@property (nonatomic, retain) PortMeGameRatingController *ratingController;
@property (nonatomic, retain) id popover;
@property (nonatomic, retain) id ratingPopover;
@property (nonatomic, retain) IBOutlet UIView *contentView;
@property (nonatomic, retain) id adBannerView;
@property (nonatomic) BOOL adBannerViewIsVisible;

- (IBAction)rateTapped:(id)sender;

@end
