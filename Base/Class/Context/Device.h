//
//  Device.h
//  Base
//
//  Created by sumeng on 4/16/15.
//  Copyright (c) 2015 sumeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Device : NSObject

@property (nonatomic, strong, readonly) NSString* equipid;
@property (nonatomic, strong, readonly) NSString* sysversion;
@property (nonatomic, strong, readonly) NSString* cellbrand;
@property (nonatomic, strong, readonly) NSString* cellmodel;
@property (nonatomic, strong, readonly) NSString* macaddr;
@property (nonatomic, strong, readonly) NSString* carrier;

@end
