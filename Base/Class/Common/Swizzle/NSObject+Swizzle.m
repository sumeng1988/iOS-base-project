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

+ (IMP)swizzleSelector:(SEL)origSelector
               withIMP:(IMP)newIMP
{
    Method origMethod = class_getInstanceMethod([self class], origSelector);
    IMP origIMP = method_getImplementation(origMethod);
    if(!class_addMethod(self, origSelector, newIMP, method_getTypeEncoding(origMethod)))
    {
        method_setImplementation(origMethod, newIMP);
    }
    return origIMP;
}

@end
