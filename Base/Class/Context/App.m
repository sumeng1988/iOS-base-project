//
//  App.m
//  Base
//
//  Created by sumeng on 4/16/15.
//  Copyright (c) 2015 sumeng. All rights reserved.
//

#import "App.h"

@implementation App

- (id)init {
    self = [super init];
    if (self) {
        NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
        _version = [infoDict stringForKey:(NSString *)kCFBundleVersionKey];
        _name = [infoDict stringForKey:(NSString *)kCFBundleNameKey];
        _displayName = [infoDict stringForKey:@"CFBundleDisplayName"];
    }
    return self;
}

@end
