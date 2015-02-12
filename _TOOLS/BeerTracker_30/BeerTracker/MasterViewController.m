//  MasterViewController.m
//  BeerTracker
//  Copyright (c) 2013 Ray Wenderlich. All rights reserved.

#import "MasterViewController.h"
#import "AMRating/AMRatingControl.h"
#import "BeerViewController.h"
#import "ImageSaver.h"

#import "MagicalRecord+Actions.h"

#import "Beer.h" //zs
#import "BeerDetails.h" //zs

@interface MasterViewController ()<UISearchBarDelegate>
@property (nonatomic) NSMutableArray *beers;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@end

NSString * const SORT_KEY_NAME   = @"name";
NSString * const SORT_KEY_RATING = @"beerDetails.rating";
NSString * const WB_SORT_KEY     = @"WB_SORT_KEY";

@implementation MasterViewController

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	// Check if the user's sort preference has been saved.
	if (![[NSUserDefaults standardUserDefaults] objectForKey:WB_SORT_KEY]) {
		[[NSUserDefaults standardUserDefaults] setObject:SORT_KEY_RATING forKey:WB_SORT_KEY];
	}
	if ([[[NSUserDefaults standardUserDefaults] objectForKey:WB_SORT_KEY] isEqualToString:SORT_KEY_NAME]) {
		self.segmentedControl.selectedSegmentIndex = 1;
	}
    
    [self fetchAllBeers]; //zs
    
	[self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	self.tableView.contentOffset = CGPointMake(0, 44);
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
	BeerViewController *upcoming = segue.destinationViewController;
    if ([[segue identifier] isEqualToString:@"editBeer"]) {
        
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow]; //zs
        Beer *beer = self.beers[indexPath.row];
        upcoming.beer = beer;
        
	} else if ([segue.identifier isEqualToString:@"addBeer"]) {
		upcoming.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
//                                                                                     style:UIBarButtonSystemItemCancel target:upcoming action:@selector(cancelAdd)];
                                                                                     style:UIBarButtonItemStylePlain target:upcoming action:@selector(cancelAdd)];
		upcoming.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done"
//                                                                                      style:UIBarButtonSystemItemAdd target:upcoming action:@selector(addNewBeer)];
                                                                                      style:UIBarButtonItemStyleDone target:upcoming action:@selector(addNewBeer)];
	}
}

- (void)fetchAllBeers {
    // 1. Get the sort key
    NSString *sortKey = [[NSUserDefaults standardUserDefaults] objectForKey:WB_SORT_KEY]; //zs
    // 2. Determine if it is ascending
    BOOL ascending = [sortKey isEqualToString:SORT_KEY_RATING] ? NO : YES;
    // 3. Fetch entities with MagicalRecord
    self.beers = [[Beer MR_findAllSortedBy:sortKey ascending:ascending] mutableCopy]; //zs
}

- (void)saveContext {
    [[NSManagedObjectContext MR_mainQueueContext] MR_saveToPersistentStoreAndWait]; //zs
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.beers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"
															forIndexPath:indexPath];
	[self configureCell:cell atIndex:indexPath];
	return cell;
}

- (void)configureCell:(UITableViewCell*)cell atIndex:(NSIndexPath*)indexPath {
    // Get current Beer
    Beer *beer = self.beers[indexPath.row]; //zs
    cell.textLabel.text = beer.name;
    // Setup AMRatingControl
    AMRatingControl *ratingControl;
    if (![cell viewWithTag:20]) {
        ratingControl = [[AMRatingControl alloc] initWithLocation:CGPointMake(190, 10) emptyImage:[UIImage imageNamed:@"beermug-empty"] solidImage:[UIImage imageNamed:@"beermug-full"] andMaxRating:5];
        ratingControl.tag = 20;
        ratingControl.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        ratingControl.userInteractionEnabled = NO;
        [cell addSubview:ratingControl];
    } else {
        ratingControl = (AMRatingControl*)[cell viewWithTag:20];
    }
    // Put beer rating in cell
    ratingControl.rating = [beer.beerDetails.rating integerValue]; //zs
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        Beer *beerToRemove = self.beers[indexPath.row]; //zs
        // Remove Image from local documents
        if (beerToRemove.beerDetails.image) {
            [ImageSaver deleteImageAtPath:beerToRemove.beerDetails.image];
        }
        // Deleting an Entity with MagicalRecord
        [beerToRemove MR_deleteEntity];
        [self saveContext];
        [self.beers removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade]; //zs
    }
    
}

#pragma mark - Search Bar Delegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
	if ([self.searchBar.text length] > 0) {
		[self doSearch];
	} else {
		[self fetchAllBeers];
		[self.tableView reloadData];
	}
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
	[self.searchBar resignFirstResponder];
	// Clear search bar text
	self.searchBar.text = @"";
	// Hide the cancel button
	self.searchBar.showsCancelButton = NO;
	// Do a default fetch of the beers
	[self fetchAllBeers];
	[self.tableView reloadData];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
	self.searchBar.showsCancelButton = YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
	[self.searchBar resignFirstResponder];
	[self doSearch];
}

