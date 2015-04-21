//
//  NSDictionary+Value.h
//  Base
//
//  Created by sumeng on 4/16/15.
//  Copyright (c) 2015 sumeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Value)

- (NSInteger)integerForKey:(NSString *)key;
- (int)intForKey:(NSString *)key;
- (BOOL)boolForKey:(NSString *)key;
- (float)floatForKey:(NSString *)key;
- (double)doubleForKey:(NSString *)key;
- (NSString *)stringForKey:(NSString *)key;
- (NSArray *)arrayForKey:(NSString *)key;
- (NSData *)dataForKey:(NSString *)key;
- (NSDictionary *)dictionaryForKey:(NSString *)key;

- (NSInteger)integerForKey:(NSString *)key def:(NSInteger)def;
- (int)intForKey:(NSString *)key def:(int)def;
- (BOOL)boolForKey:(NSString *)key def:(BOOL)def;
- (float)floatForKey:(NSString *)key def:(float)def;
- (double)doubleForKey:(NSString *)key def:(double)def;
- (NSString *)stringForKey:(NSString *)key def:(NSString *)def;
- (NSArray *)arrayForKey:(NSString *)key def:(NSArray *)def;
- (NSData *)dataForKey:(NSString *)key def:(NSData *)def;
- (NSDictionary *)dictionaryForKey:(NSString *)key def:(NSDictionary *)def;

@end
