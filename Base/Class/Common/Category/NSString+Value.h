//
//  NSString+Value.h
//  Base
//
//  Created by sumeng on 4/16/15.
//  Copyright (c) 2015 sumeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Value)

+ (NSString*)UUID;

- (BOOL)notEmpty;
- (NSString *)MD5;
- (NSString*)SHA1;

@end