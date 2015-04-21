//
//  NSMutableData+Value.h
//  Base
//
//  Created by sumeng on 4/16/15.
//  Copyright (c) 2015 sumeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableData (Value)

- (NSMutableData *)appendInt:(int)val;
- (NSMutableData *)appendByte:(Byte)val;
- (NSMutableData *)appendCString:(char const*)str;
- (NSMutableData *)appendString:(NSString*)str encoding:(NSStringEncoding)encoding;

@end
