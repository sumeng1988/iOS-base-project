//
//  NSMutableDictionary+Value.h
//  Base
//
//  Created by sumeng on 4/16/15.
//  Copyright (c) 2015 sumeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary (Value)

- (void)setInteger:(NSInteger)value forKey:(NSString *)key;
- (void)setInt:(int)value forKey:(NSString *)key;
- (void)setLong:(long)value forKey:(NSString *)key;
- (void)setBool:(BOOL)value forKey:(NSString *)key;
- (void)setFloat:(float)value forKey:(NSString *)key;
- (void)setDouble:(double)value forKey:(NSString *)key;

@end
