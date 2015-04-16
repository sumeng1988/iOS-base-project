//
//  UIImage+Resize.h
//  Base
//
//  Created by sumeng on 4/16/15.
//  Copyright (c) 2015 sumeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIImage (Resize)

- (UIImage *)resize:(CGSize)size contentMode:(UIViewContentMode)mode;

@end
