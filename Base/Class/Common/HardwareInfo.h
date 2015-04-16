//
//  HardwareInfo.h
//  Base
//
//  Created by sumeng on 4/16/15.
//  Copyright (c) 2015 sumeng. All rights reserved.
//

@interface HardwareInfo : NSObject

+ (NSString*)NetMACAddress;
+ (NSString*)Platform;
+ (NSString*)PlatformString;
+ (NSString*)CarrierName;

@end
