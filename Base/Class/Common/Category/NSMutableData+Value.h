//
//  NSMutableData+Value.h
//  Base
//
//  Created by sumeng on 4/16/15.
//  Copyright (c) 2015 sumeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableData (Value)

- (NSMutableData *)appendInt:(int)value;
- (NSMutableData *)appendUInt:(unsigned int)value;
- (NSMutableData *)appendShort:(short)value;
- (NSMutableData *)appendUShort:(unsigned short)value;
- (NSMutableData *)appendByte:(Byte)value;

@end
