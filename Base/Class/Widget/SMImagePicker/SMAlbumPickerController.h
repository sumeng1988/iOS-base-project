//
//  SMAlbumPickerController.h
//  Base
//
//  Created by sumeng on 15/5/20.
//  Copyright (c) 2015年 sumeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMImagePickerController.h"

@interface SMAlbumPickerController : UITableViewController

@property (nonatomic, weak) SMImagePickerController *picker;

+ (void)savePickedGroup:(ALAssetsGroup *)group;

@end
