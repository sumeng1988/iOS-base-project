//
//  NSMutableData+Value.m
//  Base
//
//  Created by sumeng on 4/16/15.
//  Copyright (c) 2015 sumeng. All rights reserved.
//

#import "NSMutableData+Value.h"

@implementation NSMutableData (Value)

- (NSMutableData *)appendInt:(int)value {
    [self appendBytes:&value length:sizeof(int)];
    return self;
}

- (NSMutableData *)appendUInt:(unsigned int)value {
    [self appendBytes:&value length:sizeof(unsigned int)];
    return self;
}

- (NSMutableData *)appendShort:(short)value {
    [self appendBytes:&value length:sizeof(short)];
    return self;
}

- (NSMutableData *)appendUShort:(unsigned short)value {
    [self appendBytes:&value length:sizeof(unsigned short)];
    return self;
}

- (NSMutableData *)appendByte:(Byte)val {
    [self appendBytes:&val length:sizeof(Byte)];
    return self;
}

@end
