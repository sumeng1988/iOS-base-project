//
//  SMMemCache.m
//  Base
//
//  Created by sumeng on 5/6/15.
//  Copyright (c) 2015 sumeng. All rights reserved.
//

#import "SMMemCache.h"

@interface SMMemCache ()

@property (nonatomic, strong) NSString *path;
@property (nonatomic, strong) NSMutableDictionary *storage;

@end

@implementation SMMemCache

- (instancetype)init {
    return [self initWithName:nil];
}

- (instancetype)initWithName:(NSString *)name {
    self = [super init];
    if (self) {
        NSString *dir = [[FileSystem shared].documentDir stringByAppendingPathComponent:@"SMMemCache"];
        [[FileSystem shared] mkdir:dir];
        if (name.notEmpty) {
            _path = [dir stringByAppendingPathComponent:name];
        }
        else {
            _path = [dir stringByAppendingPathComponent:@"__default"];
        }
        _path = [_path stringByAppendingPathExtension:@"plist"];
        if ([[FileSystem shared] existsFile:_path]) {
            _storage = [[NSMutableDictionary alloc] initWithContentsOfFile:_path];
        }
        else {
            _storage = [[NSMutableDictionary alloc] init];
        }
    }
    return self;
}

- (void)dealloc {
    [self synchronize];
}

#pragma mark - public

- (id)objectForKey:(NSString *)key {
    return [_storage objectForKey:key];
}

- (void)setObject:(id)value forKey:(NSString *)key {
    [_storage setObject:value forKey:key];
    [self synchronize];
}

- (void)removeObjectForKey:(NSString *)key {
    [_storage removeObjectForKey:key];
    [self synchronize];
}


- (NSInteger)integerForKey:(NSString *)key {
    return [_storage integerForKey:key];
}

- (int)intForKey:(NSString *)key {
    return [_storage intForKey:key];
}

- (long)longForKey:(NSString *)key {
    return [_storage longForKey:key];
}

- (BOOL)boolForKey:(NSString *)key {
    return [_storage boolForKey:key];
}

- (float)floatForKey:(NSString *)key {
    return [_storage floatForKey:key];
}

- (double)doubleForKey:(NSString *)key {
    return [_storage doubleForKey:key];
}

- (NSString *)stringForKey:(NSString *)key {
    return [_storage stringForKey:key];
}

- (NSArray *)arrayForKey:(NSString *)key {
    return [_storage arrayForKey:key];
}

- (NSData *)dataForKey:(NSString *)key {
    return [_storage dataForKey:key];
}

- (NSDictionary *)dictionaryForKey:(NSString *)key {
    return [_storage dictionaryForKey:key];
}


- (void)setInteger:(NSInteger)value forKey:(NSString *)key {
    [_storage setInteger:value forKey:key];
    [self synchronize];
}

- (void)setInt:(int)value forKey:(NSString *)key {
    [_storage setInt:value forKey:key];
    [self synchronize];
}

- (void)setLong:(long)value forKey:(NSString *)key {
    [_storage setLong:value forKey:key];
    [self synchronize];
}

- (void)setBool:(BOOL)value forKey:(NSString *)key {
    [_storage setBool:value forKey:key];
    [self synchronize];
}

- (void)setFloat:(float)value forKey:(NSString *)key {
    [_storage setFloat:value forKey:key];
    [self synchronize];
}

- (void)setDouble:(double)value forKey:(NSString *)key {
    [_storage setDouble:value forKey:key];
    [self synchronize];
}

- (BOOL)synchronize {
    return [_storage writeToFile:_path atomically:YES];
}

#pragma mark - private


@end
