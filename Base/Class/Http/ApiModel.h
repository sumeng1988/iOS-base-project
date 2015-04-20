//
//  ApiModel.h
//  Base
//
//  Created by sumeng on 4/17/15.
//  Copyright (c) 2015 sumeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ApiCommon.h"

@interface ApiModel : NSObject

@property (nonatomic, assign) BOOL showWaiting;
@property (nonatomic, assign) BOOL showErrMsg;
@property (nonatomic, strong) UIView *waitingView;

@property (nonatomic, assign) Class clsRspDataGET;
@property (nonatomic, assign) Class clsRspDataPOST;
@property (nonatomic, assign) Class clsRspDataPUT;
@property (nonatomic, assign) Class clsRspDataDELETE;

- (void)GET:(void (^)(ApiResponse *response))success
    failure:(void (^)(ApiRspMeta *meta))failure;

- (void)POST:(void (^)(ApiResponse *response))success
    failure:(void (^)(ApiRspMeta *meta))failure;

- (void)PUT:(void (^)(ApiResponse *response))success
     failure:(void (^)(ApiRspMeta *meta))failure;

- (void)DELETE:(void (^)(ApiResponse *response))success
     failure:(void (^)(ApiRspMeta *meta))failure;

@end

@interface ApiModel (subclass)

- (NSString *)url;

- (void)setParam:(NSString *)key value:(id)value;
- (void)setFile:(NSString *)key value:(id)value;

@end
