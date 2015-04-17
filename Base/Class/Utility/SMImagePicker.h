//
//  SMImagePicker.h
//  Base
//
//  Created by sumeng on 4/16/15.
//  Copyright (c) 2015 sumeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SMImagePickerDelegate;

@interface SMImagePicker : NSObject

@property (nonatomic, weak) id<SMImagePickerDelegate> delegate;
@property (nonatomic, assign) BOOL allowEditing;
@property (nonatomic, assign) NSInteger maxCount;  // >1 multiple
@property (nonatomic, assign) CGSize thumbSize;
@property (nonatomic, assign) UIViewContentMode thumbMode;
@property (nonatomic, readonly) NSMutableArray *paths;

- (id)initWithDelegate:(id<SMImagePickerDelegate>)delegate;
- (void)executeInViewController:(UIViewController *)vc;
- (void)execute:(UIImagePickerControllerSourceType)sourceType inViewController:(UIViewController *)vc;

@end

@protocol SMImagePickerDelegate <NSObject>

@optional
- (void)imagePicker:(SMImagePicker *)picker successed:(NSArray *)thumbImages;
- (void)imagePickerFailed:(SMImagePicker *)picker;

@end