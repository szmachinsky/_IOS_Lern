//
//  facebookAppViewController.m
//  facebookApp
//
//  Created by Alximik on 27.06.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "facebookAppViewController.h"

@implementation facebookAppViewController

@synthesize facebook;
@synthesize fbButton;

- (void)dealloc
{
    self.facebook = nil;
    self.fbButton = nil;
    [super dealloc];
}

- (void)viewDidUnload
{
    self.fbButton = nil;
    [super viewDidUnload];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"userName"];
    if (userName) {
        [fbButton setTitle:userName forState:UIControlStateNormal];
    }
}

- (IBAction)loginToFacebook {
    [self initFacebook];
    
    if ([facebook isSessionValid]) {
        [facebook logout:self];
    } else {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"FBpermissions" ofType:@"plist"];
        NSDictionary *settingsDic = [NSDictionary dictionaryWithContentsOfFile:path];
        NSArray *permissions = [settingsDic objectForKey:@"facebookPermissions"];
        [facebook authorize:permissions delegate:self];  
    }
}

- (IBAction)publishFBStream {
    [self initFacebook];
    
    if ([facebook isSessionValid]) {        
        SBJSON *jsonWriter = [[SBJSON new] autorelease];
        
        NSDictionary* actionLinks = [NSArray arrayWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:
                                                               @"Always Running",
                                                               @"text",
                                                               @"http://itsti.me/",
                                                               @"href", nil], nil];
        
        NSString *actionLinksStr = [jsonWriter stringWithObject:actionLinks];
        NSDictionary* attachment = [NSDictionary dictionaryWithObjectsAndKeys:
                                    @"a long run", @"name",
                                    @"The Facebook Running app", @"caption",
                                    @"it is fun", @"description",
                                    @"http://itsti.me/", @"href", nil];
        NSString *attachmentStr = [jsonWriter stringWithObject:attachment];
        NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       @"Share on Facebook",  @"user_message_prompt",
                                       actionLinksStr, @"action_links",
                                       attachmentStr, @"attachment", 
                                       @"Это отличный сайт! \n http://imaladec.com", @"message", nil];
        [facebook dialog:@"feed"
               andParams:params
             andDelegate:self]; 
        
        
    } else {
        [self loginToFacebook]; 
    }
}

- (IBAction)publishImageFBStream {
    [self initFacebook];
    
    if ([facebook isSessionValid]) {    
        SBJSON *jsonWriter = [[SBJSON new] autorelease];
        
        NSDictionary* actionLinks = [NSArray arrayWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:
                                                               @"www.imaladec.com",
                                                               @"text",
                                                               @"http://www.imaladec.com/",
                                                               @"href", nil], nil];
        
        NSString *actionLinksStr = [jsonWriter stringWithObject:actionLinks];
        
        NSDictionary* imageShare = [NSDictionary dictionaryWithObjectsAndKeys:
                                    @"image", @"type",
                                    @"http://imaladec.com/img/logo.png", @"src",
                                    @"http://imaladec.com/", @"href",
                                    nil];
        
        NSDictionary* attachment = [NSDictionary dictionaryWithObjectsAndKeys:
                                    @"", @"caption",
                                    [NSArray arrayWithObjects:imageShare, nil], @"media",
                                    nil];
        
        NSString *attachmentStr = [jsonWriter stringWithObject:attachment];
        
        NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       @"Share on Facebook",  @"user_message_prompt",
                                       actionLinksStr, @"action_links",
                                       attachmentStr, @"attachment",
                                       nil];
        
        [facebook dialog: @"stream.publish"
               andParams: params
             andDelegate:self];
        
    } else {
        [self loginToFacebook]; 
    }
}

- (IBAction)getFriends {
    [self initFacebook];
    if ([facebook isSessionValid]) {
        [facebook requestWithGraphPath:@"me/friends?fields=id,name,gender,picture,birthday" andDelegate:self];        
    } else {
        [self loginToFacebook];
    }
}

- (IBAction)uploadPhoto {
    [self initFacebook];
    
    if ([facebook isSessionValid]) {    
        UIImage *img  = [UIImage imageNamed:@"logo.png"];
        
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       img, @"picture",
                                       nil];
        [facebook requestWithMethodName:@"photos.upload"
                              andParams:params
                          andHttpMethod:@"POST"
                            andDelegate:self];
    } else {
        [self loginToFacebook]; 
    }    
}

- (IBAction)uploadVideo {
    [self initFacebook];
    
    NSString *moviePath = [[NSBundle mainBundle] pathForResource:@"sample_mpeg4" ofType:@"mp4"];
    NSURL *movieURL = [NSURL fileURLWithPath:moviePath];
    
    NSDictionary * params = [NSDictionary dictionaryWithObjectsAndKeys:
                             @"Sample video title", @"title",
                             @"Sample video description", @"description",
                             nil];

    FBVideoUpload *upload = [[FBVideoUpload alloc] init];
    upload.accessToken = facebook.accessToken;
    upload.apiKey = @"Set App Key";
    upload.appSecret = @"Set App Secret";
    [upload startUploadWithURL:movieURL params:params delegate:self];
}

- (void)initFacebook {
    if (!facebook) {
        self.facebook = [[Facebook alloc] initWithAppId:@"331663473546996"];
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        facebook.accessToken = [userDefaults objectForKey:@"AccessToken"];
        facebook.expirationDate = [userDefaults objectForKey:@"ExpirationDate"];
        
        [facebook release];
    }
}

- (void)fbDidLogin {
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	[userDefaults setObject:self.facebook.accessToken forKey:@"AccessToken"];
	[userDefaults setObject:self.facebook.expirationDate forKey:@"ExpirationDate"];
	[userDefaults synchronize];
	
	[facebook requestWithGraphPath:@"me" andDelegate:self];
}

- (void)fbDidLogout {
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	[userDefaults removeObjectForKey:@"AccessToken"];
	[userDefaults removeObjectForKey:@"ExpirationDate"];
	[userDefaults removeObjectForKey:@"userName"];
	[userDefaults synchronize];
    
    [fbButton setTitle:@"Login" forState:UIControlStateNormal];
}

- (void)request:(FBRequest *)request didLoad:(id)result {
    if ([result isKindOfClass:[NSDictionary class]]) {
        if ([result objectForKey:@"name"]) {
            NSString *userName = [result objectForKey:@"name"];
            NSUserDefaults	*defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:userName forKey:@"userName"];
            [defaults synchronize];
            
            [fbButton setTitle:userName forState:UIControlStateNormal];
        } else if ([result objectForKey:@"data"]) {
            NSArray *curentResult = [result objectForKey:@"data"];
            
            for (NSDictionary *element in curentResult) {
                NSLog(@"id:%@", [element objectForKey:@"id"]);
                NSLog(@"name:%@", [element objectForKey:@"name"]);
                NSLog(@"photoURL:%@", [element objectForKey:@"picture"]);
                NSLog(@"gender:%@", [element objectForKey:@"gender"]);
            }
        }        
    } else {
        NSString *XMLresult = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
        NSLog(@"%@", XMLresult);
        [XMLresult release];
    }
}

- (void)request:(FBRequest *)request didFailWithError:(NSError *)error {
    NSLog(@"%@", error);
}

@end


