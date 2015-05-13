//
//  ImageUtils.m
//  Base
//
//  Created by sumeng on 15/5/13.
//  Copyright (c) 2015年 sumeng. All rights reserved.
//

#import "ImageUtils.h"

#define kImageUtilsLongImageScale 3.0f

@implementation ImageUtils

+ (BOOL)isLongImage:(CGSize)size {
    if (size.width == 0 || size.height == 0) {
        return NO;
    }
    return (size.width / size.height >= kImageUtilsLongImageScale
            || size.height / size.width >= kImageUtilsLongImageScale);
}

@end
