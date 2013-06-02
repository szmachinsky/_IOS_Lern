//
//  facebookAppViewController.h
//  facebookApp
//
//  Created by Alximik on 27.06.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FBConnect.h"

@interface facebookAppViewController : UIViewController <FBRequestDelegate, FBDialogDelegate, FBSessionDelegate> {
    Facebook *facebook;
    UIButton *fbButton;
}

@property (nonatomic, retain) Facebook *facebook;
@property (nonatomic, retain) IBOutlet UIButton *fbButton;

- (IBAction)loginToFacebook;
- (IBAction)publishFBStream;
- (IBAction)publishImageFBStream;
- (IBAction)getFriends;
- (IBAction)uploadPhoto;
- (IBAction)uploadVideo;
- (void)initFacebook;

@end



