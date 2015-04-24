//
//  NSData+Value.m
//  Base
//
//  Created by sumeng on 4/16/15.
//  Copyright (c) 2015 sumeng. All rights reserved.
//

#import "NSData+Value.h"

@implementation NSData (Value)

- (int)readInt:(NSUInteger)offset {
    return *(int *)(self.bytes + offset);
}

- (unsigned int)readUInt:(NSUInteger)offset {
    return *(unsigned int *)(self.bytes + offset);
}

- (short)readShort:(NSUInteger)offset {
    return *(short *)(self.bytes + offset);
}

- (unsigned short)readUShort:(NSUInteger)offset {
    return *(unsigned short *)(self.bytes + offset);
}

- (Byte)readByte:(NSUInteger)offset {
    return *(Byte *)(self.bytes + offset);
}

@end
