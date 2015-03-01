//
//  DetailViewController.m
//  CoreNotes
//
//  Created by Eugene Romanishin on 05.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DetailViewController.h"

@implementation DetailViewController

@synthesize delegate;
@synthesize detailItem;
@synthesize note;
@synthesize detail;

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.note = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *done =[[UIBarButtonItem alloc] 
                             initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                             target:self
                             action:@selector(pressDone)];
	self.navigationItem.rightBarButtonItem = done; 
    
    note.text = [[detailItem valueForKey:@"note"] description];
    self.title = [[detailItem valueForKey:@"timeStamp"] description];
    
    NSString *str = [[detailItem valueForKey:@"detail"] description]; //zs
    if (str) {
        detail.text = str;
    } else {
        detail.text = @"???";
    }
}

- (void)pressDone {
    [detailItem setValue:note.text forKey:@"note"];
    
//    [detailItem setValue:detail.text forKey:@"detail"]; //zs
    
    if ([delegate respondsToSelector:@selector(saveContext)]) {
        [delegate performSelector:@selector(saveContext)];
    }
    
    [self.navigationController popViewControllerAnimated:YES];	
}
							
@end
