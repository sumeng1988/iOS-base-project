//
//  UIImage+Stretch.m
//  Base
//
//  Created by sumeng on 4/16/15.
//  Copyright (c) 2015 sumeng. All rights reserved.
//

#import "UIImage+Stretch.h"

@implementation UIImage (Stretch)

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

@end
