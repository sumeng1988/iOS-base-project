//
//  HttpRequest.m
//  Base
//
//  Created by sumeng on 4/17/15.
//  Copyright (c) 2015 sumeng. All rights reserved.
//

#import "HttpRequest.h"

#define kHttpBaseUrl @"http://www.baidu.com"

@implementation HttpRequest

SHARED_IMPL

- (instancetype)init {
    self = [super init];
    if (self) {
        _manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:kHttpBaseUrl]];
    }
    return self;
}

@end
