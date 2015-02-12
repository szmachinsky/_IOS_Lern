//
//  Beer.h
//  BeerTracker
//
//  Created by Zmachinsky Sergei on 06.02.15.
//  Copyright (c) 2015 Andy Pereira. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class BeerDetails;

@interface Beer : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) BeerDetails *beerDetails;

@end
