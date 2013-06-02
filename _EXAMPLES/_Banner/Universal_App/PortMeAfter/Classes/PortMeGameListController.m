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

@implementation PortMeGameListController
@synthesize games = _games;
@synthesize detailsController = _detailsController;
@synthesize delegate = _delegate;

#pragma mark Initialization

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Cool Board Games";
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [self setContentSizeForViewInPopover:CGSizeMake(320.0, 300.0)];
    }
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
    [super dealloc];
}

#pragma mark Orientation support

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return YES;
}

@end

