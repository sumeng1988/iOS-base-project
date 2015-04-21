//
//  UIImage+Stretch.h
//  Base
//
//  Created by sumeng on 4/16/15.
//  Copyright (c) 2015 sumeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIImage (Stretch)

+ (UIImage *)stretchImage:(NSString *)name;
+ (UIImage *)stretchImage:(NSString *)name capInsets:(UIEdgeInsets)capInsets;

@end
