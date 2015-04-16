//
//  SMImageLibrary.m
//  Base
//
//  Created by sumeng on 4/16/15.
//  Copyright (c) 2015 sumeng. All rights reserved.
//

#import "SMImageLibrary.h"
#import "ELCImagePickerController.h"

@implementation SMImageLibrary

+ (void)save:(UIImage *)image {
    
}

@end

@interface SMImageLibraryPicker () <UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, ELCImagePickerControllerDelegate>

@property (nonatomic, weak) UIViewController *vc;

@end

@implementation SMImageLibraryPicker

- (id)init {
    return [self initWithDelegate:nil];
}

- (id)initWithDelegate:(id<SMImageLibraryPickerDelegate>)delegate {
    self = [super init];
    if (self) {
        self.title = @"选择照片";
        self.allowEditing = NO;
        self.maxCount = 1;
        self.thumbSize = CGSizeMake(100, 100);
        self.thumbMode = UIViewContentModeScaleAspectFit;
        _paths = [[NSMutableArray alloc] init];
        
        _delegate = delegate;
    }
    return self;
}

- (void)dealloc {
    [_paths removeAllObjects];
    [[FileSystem shared] removePicturesTemporaryFiles];
}

- (void)executeInViewController:(UIViewController *)vc {
    [Keyboard close];
    self.vc = vc;
    
    UIActionSheet* action = [[UIActionSheet alloc] initWithTitle:self.title
                                                        delegate:self
                                               cancelButtonTitle:@"取消"
                                          destructiveButtonTitle:nil
                                               otherButtonTitles:@"拍照", @"从相册中选择", nil];
    [action showInView:vc.view];
}

- (void)execute:(UIImagePickerControllerSourceType)sourceType inViewController:(UIViewController *)vc {
    if (sourceType == UIImagePickerControllerSourceTypeCamera || (sourceType == UIImagePickerControllerSourceTypePhotoLibrary && _allowEditing) || _maxCount <= 1)
    {
        if ([UIImagePickerController isSourceTypeAvailable:sourceType]) {
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.sourceType = sourceType;
            imagePicker.delegate = self;
            imagePicker.allowsEditing = _allowEditing;
            if (sourceType == UIImagePickerControllerSourceTypeCamera && _allowCameraEditing) {
                imagePicker.allowsEditing = YES;
            }
            imagePicker.modalPresentationStyle = UIModalPresentationFormSheet;
            [_vc presentViewController:imagePicker animated:YES completion:nil];
        }
    }
    else {
        ELCImagePickerController *picker = [[ELCImagePickerController alloc] initImagePicker];
        picker.maximumImagesCount = _maxCount;
        picker.returnsImage = YES;
        picker.onOrder = YES;
        picker.imagePickerDelegate = self;
        picker.returnsOriginalImage = YES;
        [_vc presentViewController:picker animated:YES completion:nil];
    }
}

- (UIImage *)resizeImage:(UIImage *)image {
//    // 最大边不超过1136
//    CGFloat max = 11360;
//    CGFloat scalex = image.size.width/max;
//    CGFloat scaley = image.size.height/max;
//    if (scalex > 1.0 || scaley > 1.0) {
//        CGSize size;
//        if (scalex > scaley) {
//            size.width = max;
//            size.height = image.size.height*max/image.size.width;
//        }else {
//            size.height = max;
//            size.width = image.size.width*max/image.size.height;
//        }
//        image = [image resize:size contentMode:_thumbMode];
//    }
//    return image;
    
    CGFloat width = 1080;
    CGFloat height = 11360;
    if (image.size.width > width || image.size.height > height) {
        CGSize size;
        if (image.size.height > height) {
            size.height = height;
            size.width = image.size.width*height/image.size.height;
        }
        if (image.size.width > width) {
            size.width = width;
            size.height = image.size.height*width/image.size.width;
        }
        image = [image resize:size contentMode:_thumbMode];
    }
    return image;
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == actionSheet.cancelButtonIndex) {
        return;
    }
    
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if (buttonIndex == 1) {
        sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    [self execute:sourceType inViewController:_vc];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = nil;
    if (picker.allowsEditing) {
        image = [info objectForKey:UIImagePickerControllerEditedImage];
    }
    else {
        image = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    image = [self resizeImage:image];
    
    [_paths removeAllObjects];
    [_paths addObject:[[FileSystem shared].picturesTemporary stringByAppendingString:@".jpg"]];
    [UIImageJPEGRepresentation(image, 0.7) writeToFile:_paths.firstObject atomically:YES];
    image = [image resize:_thumbSize contentMode:_thumbMode];
    
    [picker dismissViewControllerAnimated:YES completion:^{
        if (_delegate && [_delegate respondsToSelector:@selector(imagePicker:successed:)]) {
            [_delegate imagePicker:self successed:@[image]];
        }
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^{
        if (_delegate && [_delegate respondsToSelector:@selector(imagePickerFailed:)]) {
            [_delegate imagePickerFailed:self];
        }
    }];
}

#pragma mark - ELCImagePickerControllerDelegate

- (void)elcImagePickerController:(ELCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info
{
    [SMHud showProgress];
    NSMutableArray *images = [[NSMutableArray alloc] initWithCapacity:info.count];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [_paths removeAllObjects];
        for (NSDictionary *dict in info) {
            UIImage *image = [dict objectForKey:UIImagePickerControllerOriginalImage];
            image = [self resizeImage:image];
            
            [_paths addObject:[[FileSystem shared].picturesTemporary stringByAppendingString:@".jpg"]];
            [UIImageJPEGRepresentation(image, 0.7) writeToFile:_paths.lastObject atomically:YES];
            image = [image resize:_thumbSize contentMode:_thumbMode];
            [images addObject:image];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [SMHud hideProgress];
            [picker dismissViewControllerAnimated:YES completion:^{
                if (_delegate && [_delegate respondsToSelector:@selector(imagePicker:successed:)]) {
                    [_delegate imagePicker:self successed:images];
                }
            }];
        });
    });
}

- (void)elcImagePickerControllerDidCancel:(ELCImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^{
        if (_delegate && [_delegate respondsToSelector:@selector(imagePickerFailed:)]) {
            [_delegate imagePickerFailed:self];
        }
    }];
}

@end
