//
//  SMAssetPickerController.h
//  Base
//
//  Created by sumeng on 15/5/20.
//  Copyright (c) 2015年 sumeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "SMImagePickerController.h"

@interface SMAssetPickerController : UIViewController

@property (nonatomic, weak) SMImagePickerController *picker;
@property (nonatomic, strong) ALAssetsGroup *group;

@end
