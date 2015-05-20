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
        _bundleDir = [[NSBundle mainBundle].resourcePath copy];
        _documentDir = [dirs.lastObject copy];
        _cacheDir = [caches.lastObject copy];
        _tmpDir = [NSTemporaryDirectory() copy];
    }
    return self;
}

- (BOOL)mkdir:(NSString *)dir {
    return [self mkdir:dir intermediate:NO];
}

- (BOOL)mkdir:(NSString*)dir intermediate:(BOOL)intermediate {
    return [_fmgr createDirectoryAtPath:dir withIntermediateDirectories:intermediate attributes:nil error:nil];
}

- (BOOL)exists:(NSString*)path {
    return [_fmgr fileExistsAtPath:path];
}

- (BOOL)existsDir:(NSString*)dir {
    BOOL isDir;
    BOOL ret = [_fmgr fileExistsAtPath:dir isDirectory:&isDir];
    return (ret && dir);
}

- (BOOL)existsFile:(NSString*)path {
    BOOL isDir;
    BOOL ret = [_fmgr fileExistsAtPath:path isDirectory:&isDir];
    return (ret && !isDir);
}

- (BOOL)remove:(NSString *)path {
    NSError* err = nil;
    BOOL ret = [_fmgr removeItemAtPath:path error:&err];
    return ret;
}

- (NSString *)temporary:(NSString *)dir {
    NSString *file = [NSString UUID];
    if (dir.notEmpty) {
        [self mkdir:dir];
        return [dir stringByAppendingPathComponent:file];
    }
    else {
        return [_tmpDir stringByAppendingPathComponent:file];
    }
}

- (NSString*)temporary {
    return [self temporary:nil];
}

@end
