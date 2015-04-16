//
//  FileSystem.m
//  Base
//
//  Created by sumeng on 4/16/15.
//  Copyright (c) 2015 sumeng. All rights reserved.
//

#import "FileSystem.h"

#include <sys/types.h>
#include <sys/event.h>
#include <sys/time.h>

@interface FileSystem () {
    NSFileManager* _fmgr;
}

@end

@implementation FileSystem

SHARED_IMPL

- (instancetype)init {
    self = [super init];
    if (self) {
        _fmgr = [NSFileManager defaultManager];
        
        NSArray* dirs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSArray* caches = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        
        // 获得写入的根目录
        _bundleDirectory = [[NSBundle mainBundle].resourcePath copy];
        _rootWritable = [dirs.lastObject copy];
        _cacheDirectory = [caches.lastObject copy];
        _tmpDirectory = [NSTemporaryDirectory() copy];
    }
    return self;
}

- (NSString*)pathWritable:(NSString*)name {
    return [_rootWritable stringByAppendingFormat:@"/%@", name];
}

- (NSString*)pathBundle:(NSString *)name {
    return [_bundleDirectory stringByAppendingFormat:@"/%@", name];
}

- (NSString*)dirCache:(NSString*)name {
    NSString* ret = [_cacheDirectory stringByAppendingFormat:@"/%@/", name];
    [self mkdir:ret];
    return ret;
}

- (BOOL)mkdir:(NSString *)path {
    return [self mkdir:path intermediate:NO];
}

- (BOOL)mkdir:(NSString*)path intermediate:(BOOL)intermediate {
    return [_fmgr createDirectoryAtPath:path withIntermediateDirectories:intermediate attributes:nil error:nil];
}

- (BOOL)exists:(NSString*)path {
    return [_fmgr fileExistsAtPath:path];
}

- (BOOL)existsDir:(NSString*)path {
    BOOL dir;
    BOOL ret = [_fmgr fileExistsAtPath:path isDirectory:&dir];
    if (ret && dir)
        return YES;
    return NO;
}

- (BOOL)existsFile:(NSString*)path {
    BOOL dir;
    BOOL ret = [_fmgr fileExistsAtPath:path isDirectory:&dir];
    if (ret && !dir)
        return YES;
    return NO;
}

- (BOOL)remove:(NSString *)path {
    NSError* err = nil;
    BOOL ret = [_fmgr removeItemAtPath:path error:&err];
//    if (err)
//        [err log];
    return ret;
}

- (NSString*)temporary {
    NSString* sufx = [NSString stringWithFormat:@"tmp%d%ld", (int)time(NULL), clock()];
    return [_tmpDirectory stringByAppendingString:sufx];
}

- (NSString *)picturesTemporary {
    NSString* sufx = [NSString stringWithFormat:@"tmp%d%ld", (int)time(NULL), clock()];
    NSString * path = [_tmpDirectory stringByAppendingPathComponent:@"temPic"];
    if (![self existsDir:path]) {
        [self mkdir:path];
    }
    return [path stringByAppendingPathComponent:sufx];
}

- (BOOL)removePicturesTemporaryFiles {
    return [self remove:[_tmpDirectory stringByAppendingPathComponent:@"temPic"]];
}

- (NSString *)chatDirectoryWithName:(NSString *)name {
    NSString * path = [_rootWritable stringByAppendingPathComponent:@"chat"];
    if (![self existsDir:path]) {
        [self mkdir:path];
    }
    return [path stringByAppendingPathComponent:name];
}

- (BOOL)removeChatPicturesWithName:(NSString *)name {
    return [self remove:[[_rootWritable stringByAppendingPathComponent:@"chat"] stringByAppendingPathComponent:name]];
}

@end
