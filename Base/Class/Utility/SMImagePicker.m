//
//  SMImageLibrary.m
//  Base
//
//  Created by sumeng on 4/16/15.
//  Copyright (c) 2015 sumeng. All rights reserved.
//

#import "SMImagePicker.h"
#import "ELCImagePickerController.h"

#define kImagePickerDir @"ImagePicker/"

@interface SMImagePicker () <UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, ELCImagePickerControllerDelegate>

@property (nonatomic, weak) UIViewController *vc;

@end

@implementation SMImagePicker

- (id)init {
    return [self initWithDelegate:nil];
}

- (id)initWithDelegate:(id<SMImagePickerDelegate>)delegate {
    self = [super init];
    if (self) {
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
    [[FileSystem shared] remove:[self cacheDir]];
}

#pragma mark - public

- (void)executeInViewController:(UIViewController *)vc {
    [Keyboard close];
    self.vc = vc;
    
    UIActionSheet* action = [[UIActionSheet alloc] initWithTitle:@"选择照片"
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
            imagePicker.modalPresentationStyle = UIModalPresentationFormSheet;
            [vc presentViewController:imagePicker animated:YES completion:nil];
        }
        else {
            [SMHud text:@"inavailable"];
        }
    }
    else {
        ELCImagePickerController *picker = [[ELCImagePickerController alloc] initImagePicker];
        picker.maximumImagesCount = _maxCount;
        picker.returnsImage = YES;
        picker.onOrder = YES;
        picker.imagePickerDelegate = self;
        picker.returnsOriginalImage = YES;
        [vc presentViewController:picker animated:YES completion:nil];
    }
}

#pragma mark - private

- (NSString *)cacheDir {
    return [[FileSystem shared].tmpDir stringByAppendingString:kImagePickerDir];
}

- (NSString *)temporary {
    return [[[FileSystem shared] temporary:[self cacheDir]] stringByAppendingString:@".jpg"];
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == actionSheet.cancelButtonIndex) {
        return;
    }
    
    UIImagePickerControllerSourceType sourceType = (buttonIndex == 1 ? UIImagePickerControllerSourceTypePhotoLibrary : UIImagePickerControllerSourceTypeCamera);
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
    
    [_paths removeAllObjects];
    [_paths addObject:[self temporary]];
    [UIImageJPEGRepresentation(image, 0.7) writeToFile:_paths.firstObject atomically:YES];
    
    NSArray *thumbImages = nil;
    UIImage *thumbImage = [image resize:_thumbSize contentMode:_thumbMode];
    if (thumbImage != nil) {
        thumbImages = @[thumbImage];
    }
    
    [picker dismissViewControllerAnimated:YES completion:^{
        if (_delegate && [_delegate respondsToSelector:@selector(imagePicker:successed:)]) {
            [_delegate imagePicker:self successed:thumbImages];
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
            
            [_paths addObject:[self temporary]];
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
