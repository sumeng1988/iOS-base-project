//
//  Compiler.h
//  Base
//
//  Created by sumeng on 4/16/15.
//  Copyright (c) 2015 sumeng. All rights reserved.
//

#import <Foundation/Foundation.h>

#if defined(__OBJC__) || defined(__OBJC2__)
    #define OBJC_MODE
#endif

#if defined(DEBUG)
    #define DEBUG_MODE
#endif

#ifdef DEBUG_MODE
    #define LOG(format, ...) NSLog(format, ## __VA_ARGS__)
#else
    #define LOG(format, ...)
#endif

// 类似于 i++ 的后操作
#define ATOMIC_INC(x, v) __sync_fetch_and_add(&x, v)
# define ATOMIC_DEC(x, v) __sync_fetch_and_sub(&x, v)

// 类似于 ++i 的前操作
#define ATOMIC_ADD(x, v) __sync_add_and_fetch(&x, v)
#define ATOMIC_SUB(x, v) __sync_sub_and_fetch(&x, v)


#define SHARED_DECL \
+ (instancetype)shared;

#define SHARED_IMPL \
+ (instancetype)shared { \
static id obj = nil; \
@synchronized(self) { \
if (obj == nil) { \
obj = [[self alloc] init]; \
} \
} \
return obj; }

// color console
#define XCODE_COLORS_ESCAPE @"\033["
#define XCODE_COLORS_RESET  @"\033[;" // Clear any foreground or background color
#define XCODE_COLORS_RESET_FG @"fg;" // Clear any foreground color
#define XCODE_COLORS_RESET_BG @"bg;" // Clear any background color

#define XCODE_COLORS_FG_RGB(r,g,b) [NSString stringWithFormat:@"fg%d,%d,%d;",r,g,b]

#define LogRed(frmt, ...) LOG((XCODE_COLORS_ESCAPE @"fg255,0,0;" frmt XCODE_COLORS_RESET), ##__VA_ARGS__)
#define LogGreen(frmt, ...) LOG((XCODE_COLORS_ESCAPE @"fg0,255,0;" frmt XCODE_COLORS_RESET), ##__VA_ARGS__)