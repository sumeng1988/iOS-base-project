//
//  UIView+ViewController.m
//  Base
//
//  Created by sumeng on 5/5/15.
//  Copyright (c) 2015 sumeng. All rights reserved.
//

#import "UIView+ViewController.h"

@implementation UIView (ViewController)

- (UIViewController *)viewController {
    UIResponder *responder = self.nextResponder;
    while (responder != nil && ![responder isKindOfClass:[UIViewController class]])
    {
        responder = responder.nextResponder;
    }
    return (UIViewController *)responder;
}

@end
