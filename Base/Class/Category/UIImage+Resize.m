//
//  UIImage+Resize.m
//  Base
//
//  Created by sumeng on 4/16/15.
//  Copyright (c) 2015 sumeng. All rights reserved.
//

#import "UIImage+Resize.h"

@implementation UIImage (Resize)

- (UIImage *)resize:(CGSize)size contentMode:(UIViewContentMode)mode {
    if (size.width > 0 && size.height > 0) {
        CGRect rect = CGRectZero;
        switch (mode) {
            case UIViewContentModeScaleAspectFit: {
                if ((self.size.width/self.size.height) >= (size.width/size.height)) {
                    rect.size.height = size.width*self.size.height/self.size.width;
                    rect.size.width = size.width;
                    rect.origin.y = (size.height-rect.size.height)/2;
                }
                else {
                    rect.size.width = size.height*self.size.width/self.size.height;
                    rect.size.height = size.height;
                    rect.origin.x = (size.width-rect.size.width)/2;
                }
                break;
            }
            case UIViewContentModeScaleAspectFill: {
                if ((self.size.width/self.size.height) >= (size.width/size.height)) {
                    rect.size.width = size.height*self.size.width/self.size.height;
                    rect.size.height = size.height;
                    rect.origin.x = (size.width-rect.size.width)/2;
                }
                else {
                    rect.size.height = size.width*self.size.height/self.size.width;
                    rect.size.width = size.width;
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

@end
