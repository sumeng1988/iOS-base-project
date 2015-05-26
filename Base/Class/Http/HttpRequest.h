//
//  HttpRequest.h
//  Base
//
//  Created by sumeng on 4/17/15.
//  Copyright (c) 2015 sumeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface HttpRequest : NSObject

@property (nonatomic, strong, readonly) AFHTTPSessionManager *manager;

SHARED_DECL

@end
