//
//  Context.h
//  Base
//
//  Created by sumeng on 4/16/15.
//  Copyright (c) 2015 sumeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "App.h"
#import "Device.h"

@interface Context : NSObject

@property (nonatomic, strong, readonly) Device *device;
@property (nonatomic, strong, readonly) App *app;

SHARED_DECL

@end
