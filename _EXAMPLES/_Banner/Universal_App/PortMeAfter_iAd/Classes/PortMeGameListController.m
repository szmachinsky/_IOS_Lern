//
//  PortMeGameListController.m
//  PortMe
//
//  Created by Ray Wenderlich on 5/10/10.
//  Copyright 2010 Ray Wenderlich. All rights reserved.
//

#import "PortMeGameListController.h"
#import "Game.h"
#import "PortMeGameDetailsController.h"

@interface PortMeGameListController ()
- (void)createAdBannerView;
- (void)fixupAdView:(UIInterfaceOrientation)toInterfaceOrientation;
@end


@implementation PortMeGameListController
@synthesize games = _games;
@synthesize detailsController = _detailsController;
@synthesize delegate = _delegate;

@synthesize tableView = _tableView; //zs
@synthesize contentView = _contentView;
@synthesize adBannerView = _adBannerView; //zs
@synthesize adBannerViewIsVisible = _adBannerViewIsVisible; //zs


#pragma mark Initialization

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Cool Board Games";
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [self setContentSizeForViewInPopover:CGSizeMake(320.0, 300.0)];
    }
    
    [self createAdBannerView]; //zs

}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _games.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    Game *game = [_games objectAtIndex:indexPath.row];
    cell.textLabel.text = game.name;
    
    return cell;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_detailsController == nil) {
        self.detailsController = [[[PortMeGameDetailsController alloc] initWithNibName:@"PortMeGameDetailsController" bundle:[NSBundle mainBundle]] autorelease];        
    }
        
    Game *game = [_games objectAtIndex:indexPath.row];
    _detailsController.game = game;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        if (_delegate != nil) {            
            [_delegate gameSelectionChanged:game];
        }
    } else {
        [self.navigationController pushViewController:_detailsController animated:YES];
    }
    
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
}

- (void)dealloc {
    self.games = nil;
    self.detailsController = nil;
    self.delegate = nil;
    
    self.tableView = nil; //zs
    self.contentView = nil;
    
    [super dealloc];
}

#pragma mark Orientation support

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return YES;
}


//------------------------need for  Banner---------------------------------------------
//- (void)viewDidLoad {
//    [self createAdBannerView]; //zs
//}

- (void) viewWillAppear:(BOOL)animated {
//    [self refresh];
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

