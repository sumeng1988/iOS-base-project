//
//  Base.h
//  Base
//
//  Created by sumeng on 4/16/15.
//  Copyright (c) 2015 sumeng. All rights reserved.
//

#import "AppDelegate.h"
#import "Compiler.h"
#import "FileSystem.h"
#import "HardwareInfo.h"
#import "Keyboard.h"
#import "Category.h"
#import "Swizzle.h"
#import "Context.h"

#import "SMHud.h"
#import "SMImagePicker.h"

extern BOOL kUIScreenIsRetina;
extern CGSize kUIScreenSize;
extern CGFloat kUIScreenScale;

#define kNotificationCrontab @"NotificationCrontab"

#define RGB_RED(val) (((val) & 0xff0000) >> 16)
#define RGB_GREEN(val) (((val) & 0xff00) >> 8)
#define RGB_BLUE(val) ((val) & 0xff)
#define RGB_VALUE(r, g, b) (((r & 0xff) << 16) | ((g & 0xff) << 8) | (b & 0xff))

#define ARGB_ALPHA(val) (((val) & 0xff000000) >> 24)
#define ARGB_RED RGB_RED
#define ARGB_GREEN RGB_GREEN
#define ARGB_BLUE RGB_BLUE

#define RGBA_ALPHA(val) ((val) & 0xff)
#define RGBA_RED(val) (((val) & 0xff000000) >> 24)
#define RGBA_GREEN(val) (((val) & 0xff0000) >> 16)
#define RGBA_BLUE(val) (((val) & 0xff00) >> 8)

#define RGB2FLOAT(val) ((val) / 255.0f)
#define FLOAT2RGB(val) ((val) * 255)

#define RGBA(r,g,b,a) [UIColor colorWithRed:(r/255.0f) green:(g/255.0f) blue:(b/255.0f) alpha:(a)]
#define RGB(r,g,b) RGBA(r,g,b,1.0f)
#define RGB3(r) RGB(r,r,r)
#define RGB3A(r,a) RGBA(r,r,r,a)