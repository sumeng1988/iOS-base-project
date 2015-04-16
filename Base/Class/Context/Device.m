//
//  Device.m
//  Base
//
//  Created by sumeng on 4/16/15.
//  Copyright (c) 2015 sumeng. All rights reserved.
//

#import "Device.h"
#import "OpenUDID.h"

@implementation Device

- (id)init {
    self = [super init];
    if (self) {
        _equipid = [OpenUDID value];
        _sysversion = [NSString stringWithFormat:@"iOS %@", [[UIDevice currentDevice] systemVersion]];
        _cellbrand = @"Apple";
        _cellmodel = [HardwareInfo PlatformString];
        _macaddr = [HardwareInfo NetMACAddress];
        _carrier = [HardwareInfo CarrierName];
    }
    return self;
}

@end
