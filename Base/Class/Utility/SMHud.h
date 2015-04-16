//
//  SMHud.h
//  Base
//
//  Created by sumeng on 4/16/15.
//  Copyright (c) 2015 sumeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMHud : NSObject

+ (void)text:(NSString *)text inView:(UIView*) view;
+ (void)text:(NSString*)text;
+ (void)text:(NSString*)text title:(NSString*)title;
+ (void)showProgressInView:(UIView *)view;
+ (void)showProgress;
+ (void)hideProgress;

@end
