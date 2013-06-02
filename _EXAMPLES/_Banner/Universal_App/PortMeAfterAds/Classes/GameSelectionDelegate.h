//
//  GameSelectionDelegate.h
//  PortMe
//
//  Created by Ray Wenderlich on 5/10/10.
//  Copyright 2010 Ray Wenderlich. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Game;

@protocol GameSelectionDelegate
- (void)gameSelectionChanged:(Game *)curSelection;
@end