- (void)doSearch {
    // 1. Get the text from the search bar.
    NSString *searchText = self.searchBar.text;
    // 2. Do a fetch on the beers that match Predicate criteria.
    // In this case, if the name contains the string
    self.beers = [[Beer MR_findAllSortedBy:SORT_KEY_NAME ascending:YES withPredicate:[NSPredicate predicateWithFormat:@"name contains[c] %@", searchText] inContext:[NSManagedObjectContext MR_mainQueueContext]] mutableCopy];
    // 3. Reload the table to show the query results.
    [self.tableView reloadData];
}

// Change the sort key used when fetching object.
- (IBAction)changeSortKey:(id)sender {
    
    NSLog(@"OOPS!!!");
    [self performSelector:@selector(runThread) withObject:nil afterDelay:1.0];
    return;
    
	switch ([(UISegmentedControl*)sender selectedSegmentIndex]) {
		case 0: {
			[[NSUserDefaults standardUserDefaults] setObject:SORT_KEY_RATING forKey:WB_SORT_KEY];
			[self fetchAllBeers];
			[self.tableView reloadData];
		}
			break;
		case 1: {
			[[NSUserDefaults standardUserDefaults] setObject:SORT_KEY_NAME forKey:WB_SORT_KEY];
			[self fetchAllBeers];
			[self.tableView reloadData];
		}
			break;
		default:
			break;
	}
}

//===================================================================================
-(void)runThread
{
    [self performSelectorInBackground:@selector(addDemoDataInThread3) withObject:nil];
}


- (void)addDemoDataInThread1
{
    NSLog(@"add in backgound - begin");
            
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        NSLog(@"RUN1");
        
        Beer *blondAle = [Beer MR_createEntityInContext:localContext];
        blondAle.name  = @"Blond_NEW1!!! Ale";
        blondAle.beerDetails = [BeerDetails MR_createEntityInContext:localContext];
        blondAle.beerDetails.rating = @4;
        [ImageSaver saveImageToDisk:[UIImage imageNamed:@"blond.jpg"] andToBeer:blondAle];
        
    } completion:^(BOOL success, NSError *error) {
        NSLog(@"RUN2");
        [self fetchAllBeers];
        [self.tableView reloadData];
    }];
    
    
    NSLog(@"add in backgound - end");
}

- (void)addDemoDataInThread2
{
    NSLog(@"add in backgound - begin");
    
    NSManagedObjectContext *lContext = [NSManagedObjectContext MR_context];
    Beer *blondAle = [Beer MR_createEntityInContext:lContext];
    blondAle.name  = @"Blond_NEW2!!! Ale";
    blondAle.beerDetails = [BeerDetails MR_createEntityInContext:lContext];
    blondAle.beerDetails.rating = @4;
    [ImageSaver saveImageToDisk:[UIImage imageNamed:@"blond.jpg"] andToBeer:blondAle];
    
//    NSLog(@"RUN0");
//    [lContext MR_saveToPersistentStoreAndWait];
//    NSLog(@"RUN00");
    
    [lContext MR_saveToPersistentStoreWithCompletion:^(BOOL contextDidSave, NSError *error){
        NSLog(@"RUN22 %d",contextDidSave);
        [self fetchAllBeers];
        [self.tableView reloadData];
    }];
    
    
    NSLog(@"add in backgound - end");
}

- (void)addDemoDataInThread3
{
    NSLog(@"add in backgound - begin");
    
    NSManagedObjectContext *lContext = [NSManagedObjectContext MR_context];
    Beer *blondAle = [Beer MR_createEntityInContext:lContext];
    blondAle.name  = @"Blond_NEW2!!! Ale";
    blondAle.beerDetails = [BeerDetails MR_createEntityInContext:lContext];
    blondAle.beerDetails.rating = @4;
    [ImageSaver saveImageToDisk:[UIImage imageNamed:@"blond.jpg"] andToBeer:blondAle];
    NSLog(@"RUN0");
    [lContext MR_saveToPersistentStoreAndWait];
    NSLog(@"RUN00");
    
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        NSLog(@"RUN1");
        // Do your work to be saved here, against the `localContext` instance
        // Everything you do in this block will occur on a background thread
        Beer *blondAle_ = [blondAle MR_inContext:localContext];
        blondAle_.name  = @"Blond_NEW_222!!!";
        NSLog(@"RUN11");
    } completion:^(BOOL success, NSError *error) {
        NSLog(@"RUN2");
        [self fetchAllBeers];
        [self.tableView reloadData];
    }];
    
    
    NSLog(@"add in backgound - end");
}


@end
