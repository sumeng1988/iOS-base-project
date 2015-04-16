//
//  NSData+Value.m
//  Base
//
//  Created by sumeng on 4/16/15.
//  Copyright (c) 2015 sumeng. All rights reserved.
//

#import "NSData+Value.h"

@implementation NSData (Value)

- (int)readInt:(int)offset {
    return *(int *)(self.bytes + offset);
}

- (Byte)readByte:(int)offset {
    return *(Byte *)(self.bytes + offset);
}

@end
