//
//  NSTimerDemoViewController.m
//  NSTimerDemo
//
//  Created by Collin Ruffenach on 7/21/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "NSTimerDemoViewController.h"

@implementation NSTimerDemoViewController



/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


- (void)viewDidLoad 
{
    [super viewDidLoad];
    
    int sc=1;
    NSString *str;
    if (sc % 2 == 0) {
        str=[[NSBundle mainBundle] pathForResource:@"XO_79_O" ofType:@"png"];
    } else {
        str=[[NSBundle mainBundle] pathForResource:@"XO_79_X" ofType:@"png"];   
    }
    UIImage *im=[[[UIImage alloc] initWithContentsOfFile:str] autorelease];
    
    
	
	CGRect workingFrame;
	workingFrame.origin.x = 0;
	workingFrame.origin.y = 30;
	workingFrame.size.width = 79;
	workingFrame.size.height = 79;
	
	for(int i = 0; i < 3; i++)
	{
		UIImageView *myView = [[UIImageView alloc] initWithFrame:workingFrame];
		[myView setTag:i];
//		[myView setBackgroundColor:[UIColor blueColor]];
  NSLog(@"count_1=%d",[myView retainCount]);		
		workingFrame.origin.x = workingFrame.origin.x + workingFrame.size.width + 1;
        myView.image=im;
        
		[self.view addSubview:myView];
  NSLog(@"count_2=%d",[myView retainCount]);		        
        [myView release]; //zs
  NSLog(@"count_3=%d",[myView retainCount]);		        
	}
	
	myTimer = [NSTimer scheduledTimerWithTimeInterval:.1 target:self selector:@selector(moveACar) userInfo:nil repeats:YES];
}

-(void)moveACar
{
	int r = rand() % 6;
	NSLog(@"My number is %d", r);
	
	for(UIView *aView in [self.view subviews])
	{
		if([aView tag] == r)
		{
			int movement = rand() % 20; //zs 10
			CGRect workingFrame = aView.frame;
			workingFrame.origin.y = workingFrame.origin.y - movement;
			
			[UIView beginAnimations:nil context:NULL];
			[UIView setAnimationDuration:.2];
			[aView setFrame:workingFrame];
			[UIView commitAnimations];
			
			if(workingFrame.origin.y < 0)
			{
				[myTimer invalidate];
			}
		}
	}
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}

@end
