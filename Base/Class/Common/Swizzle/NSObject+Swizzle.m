//
//  NSObject+Swizzle.m
//  Base
//
//  Created by sumeng on 4/21/15.
//  Copyright (c) 2015 sumeng. All rights reserved.
//

#import "NSObject+Swizzle.h"
#include <objc/runtime.h>

@implementation NSObject (Swizzle)

+ (void)swizzleSelector:(SEL)origSel withSelector:(SEL)newSel {
    Method origMethod = class_getInstanceMethod(self, origSel);
    Method newMethod = class_getInstanceMethod(self, newSel);
    method_exchangeImplementations(origMethod, newMethod);
}

@end
