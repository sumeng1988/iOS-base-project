//
//  UIImage+Effects.m
//  Base
//
//  Created by sumeng on 15/5/24.
//  Copyright (c) 2015年 sumeng. All rights reserved.
//

#import "UIImage+Effects.h"
#import <GPUImage/GPUImage.h>

@implementation UIImage (Effects)

+ (UIImage *)stretchImage:(NSString *)name {
    UIImage *image = [self imageNamed:name];
    UIEdgeInsets capInsets = UIEdgeInsetsMake(image.size.height * 0.5f,
                                              image.size.width * 0.5f,
                                              image.size.height * 0.5f,
                                              image.size.width * 0.5f);
    return [image resizableImageWithCapInsets:capInsets];
}

+ (UIImage *)stretchImage:(NSString *)name capInsets:(UIEdgeInsets)capInsets {
    UIImage *image = [self imageNamed:name];
    return [image resizableImageWithCapInsets:capInsets];
}

- (UIImage *)resize:(CGSize)size {
    return [self resize:size contentMode:UIViewContentModeScaleToFill];
}

- (UIImage *)resize:(CGSize)size contentMode:(UIViewContentMode)mode {
    if (size.width > 0 && size.height > 0) {
        CGRect rect = CGRectMake(0, 0, size.width, size.height);
        switch (mode) {
            case UIViewContentModeScaleAspectFit: {
                if ((self.size.width/self.size.height) >= (size.width/size.height)) {
                    rect.size.height = size.width*self.size.height/self.size.width;
                    rect.origin.y = (size.height-rect.size.height)/2;
                }
                else {
                    rect.size.width = size.height*self.size.width/self.size.height;
                    rect.origin.x = (size.width-rect.size.width)/2;
                }
                break;
            }
            case UIViewContentModeScaleAspectFill: {
                if ((self.size.width/self.size.height) >= (size.width/size.height)) {
                    rect.size.width = size.height*self.size.width/self.size.height;
                    rect.origin.x = (size.width-rect.size.width)/2;
                }
                else {
                    rect.size.height = size.width*self.size.height/self.size.width;
                    rect.origin.y = (size.height-rect.size.height)/2;
                }
                break;
            }
            default:
                break;
        }
        
        UIGraphicsBeginImageContext(size);
        [self drawInRect:rect];
        UIImage *dstImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return dstImage;
    }
    return nil;
}

- (UIImage *)blur {
    CGSize blurSize = CGSizeMake(self.size.width/4, self.size.height/4);
    return [[self resize:blurSize] blur:2.0f];
}

- (UIImage *)blur:(CGFloat)radius {
    GPUImageGaussianBlurFilter *blurFilter = [[GPUImageGaussianBlurFilter alloc] init];
    blurFilter.blurRadiusInPixels = radius;
    return [blurFilter imageByFilteringImage:self];
}

@end
