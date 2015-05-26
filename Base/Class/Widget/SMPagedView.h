//
//  SMPagedView.h
//  Base
//
//  Created by sumeng on 15/5/26.
//  Copyright (c) 2015年 sumeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMPagedView : UIView

@property (nonatomic, strong) NSArray *pages;  //UIView
@property (nonatomic, assign) NSInteger index;  //current index of page
@property (nonatomic, assign) BOOL autoSwitching;  //default NO
@property (nonatomic, assign) NSTimeInterval interval;  //auto switching interval

@end
