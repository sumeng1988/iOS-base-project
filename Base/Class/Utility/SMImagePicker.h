//
//  SMImagePicker.h
//  Base
//
//  Created by sumeng on 4/16/15.
//  Copyright (c) 2015 sumeng. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kImagePickerPath @"Path"
#define kImagePickerThumbImage @"ThumbImage"
#define kImagePickerAsset @"Asset"

@protocol SMImagePickerDelegate;

@interface SMImagePicker : NSObject

@property (nonatomic, weak) id<SMImagePickerDelegate> delegate;
@property (nonatomic, assign) BOOL allowEditing;
@property (nonatomic, assign) NSInteger maximumNumberOfSelection;
@property (nonatomic, assign) CGSize thumbSize;
@property (nonatomic, assign) UIViewContentMode thumbMode;
@property (nonatomic, copy) NSString *saveDir;

- (id)initWithDelegate:(id<SMImagePickerDelegate>)delegate;
- (void)execute:(UIImagePickerControllerSourceType)sourceType inViewController:(UIViewController *)vc;

+ (void)clearCacheFiles;

@end

@protocol SMImagePickerDelegate <NSObject>

@optional

- (void)imagePicker:(SMImagePicker *)picker didFinishPickingWithInfos:(NSArray *)infos;
- (void)imagePickerDidCancel:(SMImagePicker *)picker;

@end