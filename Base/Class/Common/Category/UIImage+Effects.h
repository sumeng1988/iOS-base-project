//
//  UIImage+Effects.h
//  Base
//
//  Created by sumeng on 15/5/24.
//  Copyright (c) 2015年 sumeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Effects)

+ (UIImage *)stretchImage:(NSString *)name;
+ (UIImage *)stretchImage:(NSString *)name capInsets:(UIEdgeInsets)capInsets;

- (UIImage *)resize:(CGSize)size;
- (UIImage *)resize:(CGSize)size contentMode:(UIViewContentMode)mode;

- (UIImage *)blur;
- (UIImage *)blur:(CGFloat)radius;

@end
