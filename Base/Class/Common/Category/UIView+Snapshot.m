//
//  UIView+Snapshot.m
//  Base
//
//  Created by sumeng on 15/5/24.
//  Copyright (c) 2015年 sumeng. All rights reserved.
//

#import "UIView+Snapshot.h"

@implementation UIView (Snapshot)

- (UIImage *)snapshot {
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, [UIScreen mainScreen].scale);
    
    if ([UIDevice currentDevice].systemVersion.floatValue >= 7.0) {
        [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:NO];
    }
    else {
        [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    }

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
