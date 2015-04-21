//
//  NSObject+Swizzle.h
//  Base
//
//  Created by sumeng on 4/21/15.
//  Copyright (c) 2015 sumeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Swizzle)

+ (IMP)swizzleSelector:(SEL)origSelector
               withIMP:(IMP)newIMP;

@end