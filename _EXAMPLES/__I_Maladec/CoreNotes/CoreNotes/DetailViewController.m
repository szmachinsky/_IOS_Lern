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
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    note.text = [[detailItem valueForKey:@"note"] description];
    self.title = [[detailItem valueForKey:@"timeStamp"] description];
    
#if _DATA_VERS == 1
    NSString *str = [[detailItem valueForKey:@"details"] description]; //zs
    if (str) {
        detail.text = str;
    } else {
        detail.text = @"???";
    }
#endif
}

- (void)pressDone {
    [detailItem setValue:note.text forKey:@"note"];
    
#if _DATA_VERS == 1
    [detailItem setValue:detail.text forKey:@"details"]; //zs
#endif
    
    if ([delegate respondsToSelector:@selector(saveContext)]) {
        [delegate performSelector:@selector(saveContext)];
    }
    
    [self.navigationController popViewControllerAnimated:YES];	
}
							
@end
