//
//  NSObject+Attachment.m
//  Base
//
//  Created by sumeng on 4/16/15.
//  Copyright (c) 2015 sumeng. All rights reserved.
//

#import "NSObject+Attachment.h"

#include <objc/runtime.h>

@implementation NSObject (attachment)

static void *__s_nsobject_attachment;

- (NSMutableDictionary *)attachment {
    NSMutableDictionary *attachment = nil;
    @synchronized(self) {
        attachment = objc_getAssociatedObject(self, &__s_nsobject_attachment);
        if (attachment == nil) {
            attachment = [[NSMutableDictionary alloc] init];
            objc_setAssociatedObject(self, &__s_nsobject_attachment, attachment, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
    }
    return attachment;
}

@end