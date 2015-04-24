//
//  NSData+Value.h
//  Base
//
//  Created by sumeng on 4/16/15.
//  Copyright (c) 2015 sumeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (Value)

- (int)readInt:(NSUInteger)offset;
- (unsigned int)readUInt:(NSUInteger)offset;
- (short)readShort:(NSUInteger)offset;
- (unsigned short)readUShort:(NSUInteger)offset;
- (Byte)readByte:(NSUInteger)offset;

@end
