//
//  PortMeGameDetailsController.m
//  PortMe
//
//  Created by Ray Wenderlich on 5/10/10.
//  Copyright 2010 Ray Wenderlich. All rights reserved.
//

#import "PortMeGameDetailsController.h"
#import "Game.h"
#import "PortMeGameRatingController.h"

@interface PortMeGameDetailsController ()
- (void)createAdBannerView;
- (void)fixupAdView:(UIInterfaceOrientation)toInterfaceOrientation;
@end


@implementation PortMeGameDetailsController

@synthesize nameLabel = _nameLabel;
@synthesize typeLabel = _typeLabel;
@synthesize descrView = _descrView;
@synthesize ratingLabel = _ratingLabel;
@synthesize game = _game;
@synthesize ratingController = _ratingController;
@synthesize popover = _popover;
@synthesize ratingPopover = _ratingPopover;

@synthesize contentView = _contentView; //zs
@synthesize adBannerView = _adBannerView; //zs
@synthesize adBannerViewIsVisible = _adBannerViewIsVisible; //zs

- (void)refresh {
    _nameLabel.text = _game.name;
    _typeLabel.text = _game.type;
    _descrView.text = _game.descr;
    _ratingLabel.text = [NSString stringWithFormat:@"Your rating: %@", _game.rating];
}

//- (void) viewWillAppear:(BOOL)animated { //zs - later!
//    [self refresh];
//}

- (void)gameSelectionChanged:(Game *)curSelection {
    self.game = curSelection;
    [self refresh];
    
    if (_popover != nil) {
        [_popover dismissPopoverAnimated:YES];
    }
    
}

- (IBAction)rateTapped:(id)sender {
    if (_ratingController == nil) {
        self.ratingController = [[[PortMeGameRatingController alloc] initWithStyle:UITableViewStylePlain] autorelease];
    }
    _ratingController.game = _game;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        UIButton *button = (UIButton *)sender;
        if (_ratingPopover == nil) {
            Class classPopoverController = NSClassFromString(@"UIPopoverController");
            if (classPopoverController) {
                self.ratingPopover = [[[classPopoverController alloc] initWithContentViewController:_ratingController] autorelease];
            }
        }
        [_ratingPopover presentPopoverFromRect:button.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];        
    } else {
        [self.navigationController pushViewController:_ratingController animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [_contentView release];
    _contentView = nil;
    [super viewDidUnload];
    self.nameLabel = nil;
    self.typeLabel = nil;
    self.descrView = nil;
    self.ratingLabel = nil;
    self.popover = nil;
    self.ratingPopover = nil;
}

- (void)dealloc {
    self.nameLabel = nil;
    self.typeLabel = nil;
    self.descrView = nil;
    self.ratingLabel = nil;
    self.game = nil;
    self.ratingController = nil;
    self.popover = nil;
    self.ratingPopover = nil;
    [_contentView release];
    [super dealloc];
}


#pragma mark Orientation support

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return YES;
}

#pragma mark Split View Delegate

- (void)splitViewController: (UISplitViewController*)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem*)barButtonItem forPopoverController: (UIPopoverController*)pc {
    barButtonItem.title = @"Sidebar";    
    
    UINavigationItem *navItem = [self navigationItem];
    [navItem setLeftBarButtonItem:barButtonItem animated:YES];
    
    self.popover = pc;
}

- (void)splitViewController: (UISplitViewController*)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem {    
    
    UINavigationItem *navItem = [self navigationItem];
    [navItem setLeftBarButtonItem:nil animated:YES];
    
    self.popover = nil;
    
}

//------------------------need for  Banner---------------------------------------------
- (void)viewDidLoad {
    [self createAdBannerView];
}

- (void) viewWillAppear:(BOOL)animated {
    [self refresh];
    [self fixupAdView:[UIDevice currentDevice].orientation];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration 
{
    [self fixupAdView:toInterfaceOrientation];
}

#pragma mark ADBanner methods
//------------------------Banner-----------------------------------------------------
- (int)getBannerHeight:(UIDeviceOrientation)orientation 
{
    if (UIInterfaceOrientationIsLandscape(orientation)) {
        return 32;
    } else {
        return 50;
    }
}

- (int)getBannerHeight 
{
    return [self getBannerHeight:[UIDevice currentDevice].orientation];
}

- (void)createAdBannerView 
{
    Class classAdBannerView = NSClassFromString(@"ADBannerView");
    if (classAdBannerView != nil) {
        self.adBannerView = [[[classAdBannerView alloc] 
                              initWithFrame:CGRectZero] autorelease];
        [_adBannerView setRequiredContentSizeIdentifiers:[NSSet setWithObjects: 
                                                          ADBannerContentSizeIdentifier320x50, 
                                                          ADBannerContentSizeIdentifier480x32, nil]];
        if (UIInterfaceOrientationIsLandscape([UIDevice currentDevice].orientation)) {
            [_adBannerView setCurrentContentSizeIdentifier:
             ADBannerContentSizeIdentifier480x32];
        } else {
            [_adBannerView setCurrentContentSizeIdentifier:
             ADBannerContentSizeIdentifier320x50];            
        }
        [_adBannerView setFrame:CGRectOffset([_adBannerView frame], 0, -[self getBannerHeight])];
        [_adBannerView setDelegate:self];
        
        [self.view addSubview:_adBannerView];        
    }
}

- (void)fixupAdView:(UIInterfaceOrientation)toInterfaceOrientation 
{
    if (_adBannerView != nil) {        
        if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation)) {
            [_adBannerView setCurrentContentSizeIdentifier:
             ADBannerContentSizeIdentifier480x32];
        } else {
            [_adBannerView setCurrentContentSizeIdentifier:
             ADBannerContentSizeIdentifier320x50];
        }          
        [UIView beginAnimations:@"fixupViews" context:nil];
        if (_adBannerViewIsVisible) {
            CGRect adBannerViewFrame = [_adBannerView frame];
            adBannerViewFrame.origin.x = 0;
            adBannerViewFrame.origin.y = 0;
            [_adBannerView setFrame:adBannerViewFrame];
            CGRect contentViewFrame = _contentView.frame;
            contentViewFrame.origin.y = [self getBannerHeight:toInterfaceOrientation];
            contentViewFrame.size.height = self.view.frame.size.height - [self getBannerHeight:toInterfaceOrientation];
            _contentView.frame = contentViewFrame;
        } else {
            CGRect adBannerViewFrame = [_adBannerView frame];
            adBannerViewFrame.origin.x = 0;
            adBannerViewFrame.origin.y = -[self getBannerHeight:toInterfaceOrientation];
            [_adBannerView setFrame:adBannerViewFrame];
            CGRect contentViewFrame = _contentView.frame;
            contentViewFrame.origin.y = 0;
            contentViewFrame.size.height = self.view.frame.size.height;
            _contentView.frame = contentViewFrame;            
        }
        [UIView commitAnimations];
    }   
}

#pragma mark ADBannerViewDelegate
- (void)bannerViewDidLoadAd:(ADBannerView *)banner {
    if (!_adBannerViewIsVisible) {                
        _adBannerViewIsVisible = YES;
        [self fixupAdView:[UIDevice currentDevice].orientation];
    }
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    if (_adBannerViewIsVisible)
    {        
        _adBannerViewIsVisible = NO;
        [self fixupAdView:[UIDevice currentDevice].orientation];
    }
}

@end
