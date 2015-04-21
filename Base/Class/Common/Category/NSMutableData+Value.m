//
//  NSMutableData+Value.m
//  Base
//
//  Created by sumeng on 4/16/15.
//  Copyright (c) 2015 sumeng. All rights reserved.
//

#import "NSMutableData+Value.h"

@implementation NSMutableData (Value)

- (NSMutableData *)appendInt:(int)val {
    [self appendBytes:&val length:sizeof(int)];
    return self;
}

- (NSMutableData *)appendByte:(Byte)val {
    [self appendBytes:&val length:sizeof(Byte)];
    return self;
}

- (NSMutableData *)appendCString:(char const*)str {
    int len = (int)strlen(str);
    [self appendBytes:str length:len];
    return self;
}

- (NSMutableData *)appendString:(NSString*)str encoding:(NSStringEncoding)encoding {
    NSData* strdata = [str dataUsingEncoding:encoding];
    [self appendData:strdata];
    return self;
}

@end
