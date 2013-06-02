//
//  WhereamiAppDelegate.m
//  Whereami
//
//  Created by Joe Conway on 8/10/09.
//  Copyright Big Nerd Ranch 2009. All rights reserved.
//

#import "WhereamiAppDelegate.h"
#import "MapPoint.h"

@implementation WhereamiAppDelegate

@synthesize window;


- (BOOL)application:(UIApplication *)application 
	didFinishLaunchingWithOptions:(NSDictionary *)launchOptions  
{    
    // Create location manager object -
    // it will send its messages to our WhereamiAppDelegate
//    locationManager = [[CLLocationManager alloc] init];
    [locationManager setDelegate:self];
    
    // We want all results from the location manager
    [locationManager setDistanceFilter:kCLDistanceFilterNone];
    
    // And we want it to take as much time/power to get us those results
    [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    
    // Tell our manager to start looking for its location immediately
	//[locationManager startUpdatingLocation];
	[mapView setShowsUserLocation:YES];
    
    mapView.mapType = MKMapTypeStandard;
//    mapView.mapType = MKMapTypeSatellite;
//    mapView.mapType = MKMapTypeHybrid;

	
	CLLocationCoordinate2D  points[3]; 
//zs    points[0] = CLLocationCoordinate2DMake(33.81, -84.34);
//zs    points[1] = CLLocationCoordinate2DMake(43.13, -89.33);    
    points[0] = CLLocationCoordinate2DMake(53.8875, 27.6108);
    points[1] = CLLocationCoordinate2DMake(53.8882, 27.6114);
    points[2] = CLLocationCoordinate2DMake(53.8881, 27.6119);
 
    MKPolyline *poly = [MKPolyline polylineWithCoordinates:points count:3];
    [poly setTitle:@"The Voyage"];
    [mapView addOverlay:poly];
    
    circ = [MKCircle circleWithCenterCoordinate:CLLocationCoordinate2DMake(53.8881, 27.6119) radius:50];
    [mapView addOverlay:circ];

	
    CLLocationCoordinate2D loc1 = CLLocationCoordinate2DMake(53.8875, 27.6108);
    MKPointAnnotation* ann1 = [[[MKPointAnnotation alloc] init] autorelease];
    ann1.coordinate = loc1;
    ann1.title = @"Start";
    ann1.subtitle = @"Have a fun!";
    [mapView addAnnotation:ann1];
    
    CLLocationCoordinate2D loc2 = CLLocationCoordinate2DMake(53.8881, 27.6119);
    MKPointAnnotation* ann2 = [[[MKPointAnnotation alloc] init] autorelease];
    ann2.coordinate = loc2;
    ann2.title = @"Stop";
    ann2.subtitle = @"Have a fun!";
    [mapView addAnnotation:ann2];
    
//    mapView.hidden = NO;    
    
    
	[window makeKeyAndVisible];
	return YES;
}

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay
{
    if ([overlay isKindOfClass:[MKPolyline class]])
    {
//        MKCircleView *aView = (MKCircleView *)[[[MKPolylineView alloc] initWithPolyline:(MKPolyline *)overlay] autorelease];
        MKPolylineView *aView = [[[MKPolylineView alloc] initWithPolyline:(MKPolyline *)overlay] autorelease];
		[aView setStrokeColor:[UIColor redColor]];
		[aView setLineWidth:3];
 
        return aView;
    }
    if ([overlay isKindOfClass:[MKCircle class]])
    {
        MKCircleView *aView = [[[MKCircleView alloc] initWithCircle:overlay] autorelease];
		[aView setStrokeColor:[UIColor blueColor]];
		[aView setLineWidth:3];
        
        return aView;
        
    }
        
    return nil;
}

- (void)mapView:(MKMapView *)mv didAddAnnotationViews:(NSArray *)views
{
    MKAnnotationView *annotationView = [views objectAtIndex:0];
    id <MKAnnotation> mp = [annotationView annotation];
    MKCoordinateRegion region = 
    MKCoordinateRegionMakeWithDistance([mp coordinate], 250, 250);
    [mv setRegion:region animated:YES];
}

- (void)mapView:(MKMapView *)mpView didUpdateUserLocation:(MKUserLocation *)userLocation {
    CLLocationCoordinate2D coordinate = userLocation.location.coordinate;
    MKCoordinateRegion reg =
    MKCoordinateRegionMakeWithDistance(coordinate, 500, 500);
    mpView.region = reg;
}

- (void)findLocation
{
	[locationManager startUpdatingLocation];
	[activityIndicator startAnimating];
	[locationTitleField setHidden:YES];
}

- (void)foundLocation
{
	[locationTitleField setText:@""];
	[activityIndicator stopAnimating];
	[locationTitleField setHidden:NO];
	[locationManager stopUpdatingLocation];
}

- (BOOL)textFieldShouldReturn:(UITextField *)tf
{
	[self findLocation];
	[tf resignFirstResponder];
	return YES;
}




- (void)locationManager:(CLLocationManager *)manager
		didFailWithError:(NSError *)error
{
	NSLog(@"Could not find location: %@", error);
	[self foundLocation];
}

- (void)locationManager:(CLLocationManager *)manager 
	didUpdateToLocation:(CLLocation *)newLocation 
		   fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"==>>%@", newLocation);
	
    // How many seconds ago was this new location created?
    NSTimeInterval t = [[newLocation timestamp] timeIntervalSinceNow];
    // CLLocationManagers will return the last found location of the 
    // device first, you don't want that data in this case.
    // If this location was made was more than 3 minutes ago, ignore it. 
    if (t < -180) {
        // This is cached data, you don't want it, keep looking
        return;
    }
    MapPoint *mp = [[MapPoint alloc] 
                        initWithCoordinate:[newLocation coordinate] 
                                     title:[locationTitleField text]];
    [mapView addAnnotation:mp];
    [mp release];

    [self foundLocation];
}

- (void)dealloc {
	[mapView release];
	[activityIndicator release];
	[locationTitleField release];
	[locationManager release];
    [window release];
    [super dealloc];
}

- (void)mapViewWillStartLoadingMap:(MKMapView *)mapView
{
    NSLog(@"**mapView_WillStart__LoadingMap");    
}

- (void)mapViewWillStartLocatingUser:(MKMapView *)mapView
{
    NSLog(@"**mapView_WillStart_LocatingUser");        
}

- (void)mapViewDidStopLocatingUser:(MKMapView *)mapView
{
    NSLog(@"**mapView-DidStop-LocatingUser");        
}

- (void)mapViewDidFinishLoadingMap:(MKMapView *)mapView
{
    NSLog(@"**mapView-DidFinish--LoadingMap");    
}

@end
