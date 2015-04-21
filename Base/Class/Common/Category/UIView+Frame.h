//
//  UIView+Frame.h
//  Base
//
//  Created by sumeng on 4/16/15.
//  Copyright (c) 2015 sumeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIView (Frame)

@property (nonatomic, assign) CGPoint leftTop;
@property (nonatomic, assign) CGPoint leftCenter;
@property (nonatomic, assign) CGPoint leftBottom;
@property (nonatomic, assign) CGPoint rightTop;
@property (nonatomic, assign) CGPoint rightCenter;
@property (nonatomic, assign) CGPoint rightBottom;
@property (nonatomic, assign) CGPoint topCenter;
@property (nonatomic, assign) CGPoint bottomCenter;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;

@end
