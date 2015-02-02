//
//  DetailViewController.h
//  CoreNotes
//
//  Created by Eugene Romanishin on 05.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (assign, nonatomic) id delegate;
@property (strong, nonatomic) id detailItem;
@property (strong, nonatomic) IBOutlet UITextView *note;

@end
