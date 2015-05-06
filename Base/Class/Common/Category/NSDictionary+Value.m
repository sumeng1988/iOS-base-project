//
//  NSDictionary+Value.m
//  Base
//
//  Created by sumeng on 4/16/15.
//  Copyright (c) 2015 sumeng. All rights reserved.
//

#import "NSDictionary+Value.h"

@implementation NSDictionary (Value)

- (NSInteger)integerForKey:(NSString *)key {
    return [self integerForKey:key def:0];
}

- (int)intForKey:(NSString *)key {
    return [self intForKey:key def:0];
}

- (long)longForKey:(NSString *)key {
    return [self longForKey:key def:0];
}

- (BOOL)boolForKey:(NSString *)key {
    return [self boolForKey:key def:NO];
}

- (float)floatForKey:(NSString *)key {
    return [self floatForKey:key def:0.0f];
}

- (double)doubleForKey:(NSString *)key {
    return [self doubleForKey:key def:0.0];
}

- (NSString *)stringForKey:(NSString *)key {
    return [self stringForKey:key def:@""];
}

- (NSArray *)arrayForKey:(NSString *)key {
    return [self arrayForKey:key def:nil];
}

- (NSData *)dataForKey:(NSString *)key {
    return [self dataForKey:key def:nil];
}

- (NSDictionary *)dictionaryForKey:(NSString *)key {
    return [self dictionaryForKey:key def:nil];
}

- (NSInteger)integerForKey:(NSString *)key def:(NSInteger)def {
    id obj = [self objectForKey:key];
    if ([obj isKindOfClass:[NSNumber class]])
        return [(NSNumber *)obj integerValue];
    else if ([obj isKindOfClass:[NSString class]])
        return [(NSString *)obj integerValue];
    else
        return def;
}

- (int)intForKey:(NSString *)key def:(int)def {
    id obj = [self objectForKey:key];
    if ([obj isKindOfClass:[NSNumber class]])
        return [(NSNumber *)obj intValue];
    else if ([obj isKindOfClass:[NSString class]])
        return [(NSString *)obj intValue];
    else
        return def;
}

- (long)longForKey:(NSString *)key def:(long)def {
    id obj = [self objectForKey:key];
    if ([obj isKindOfClass:[NSNumber class]])
        return [(NSNumber *)obj longValue];
    else if ([obj isKindOfClass:[NSString class]])
        return [(NSString *)obj longLongValue];
    else
        return def;
}

- (BOOL)boolForKey:(NSString *)key def:(BOOL)def {
    id obj = [self objectForKey:key];
    if ([obj isKindOfClass:[NSNumber class]])
        return [(NSNumber *)obj boolValue];
    else if ([obj isKindOfClass:[NSString class]])
        return [(NSString *)obj boolValue];
    else
        return def;
    
}

- (float)floatForKey:(NSString *)key def:(float)def {
    id obj = [self objectForKey:key];
    if ([obj isKindOfClass:[NSNumber class]])
        return [(NSNumber *)obj floatValue];
    else if ([obj isKindOfClass:[NSString class]])
        return [(NSString *)obj floatValue];
    else
        return def;
}

- (double)doubleForKey:(NSString *)key def:(double)def {
    id obj = [self objectForKey:key];
    if ([obj isKindOfClass:[NSNumber class]])
        return [(NSNumber *)obj doubleValue];
    else if ([obj isKindOfClass:[NSString class]])
        return [(NSString *)obj doubleValue];
    else
        return def;
    
}

- (NSString *)stringForKey:(NSString *)key def:(NSString *)def {
    id obj = [self objectForKey:key];
    if ([obj isKindOfClass:[NSNumber class]])
        return [(NSNumber *)obj stringValue];
    else if ([obj isKindOfClass:[NSString class]])
        return obj;
    else
        return def;
    
}

- (NSArray *)arrayForKey:(NSString *)key def:(NSArray *)def {
    id obj = [self objectForKey:key];
    if ([obj isKindOfClass:[NSArray class]])
        return obj;
    else
        return def;
    
}

- (NSData *)dataForKey:(NSString *)key def:(NSData *)def {
    id obj = [self objectForKey:key];
    if ([obj isKindOfClass:[NSData class]])
        return obj;
    else
        return def;
}

- (NSDictionary *)dictionaryForKey:(NSString *)key def:(NSDictionary *)def {
    id obj = [self objectForKey:key];
    if ([obj isKindOfClass:[NSDictionary class]])
        return obj;
    else
        return def;
}

@end
