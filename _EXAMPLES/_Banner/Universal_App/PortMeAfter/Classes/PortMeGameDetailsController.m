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

@implementation PortMeGameDetailsController

@synthesize nameLabel = _nameLabel;
@synthesize typeLabel = _typeLabel;
@synthesize descrView = _descrView;
@synthesize ratingLabel = _ratingLabel;
@synthesize game = _game;
@synthesize ratingController = _ratingController;
@synthesize popover = _popover;
@synthesize ratingPopover = _ratingPopover;

- (void)refresh {
    _nameLabel.text = _game.name;
    _typeLabel.text = _game.type;
    _descrView.text = _game.descr;
    _ratingLabel.text = [NSString stringWithFormat:@"Your rating: %@", _game.rating];
}

- (void) viewWillAppear:(BOOL)animated {
    [self refresh];
}

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

@end
