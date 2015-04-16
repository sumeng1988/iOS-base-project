//
//  SMImageLibrary.h
//  Base
//
//  Created by sumeng on 4/16/15.
//  Copyright (c) 2015 sumeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMImageLibrary : NSObject

+ (void)save:(UIImage *)image;

@end

@protocol SMImageLibraryPickerDelegate;

@interface SMImageLibraryPicker : NSObject

@property (nonatomic, weak) id<SMImageLibraryPickerDelegate> delegate;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) BOOL allowEditing;
@property (nonatomic, assign) BOOL allowCameraEditing;
@property (nonatomic, assign) NSInteger maxCount;  // >1 multiple
@property (nonatomic, assign) CGSize thumbSize;
@property (nonatomic, assign) UIViewContentMode thumbMode;
@property (nonatomic, readonly) NSMutableArray *paths;

- (id)initWithDelegate:(id<SMImageLibraryPickerDelegate>)delegate;
- (void)executeInViewController:(UIViewController *)vc;
- (void)execute:(UIImagePickerControllerSourceType)sourceType inViewController:(UIViewController *)vc;

@end

@protocol SMImageLibraryPickerDelegate <NSObject>

@optional
- (void)imagePicker:(SMImageLibraryPicker *)picker successed:(NSArray *)thumbImages;
- (void)imagePickerFailed:(SMImageLibraryPicker *)picker;

@end