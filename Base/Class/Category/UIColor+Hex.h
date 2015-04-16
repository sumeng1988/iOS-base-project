//
//  UIColor+Hex.h
//  Base
//
//  Created by sumeng on 4/16/15.
//  Copyright (c) 2015 sumeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIColor (Hex)

+ (UIColor *)colorWithRGB:(int)rgb;
+ (UIColor *)colorWithRGBA:(int)rgba;
+ (UIColor *)colorWithARGB:(int)argb;

@end
