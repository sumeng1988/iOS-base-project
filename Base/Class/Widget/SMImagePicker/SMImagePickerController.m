//
//  SMImagePickerController.m
//  Base
//
//  Created by sumeng on 15/5/20.
//  Copyright (c) 2015年 sumeng. All rights reserved.
//

#import "SMImagePickerController.h"
#import "SMAlbumPickerController.h"

@implementation SMImagePickerController

- (instancetype)init {
    SMAlbumPickerController *vc = [[SMAlbumPickerController alloc] initWithStyle:UITableViewStylePlain];
    self = [self initWithRootViewController:vc];
    if (self) {
        vc.picker = self;
    }
    return self;
}

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController {
    self = [super initWithRootViewController:rootViewController];
    if (self) {
        self.maximumNumberOfSelection = 9;
        self.assetsFilter = [ALAssetsFilter allPhotos];
    }
    return self;
}

- (void)cancelImagePicker {
    if ([_imagePickerDelegate respondsToSelector:@selector(smImagePickerControllerDidCancel:)]) {
        [_imagePickerDelegate smImagePickerControllerDidCancel:self];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)finishPick:(NSArray *)assets group:(ALAssetsGroup *)group {
    [SMAlbumPickerController savePickedGroup:group];
    if ([_imagePickerDelegate respondsToSelector:@selector(smImagePickerController:didFinishPickingMediaWithAssets:)]) {
        [_imagePickerDelegate smImagePickerController:self didFinishPickingMediaWithAssets:assets];
    }
    else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

@end
