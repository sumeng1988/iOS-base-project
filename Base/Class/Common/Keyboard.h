//
//  Keyboard.h
//  Base
//
//  Created by sumeng on 4/16/15.
//  Copyright (c) 2015 sumeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Keyboard : NSObject

@property (nonatomic, assign, readonly) BOOL visible;

SHARED_DECL
+ (void)close;

@end
