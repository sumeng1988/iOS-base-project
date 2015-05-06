//
//  NSMutableDictionary+Value.m
//  Base
//
//  Created by sumeng on 4/16/15.
//  Copyright (c) 2015 sumeng. All rights reserved.
//

#import "NSMutableDictionary+Value.h"

@implementation NSMutableDictionary (Value)

- (void)setInteger:(NSInteger)value forKey:(NSString *)key {
    [self setObject:[NSNumber numberWithInteger:value] forKey:key];
}

- (void)setInt:(int)value forKey:(NSString *)key {
    [self setObject:[NSNumber numberWithInt:value] forKey:key];
}

- (void)setLong:(long)value forKey:(NSString *)key {
    [self setObject:[NSNumber numberWithLong:value] forKey:key];
}

- (void)setBool:(BOOL)value forKey:(NSString *)key {
    [self setObject:[NSNumber numberWithBool:value] forKey:key];
}

- (void)setFloat:(float)value forKey:(NSString *)key {
    [self setObject:[NSNumber numberWithFloat:value] forKey:key];
}

- (void)setDouble:(double)value forKey:(NSString *)key {
    [self setObject:[NSNumber numberWithDouble:value] forKey:key];
}

@end
