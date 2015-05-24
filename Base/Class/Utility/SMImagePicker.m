//
//  SMImageLibrary.m
//  Base
//
//  Created by sumeng on 4/16/15.
//  Copyright (c) 2015 sumeng. All rights reserved.
//

#import "SMImagePicker.h"
#import "ELCImagePickerController.h"
#import <objc/runtime.h>

#define kImagePickerDir @"ImagePicker"

@interface SMImagePicker () <UINavigationControllerDelegate, UIImagePickerControllerDelegate, ELCImagePickerControllerDelegate>

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
        self.thumbSize = CGSizeMake(150, 150);
        self.thumbMode = UIViewContentModeScaleAspectFit;
        _paths = [[NSMutableArray alloc] init];
        
        _delegate = delegate;
    }
    return self;
}

#pragma mark - Public

static void *__s_image_picker_key;

- (void)execute:(UIImagePickerControllerSourceType)sourceType inViewController:(UIViewController *)vc {
    if (sourceType == UIImagePickerControllerSourceTypeCamera) {
        if ([UIImagePickerController isSourceTypeAvailable:sourceType]) {
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.sourceType = sourceType;
            picker.delegate = self;
            picker.allowsEditing = _allowEditing;
            [vc presentViewController:picker animated:YES completion:nil];
            
            objc_setAssociatedObject(picker, &__s_image_picker_key, self, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
        else {
            [SMHud text:@"camera inavailable"];
        }
    }
    else {
        if ([UIImagePickerController isSourceTypeAvailable:sourceType]) {
            if (_maxCount == 1 && _allowEditing) {
                UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                picker.sourceType = sourceType;
                picker.delegate = self;
                picker.allowsEditing = _allowEditing;
                [vc presentViewController:picker animated:YES completion:nil];
                
                objc_setAssociatedObject(picker, &__s_image_picker_key, self, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }
            else {
                ELCImagePickerController *picker = [[ELCImagePickerController alloc] initImagePicker];
                picker.maximumImagesCount = _maxCount;
                picker.returnsImage = YES;
                picker.onOrder = YES;
                picker.imagePickerDelegate = self;
                picker.returnsOriginalImage = YES;
                [vc presentViewController:picker animated:YES completion:nil];
                
                objc_setAssociatedObject(picker, &__s_image_picker_key, self, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }
        }
        else {
            [SMHud text:@"gallery inavailable"];
        }
    }
}

+ (void)clearCacheFiles {
    [[FileSystem shared] remove:[self cacheDir]];
}

#pragma mark - Private

+ (NSString *)cacheDir {
    return [[FileSystem shared].tmpDir stringByAppendingPathComponent:kImagePickerDir];
}

- (NSString *)temporary {
    NSString *dir = [SMImagePicker cacheDir];
    if (_saveDir.notEmpty) {
        dir = _saveDir;
    }
    return [[[FileSystem shared] temporary:dir] stringByAppendingPathExtension:@"jpg"];
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
    
    if (_delegate && [_delegate respondsToSelector:@selector(imagePicker:successed:)]) {
        [_delegate imagePicker:self successed:thumbImages];
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    if (_delegate && [_delegate respondsToSelector:@selector(imagePickerFailed:)]) {
        [_delegate imagePickerFailed:self];
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - ELCImagePickerControllerDelegate

- (void)elcImagePickerController:(ELCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info {
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
            if (_delegate && [_delegate respondsToSelector:@selector(imagePicker:successed:)]) {
                [_delegate imagePicker:self successed:images];
            }
            [picker dismissViewControllerAnimated:YES completion:nil];
        });
    });
}

- (void)elcImagePickerControllerDidCancel:(ELCImagePickerController *)picker {
    if (_delegate && [_delegate respondsToSelector:@selector(imagePickerFailed:)]) {
        [_delegate imagePickerFailed:self];
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
