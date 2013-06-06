//
//  RootViewController.h
//  UISearchDisplayTutorial
//
//  Created by Alximik on 15.09.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RootViewController : UITableViewController <UISearchDisplayDelegate> {
    NSArray *content;
    NSArray *filteredContent;
}

@property (nonatomic, retain) NSArray *content;
@property (nonatomic, retain) NSArray *filteredContent;

@end
