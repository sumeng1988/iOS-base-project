//
//  SMImageLibrary.m
//  Base
//
//  Created by sumeng on 4/16/15.
//  Copyright (c) 2015 sumeng. All rights reserved.
//

#import "SMImagePicker.h"
#import "SMImagePickerController.h"
#import "ImageUtils.h"
#import <objc/runtime.h>

#define kImagePickerDir @"ImagePicker"
#define kImagePickerResizeMaxSlide 1280
#define kImagePickerResizeLongImageMinSlide 640

@interface SMImagePicker () <UINavigationControllerDelegate, UIImagePickerControllerDelegate, SMImagePickerControllerDelegate>

@end

@implementation SMImagePicker

- (id)init {
    return [self initWithDelegate:nil];
}

- (id)initWithDelegate:(id<SMImagePickerDelegate>)delegate {
    self = [super init];
    if (self) {
        self.allowEditing = NO;
        self.maximumNumberOfSelection = 9;
        self.thumbSize = CGSizeMake(150, 150);
        self.thumbMode = UIViewContentModeScaleAspectFill;
        
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
            if (_maximumNumberOfSelection == 1 && _allowEditing) {
                UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                picker.sourceType = sourceType;
                picker.delegate = self;
                picker.allowsEditing = _allowEditing;
                [vc presentViewController:picker animated:YES completion:nil];
                
                objc_setAssociatedObject(picker, &__s_image_picker_key, self, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }
            else {
                SMImagePickerController *picker = [[SMImagePickerController alloc] init];
                picker.imagePickerDelegate = self;
                picker.maximumNumberOfSelection = _maximumNumberOfSelection;
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

#pragma mark - Resize

+ (CGSize)bestSize:(CGSize)size {
    if (size.width == 0 || size.height == 0) {
        return size;
    }
    CGSize bs = CGSizeMake(size.width, size.height);
    if ([ImageUtils isLongImage:size]) {
        if (size.width >= size.height
            && size.height > kImagePickerResizeLongImageMinSlide)
        {
            bs.height = kImagePickerResizeLongImageMinSlide;
            bs.width = size.width / size.height * kImagePickerResizeLongImageMinSlide;
        }
        else if (size.height >= size.width
                 && size.width > kImagePickerResizeLongImageMinSlide)
        {
            bs.width = kImagePickerResizeLongImageMinSlide;
            bs.height = size.height / size.width * kImagePickerResizeLongImageMinSlide;
        }
    }
    else {
        if (size.width >= size.height
            && size.width > kImagePickerResizeMaxSlide)
        {
            bs.width = kImagePickerResizeMaxSlide;
            bs.height = size.height / size.width * kImagePickerResizeMaxSlide;
        }
        else if (size.height >= size.width
                 && size.height > kImagePickerResizeMaxSlide)
        {
            bs.height = kImagePickerResizeMaxSlide;
            bs.width = size.width / size.height * kImagePickerResizeMaxSlide;
        }
    }
    return bs;
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [SMHud showProgress];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *image = nil;
        if (picker.allowsEditing) {
            image = [info objectForKey:UIImagePickerControllerEditedImage];
        }
        else {
            image = [info objectForKey:UIImagePickerControllerOriginalImage];
        }
        
        CGSize size = [SMImagePicker bestSize:image.size];
        if (!CGSizeEqualToSize(size, image.size)) {
            image = [image resize:size contentMode:UIViewContentModeScaleAspectFit];
        }
        
        NSString *path = [self temporary];
        [UIImageJPEGRepresentation(image, 0.7) writeToFile:path atomically:YES];
        
        UIImage *thumbImage = [image resize:_thumbSize contentMode:_thumbMode];
        
        NSDictionary *info;
        if (thumbImage) {
            info = @{kImagePickerPath:path,
                     kImagePickerThumbImage:thumbImage};
        }
        else {
            info = @{kImagePickerPath:path};
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [SMHud hideProgress];
            if (_delegate && [_delegate respondsToSelector:@selector(imagePicker:didFinishPickingWithInfos:)]) {
                [_delegate imagePicker:self didFinishPickingWithInfos:@[info]];
            }
            [picker dismissViewControllerAnimated:YES completion:nil];
        });
    });
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    if (_delegate && [_delegate respondsToSelector:@selector(imagePickerDidCancel:)]) {
        [_delegate imagePickerDidCancel:self];
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - SMImagePickerControllerDelegate

- (void)smImagePickerController:(SMImagePickerController *)picker didFinishPickingMediaWithAssets:(NSArray *)assets {
    if (assets.count == 0) {
        if (_delegate && [_delegate respondsToSelector:@selector(imagePickerDidCancel:)]) {
            [_delegate imagePickerDidCancel:self];
        }
        [picker dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    
    [SMHud showProgress];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableArray *infos = [[NSMutableArray alloc] initWithCapacity:assets.count];
        for (ALAsset *asset in assets) {
            @autoreleasepool {
                ALAssetRepresentation *assetRep = [asset defaultRepresentation];
                if (assetRep != nil) {
                    UIImage *image = [UIImage imageWithCGImage:[assetRep fullScreenImage]];
                    if ([ImageUtils isLongImage:image.size]) {
                        UIImageOrientation orientation = (UIImageOrientation)[assetRep orientation];
                        image = [UIImage imageWithCGImage:[assetRep fullResolutionImage]
                                                  scale:1.0f
                                            orientation:orientation];
                    }
                    
                    CGSize size = [SMImagePicker bestSize:image.size];
                    if (!CGSizeEqualToSize(size, image.size)) {
                        image = [image resize:size contentMode:UIViewContentModeScaleAspectFit];
                    }
                    
                    NSString *path = [self temporary];
                    [UIImageJPEGRepresentation(image, 0.7) writeToFile:path atomically:YES];
                    
                    UIImage *thumbImage = nil;
                    if (_thumbMode == UIViewContentModeScaleAspectFill) {
                        thumbImage = [UIImage imageWithCGImage:[asset thumbnail]];
                    }
                    else {
                        thumbImage = [image resize:_thumbSize contentMode:_thumbMode];
                    }
                    
                    if (thumbImage) {
                        [infos addObject:@{kImagePickerPath:path,
                                           kImagePickerThumbImage:thumbImage,
                                           kImagePickerAsset:asset}];
                    }
                    else {
                        [infos addObject:@{kImagePickerPath:path,
                                           kImagePickerAsset:asset}];
                    }
                }
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [SMHud hideProgress];
            if (_delegate && [_delegate respondsToSelector:@selector(imagePicker:didFinishPickingWithInfos:)]) {
                [_delegate imagePicker:self didFinishPickingWithInfos:infos];
            }
            [picker dismissViewControllerAnimated:YES completion:nil];
        });
    });
}

- (void)smImagePickerControllerDidCancel:(SMImagePickerController *)picker {
    if (_delegate && [_delegate respondsToSelector:@selector(imagePickerDidCancel:)]) {
        [_delegate imagePickerDidCancel:self];
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
