//
//  ViewController.h
//  IndexedTable
//
//  Created by Eugene Romanishin on 24.05.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITableView *namesList;
@property (strong, nonatomic) NSMutableDictionary *names;
@property (strong, nonatomic) NSMutableArray *sectionKeys;
@property (strong, nonatomic) NSArray *ssectionKeys;

@end
