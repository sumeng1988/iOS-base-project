//
//  SMImagePickerController.h
//  Base
//
//  Created by sumeng on 15/5/20.
//  Copyright (c) 2015年 sumeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@protocol SMImagePickerControllerDelegate;

@interface SMImagePickerController : UINavigationController

@property(nonatomic, weak) id<SMImagePickerControllerDelegate> imagePickerDelegate;

@property (nonatomic, strong) ALAssetsFilter *assetsFilter;

@property (nonatomic, strong) NSArray *selectedAssets;

@property (nonatomic, assign) NSInteger maximumNumberOfSelection;

- (void)cancelImagePicker;
- (void)finishPick:(NSArray *)assets group:(ALAssetsGroup *)group;

@end

@protocol SMImagePickerControllerDelegate <NSObject>

@optional

- (void)smImagePickerController:(SMImagePickerController *)picker didFinishPickingMediaWithAssets:(NSArray *)asset;

- (void)smImagePickerControllerDidCancel:(SMImagePickerController *)picker;

@end