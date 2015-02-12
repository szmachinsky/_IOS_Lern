//
//  BeerDetails.h
//  BeerTracker
//
//  Created by Zmachinsky Sergei on 06.02.15.
//  Copyright (c) 2015 Andy Pereira. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface BeerDetails : NSManagedObject

@property (nonatomic, retain) NSString * image;
@property (nonatomic, retain) NSString * note;
@property (nonatomic, retain) NSNumber * rating;
@property (nonatomic, retain) NSManagedObject *beer;

@end
