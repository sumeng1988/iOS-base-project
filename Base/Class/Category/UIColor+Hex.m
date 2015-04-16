//
//  UIColor+Hex.m
//  Base
//
//  Created by sumeng on 4/16/15.
//  Copyright (c) 2015 sumeng. All rights reserved.
//

#import "UIColor+Hex.h"

@implementation UIColor (Hex)

+ (UIColor *)colorWithRGB:(int)rgb {
    return [self colorWithRed:RGB2FLOAT(RGB_RED(rgb)) green:RGB2FLOAT(RGB_GREEN(rgb)) blue:RGB2FLOAT(RGB_BLUE(rgb)) alpha:1.0f];
}

+ (UIColor *)colorWithRGBA:(int)rgba {
    return [self colorWithRed:RGB2FLOAT(RGBA_RED(rgba)) green:RGB2FLOAT(RGBA_GREEN(rgba)) blue:RGB2FLOAT(RGBA_BLUE(rgba)) alpha:RGB2FLOAT(RGBA_ALPHA(rgba))];
}

+ (UIColor *)colorWithARGB:(int)argb {
    return [self colorWithRed:RGB2FLOAT(ARGB_RED(argb)) green:RGB2FLOAT(ARGB_GREEN(argb)) blue:RGB2FLOAT(ARGB_BLUE(argb)) alpha:RGB2FLOAT(ARGB_ALPHA(argb))];
}

@end
