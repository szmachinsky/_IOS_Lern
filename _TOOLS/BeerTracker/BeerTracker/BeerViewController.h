//  BeerViewController.h
//  BeerTracker
//  Copyright (c) 2013 Ray Wenderlich. All rights reserved.

#import <UIKit/UIKit.h>
@class AMRatingControl;
@class Beer; //zs

@interface BeerViewController : UITableViewController
@property (weak, nonatomic) IBOutlet UIImageView *beerImage;
@property (weak, nonatomic) IBOutlet UITextField *beerNameField;
@property (weak, nonatomic) IBOutlet UITextView *beerNotesView;
@property (strong, nonatomic) IBOutlet AMRatingControl *ratingControl;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tapGesture;
@property (weak, nonatomic) IBOutlet UITableViewCell *cellOne;
@property (weak, nonatomic) IBOutlet UILabel *tapToAddLabel;

@property (nonatomic, strong) Beer *beer; //zs

- (IBAction)takePicture:(id)sender;
- (IBAction)didFinishEditingBeer:(id)sender;
- (void)cancelAdd;
- (void)addNewBeer;
@end
