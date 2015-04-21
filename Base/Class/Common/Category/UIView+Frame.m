//
//  UIView+Frame.m
//  Base
//
//  Created by sumeng on 4/16/15.
//  Copyright (c) 2015 sumeng. All rights reserved.
//

#import "UIView+Frame.h"

@implementation UIView (Frame)

- (void)setLeftTop:(CGPoint)pt {
    CGRect rc = self.frame;
    if (CGPointEqualToPoint(rc.origin, pt))
        return;
    rc.origin = pt;
    self.frame = rc;
}

- (CGPoint)leftTop {
    return self.frame.origin;
}

- (void)setLeftCenter:(CGPoint)pt {
    pt.y -= self.bounds.size.height * .5f;
    [self setLeftTop:pt];
}

- (CGPoint)leftCenter {
    CGPoint pt = self.leftTop;
    pt.y += self.bounds.size.height * .5f;
    return pt;
}

- (void)setLeftBottom:(CGPoint)pt {
    CGRect rc = self.frame;
    rc.origin.x = pt.x;
    rc.origin.y = pt.y - rc.size.height;
    self.frame = rc;
}

- (CGPoint)leftBottom {
    CGPoint pt = self.frame.origin;
    pt.y += self.frame.size.height;
    return pt;
}

- (void)setRightTop:(CGPoint)pt {
    CGRect rc = self.frame;
    rc.origin.x = pt.x - rc.size.width;
    rc.origin.y = pt.y;
    self.frame = rc;
}

- (CGPoint)rightTop {
    CGPoint pt = self.frame.origin;
    pt.x += self.frame.size.width;
    return pt;
}

- (void)setRightCenter:(CGPoint)pt {
    pt.y -= self.bounds.size.height * .5f;
    [self setRightTop:pt];
}

- (CGPoint)rightCenter {
    CGPoint pt = self.rightTop;
    pt.y += self.bounds.size.height * .5f;
    return pt;
}

- (void)setRightBottom:(CGPoint)pt {
    CGRect rc = self.frame;
    rc.origin.x = pt.x - rc.size.width;
    rc.origin.y = pt.y - rc.size.height;
    self.frame = rc;
}

- (CGPoint)rightBottom {
    CGPoint pt = self.frame.origin;
    pt.x += self.frame.size.width;
    pt.y += self.frame.size.height;
    return pt;
}

- (void)setTopCenter:(CGPoint)pt {
    pt.x -= self.bounds.size.width * .5f;
    [self setLeftTop:pt];
}

- (CGPoint)topCenter {
    CGPoint pt = self.leftTop;
    pt.x += self.bounds.size.width * .5f;
    return pt;
}

- (void)setBottomCenter:(CGPoint)pt {
    pt.x -= self.bounds.size.width * .5f;
    [self setLeftBottom:pt];
}

- (CGPoint)bottomCenter {
    CGPoint pt = self.leftBottom;
    pt.x += self.bounds.size.width * .5f;
    return pt;
}

- (void)setSize:(CGSize)sz {
    CGRect r = self.frame;
    r.size = sz;
    self.frame = r;
}

- (CGSize)size {
    return self.frame.size;
}

- (void)setX:(CGFloat)x {
    CGRect r = self.frame;
    r.origin.x = x;
    self.frame = r;
}

- (CGFloat)x {
    return self.frame.origin.x;
}

- (void)setY:(CGFloat)y {
    CGRect r = self.frame;
    r.origin.y = y;
    self.frame = r;
}

- (CGFloat)y {
    return self.frame.origin.y;
}

- (void)setWidth:(CGFloat)width {
    CGRect r = self.frame;
    r.size.width = width;
    self.frame = r;
}

- (CGFloat)width {
    return self.frame.size.width;
}

- (void)setHeight:(CGFloat)height {
    CGRect r = self.frame;
    r.size.height = height;
    self.frame = r;
}

- (CGFloat)height {
    return self.frame.size.height;
}

@end
