//
//  RootViewController.m
//  UISearchDisplayTutorial
//
//  Created by Alximik on 15.09.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RootViewController.h"

@implementation RootViewController

@synthesize content;
@synthesize filteredContent;

- (void)dealloc
{
    self.content = nil;
    self.filteredContent = nil;
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"Names";
    
    self.content = [NSArray arrayWithObjects:@"Tom",@"Robin",@"Mark",@"Emily",@"Amy",@"Alex",@"Daniel", nil];
    self.filteredContent = [NSArray array];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return filteredContent.count;
    } else {
        return content.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault 
                                       reuseIdentifier:CellIdentifier] autorelease];
    }

    if (tableView == self.searchDisplayController.searchResultsTableView) {
        cell.textLabel.text = [filteredContent objectAtIndex:indexPath.row];
    } else {
        cell.textLabel.text = [content objectAtIndex:indexPath.row];
    }
    return cell;
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller 
shouldReloadTableForSearchString:(NSString *)searchString 
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF beginswith[cd]%@",searchString];
    self.filteredContent = [content filteredArrayUsingPredicate:predicate];
    return YES;
}

@end
