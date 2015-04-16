//
//  FileSystem.h
//  Base
//
//  Created by sumeng on 4/16/15.
//  Copyright (c) 2015 sumeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileSystem : NSObject

@property (nonatomic, copy) NSString* bundleDirectory;
@property (nonatomic, copy) NSString* cacheDirectory;
@property (nonatomic, copy) NSString* rootWritable;
@property (nonatomic, copy) NSString* tmpDirectory;

SHARED_DECL

- (NSString*)pathWritable:(NSString*)name;
- (NSString*)pathBundle:(NSString*)name;
- (NSString*)dirCache:(NSString*)name;

- (BOOL)mkdir:(NSString*)path;
- (BOOL)mkdir:(NSString *)path intermediate:(BOOL)intermediate;

- (BOOL)exists:(NSString*)path;
- (BOOL)existsDir:(NSString*)path;
- (BOOL)existsFile:(NSString*)path;

- (BOOL)remove:(NSString*)path;

- (NSString*)temporary;
- (NSString *)picturesTemporary;
- (BOOL)removePicturesTemporaryFiles;

- (NSString *)chatDirectoryWithName:(NSString *)name;
- (BOOL)removeChatPicturesWithName:(NSString *)name;

@end
