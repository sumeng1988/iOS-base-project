//
//  SMImageView.m
//  Base
//
//  Created by sumeng on 5/11/15.
//  Copyright (c) 2015 sumeng. All rights reserved.
//

#import "SMImageView.h"
#import "UIImageView+WebCache.h"
#import <AssetsLibrary/AssetsLibrary.h>

@implementation SMImageView

- (instancetype)init {
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

- (instancetype)initWithImage:(UIImage *)image {
    self = [super initWithImage:image];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)initView {
    self.clipsToBounds = YES;
}

#pragma mark - public

- (void)setPlaceholderImage:(UIImage *)placeholderImage {
    _placeholderImage = placeholderImage;
    if (self.image == nil) {
        self.image = placeholderImage;
    }
}

- (void)setImageDataSource:(id)imageDataSource {
    if (_imageDataSource == imageDataSource) {
        return;
    }
    _imageDataSource = imageDataSource;
    if ([imageDataSource isKindOfClass:[UIImage class]]) {
        self.image = imageDataSource;
    }
    else if ([imageDataSource isKindOfClass:[NSString class]]) {
        if ([[FileSystem shared] existsFile:imageDataSource]) {
            self.image = [UIImage imageWithContentsOfFile:imageDataSource];
        }
    }
    else if ([imageDataSource isKindOfClass:[NSURL class]]) {
        [self __setImageWithURL:imageDataSource];
    }
    else if ([imageDataSource isKindOfClass:[ALAsset class]]) {
        ALAsset *asset = imageDataSource;
        ALAssetRepresentation *rep = [asset defaultRepresentation];
        CGImageRef ref = [rep fullScreenImage];
        if (ref) {
            self.image = [UIImage imageWithCGImage:ref];
        }
        else {
            self.image = _placeholderImage;
        }
    }
    else {
        self.image = _placeholderImage;
    }
}

#pragma mark - private

- (void)__setImageWithURL:(NSURL *)url {
    [self sd_setImageWithURL:url
            placeholderImage:_placeholderImage
                     options:0
                    progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                        
                    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                        self.image = image;
                    }];
}

@end
