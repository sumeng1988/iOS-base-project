//
//  SMMemCache.h
//  Base
//
//  Created by sumeng on 5/6/15.
//  Copyright (c) 2015 sumeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMMemCache : NSObject

- (instancetype)initWithName:(NSString *)name;

- (id)objectForKey:(NSString *)key;
- (void)setObject:(id)value forKey:(NSString *)key;
- (void)removeObjectForKey:(NSString *)key;

- (NSInteger)integerForKey:(NSString *)key;
- (int)intForKey:(NSString *)key;
- (long)longForKey:(NSString *)key;
- (BOOL)boolForKey:(NSString *)key;
- (float)floatForKey:(NSString *)key;
- (double)doubleForKey:(NSString *)key;
- (NSString *)stringForKey:(NSString *)key;
- (NSArray *)arrayForKey:(NSString *)key;
- (NSData *)dataForKey:(NSString *)key;
- (NSDictionary *)dictionaryForKey:(NSString *)key;

- (void)setInteger:(NSInteger)value forKey:(NSString *)key;
- (void)setInt:(int)value forKey:(NSString *)key;
- (void)setLong:(long)value forKey:(NSString *)key;
- (void)setBool:(BOOL)value forKey:(NSString *)key;
- (void)setFloat:(float)value forKey:(NSString *)key;
- (void)setDouble:(double)value forKey:(NSString *)key;

- (BOOL)synchronize;

@end
