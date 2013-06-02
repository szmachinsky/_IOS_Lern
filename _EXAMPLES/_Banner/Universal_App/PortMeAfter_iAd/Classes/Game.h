//
//  Game.h
//  PortMe
//
//  Created by Ray Wenderlich on 5/10/10.
//  Copyright 2010 Ray Wenderlich. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Game : NSObject {
    NSString *_name;
    NSString *_type;
    NSString *_descr;
    NSArray *_ratingArray;
    int _ratingIndex;
}

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *descr;
@property (nonatomic, retain) NSArray *ratingArray;
@property (nonatomic, assign) int ratingIndex;

- (id)initWithName:(NSString *)name type:(NSString *)type descr:(NSString *)descr;
- (NSString *)rating;

@end

