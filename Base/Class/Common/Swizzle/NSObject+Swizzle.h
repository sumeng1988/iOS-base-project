//
//  NSObject+Swizzle.h
//  Base
//
//  Created by sumeng on 4/21/15.
//  Copyright (c) 2015 sumeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Swizzle)

+ (void)swizzleSelector:(SEL)origSel withSelector:(SEL)newSel;

@end
