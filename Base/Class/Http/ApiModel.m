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

- (void)GET:(void (^)(ApiResponse *response))success
    failure:(void (^)(ApiRspMeta *meta))failure
{
    if (_showWaiting) {
        [SMHud showProgressInView:_waitingView];
    }
    [[HttpRequest shared].manager GET:[self url]
                           parameters:(_params.count > 0 ? _params : nil)
                              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                  [self onSuccess:operation
                                       responseObject:responseObject
                                              success:success
                                              failure:failure];
                              } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                  [self onFailure:operation
                                                error:error
                                              failure:failure];
                              }];
}

- (void)POST:(void (^)(ApiResponse *response))success
     failure:(void (^)(ApiRspMeta *meta))failure
{
    if (_showWaiting) {
        [SMHud showProgressInView:_waitingView];
    }
    if (_files.count > 0) {
        [[HttpRequest shared].manager POST:[self url]
                                parameters:(_params.count > 0 ? _params : nil)
                 constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                     [self addMultipart:formData];
                 }
                                   success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                       [self onSuccess:operation
                                            responseObject:responseObject
                                                   success:success
                                                   failure:failure];
                                   } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                       [self onFailure:operation
                                                     error:error
                                                   failure:failure];
                                   }];
    }
    else {
        [[HttpRequest shared].manager POST:[self url]
                                parameters:_params
                                   success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                       [self onSuccess:operation
                                            responseObject:responseObject
                                                   success:success
                                                   failure:failure];
                                   } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                       [self onFailure:operation
                                                     error:error
                                                   failure:failure];
                                   }];
    }
}

- (void)PUT:(void (^)(ApiResponse *response))success
     failure:(void (^)(ApiRspMeta *meta))failure
{
    if (_showWaiting) {
        [SMHud showProgressInView:_waitingView];
    }
    [[HttpRequest shared].manager PUT:[self url]
                           parameters:_params
                              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                  [self onSuccess:operation
                                   responseObject:responseObject
                                          success:success
                                          failure:failure];
                              } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                  [self onFailure:operation
                                            error:error
                                          failure:failure];
                              }];
}

- (void)DELETE:(void (^)(ApiResponse *response))success
    failure:(void (^)(ApiRspMeta *meta))failure
{
    if (_showWaiting) {
        [SMHud showProgressInView:_waitingView];
    }
    [[HttpRequest shared].manager DELETE:[self url]
                           parameters:_params
                              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                  [self onSuccess:operation
                                   responseObject:responseObject
                                          success:success
                                          failure:failure];
                              } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                  [self onFailure:operation
                                            error:error
                                          failure:failure];
                              }];
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

- (void)onSuccess:(AFHTTPRequestOperation *)operation
   responseObject:(id)responseObject
          success:(void (^)(ApiResponse *response))success
          failure:(void (^)(ApiRspMeta *meta))failure
{
    if (_showWaiting) {
        [SMHud hideProgress];
    }
    
    if ([responseObject isKindOfClass:[NSDictionary class]]) {
        ApiResponse *rsp = [[ApiResponse alloc] init];
        Class cls = nil;
        if ([operation.request.HTTPMethod isEqualToString:@"GET"]) {
            cls = _clsRspDataGET;
        }
        else if ([operation.request.HTTPMethod isEqualToString:@"POST"]) {
            cls = _clsRspDataPOST;
        }
        else if ([operation.request.HTTPMethod isEqualToString:@"PUT"]) {
            cls = _clsRspDataPUT;
        }
        else if ([operation.request.HTTPMethod isEqualToString:@"DELETE"]) {
            cls = _clsRspDataDELETE;
        }
        rsp.data = [[cls alloc] init];
        [rsp parseDict:responseObject];
        if (rsp.meta.code == 200) {
            if (success != nil) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    success(rsp);
                });
            }
        }
        else {
            if (_showErrMsg) {
                [SMHud text:rsp.meta.message];
            }
            if (failure != nil) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    failure(rsp.meta);
                });
            }
        }
    }
}

- (void)onFailure:(AFHTTPRequestOperation *)operation
            error:(NSError *)error
          failure:(void (^)(ApiRspMeta *meta))failure
{
    ApiRspMeta *meta = [[ApiRspMeta alloc] init];
    meta.code = -1;
    meta.message = @"网络错误";
    if (_showWaiting) {
        [SMHud hideProgress];
    }
    if (_showErrMsg) {
        [SMHud text:meta.message];
    }
    if (failure != nil) {
        dispatch_async(dispatch_get_main_queue(), ^{
            failure(meta);
        });
    }
}

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
