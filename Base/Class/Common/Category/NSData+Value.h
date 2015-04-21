//
//  NSData+Value.h
//  Base
//
//  Created by sumeng on 4/16/15.
//  Copyright (c) 2015 sumeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (Value)

- (int)readInt:(int)offset;
- (Byte)readByte:(int)offset;

@end