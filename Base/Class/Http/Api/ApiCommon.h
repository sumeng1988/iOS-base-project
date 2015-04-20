//
//  ApiCommon.h
//  Base
//
//  Created by sumeng on 4/17/15.
//  Copyright (c) 2015 sumeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ApiRspMeta : NSObject

@property (nonatomic, assign) int code;
@property (nonatomic, strong) NSString *error;
@property (nonatomic, strong) NSString *message;

@end

@interface ApiResponse : NSObject

@property (nonatomic, strong) ApiRspMeta *meta;
@property (nonatomic, strong) id data;

@end
