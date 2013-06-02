//
//  Game.m
//  PortMe
//
//  Created by Ray Wenderlich on 5/10/10.
//  Copyright 2010 Ray Wenderlich. All rights reserved.
//

#import "Game.h"

@implementation Game
@synthesize name = _name;
@synthesize type = _type;
@synthesize descr = _descr;
@synthesize ratingArray = _ratingArray;
@synthesize ratingIndex = _ratingIndex;

- (id)initWithName:(NSString *)name type:(NSString *)type descr:(NSString *)descr {
 
    if ((self = [super init])) {
        self.name = name;
        self.type = type;
        self.descr = descr;
        self.ratingArray = [NSArray arrayWithObjects:@"Never Played", @"Horrible", @"OK", @"Totally Awesome", nil];
        self.ratingIndex = 0;
    }
    return self;

}

- (NSString *)rating {
    return [_ratingArray objectAtIndex:_ratingIndex];
}

- (void) dealloc
{
    self.name = nil;
    self.type = nil;
    self.descr = nil;
    self.ratingArray = nil;   
    [super dealloc];
}


@end
