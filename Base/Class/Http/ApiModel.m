//
//  ApiModel.m
//  Base
//
//  Created by sumeng on 4/17/15.
//  Copyright (c) 2015 sumeng. All rights reserved.
//

#import "ApiModel.h"
#import "HttpRequest.h"

@interface ApiModel ()

@property (nonatomic, strong) NSMutableDictionary *params;
@property (nonatomic, strong) NSMutableDictionary *files;

@end

@implementation ApiModel

- (instancetype)init {
    self = [super init];
    if (self) {
        _showWaiting = YES;
        _showErrMsg = YES;
        
        _params = [[NSMutableDictionary alloc] init];
        _files = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (NSString *)url {
    return @"";
}

#pragma mark - public

- (void)get:(void (^)(ApiResponse *response))success
    failure:(void (^)(ApiRspMeta *meta))failure
{
    [[HttpRequest shared].manager GET:[self url]
                           parameters:_params
                              success:nil
                              failure:nil];
}

- (void)post:(void (^)(ApiResponse *response))success
     failure:(void (^)(ApiRspMeta *meta))failure
{
    if (_files.count > 0) {
        [[HttpRequest shared].manager POST:[self url]
                                parameters:_params
                 constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                     [self addMultipart:formData];
                 }
                                   success:nil
                                   failure:nil];
    }
    else {
        [[HttpRequest shared].manager POST:[self url]
                               parameters:_params
                                  success:nil
                                  failure:nil];
    }
}

- (void)setParam:(NSString *)key value:(id)value {
    if (key.notEmpty) {
        if (value != nil) {
            [_params setObject:value forKey:key];
        }
        else {
            [_params removeObjectForKey:key];
        }
    }
}

- (void)setFile:(NSString *)key value:(id)value {
    if (key.notEmpty) {
        if (value != nil) {
            [_files setObject:value forKey:key];
        }
        else {
            [_files removeObjectForKey:key];
        }
    }
}

#pragma mark - private

- (void)addMultipart:(id<AFMultipartFormData>)formData {
    for (NSString *key in _files) {
        id obj = _files[key];
        if ([obj isKindOfClass:[NSString class]]) {
            NSString *path = obj;
            [formData appendPartWithFileURL:[NSURL fileURLWithPath:path] name:key error:nil];
        }
        else if ([obj isKindOfClass:[NSArray class]]) {
            NSArray *paths = obj;
            for (NSString *path in paths) {
                NSString *name = [key stringByAppendingString:@"[]"];
                [formData appendPartWithFileURL:[NSURL fileURLWithPath:path] name:name error:nil];
            }
        }
    }
}

@end
