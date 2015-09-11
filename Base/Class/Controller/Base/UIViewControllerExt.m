//
//  UIViewControllerExt.m
//  Base
//
//  Created by sumeng on 4/16/15.
//  Copyright (c) 2015 sumeng. All rights reserved.
//

#import "UIViewControllerExt.h"

@interface UIViewControllerExt () <UIActionSheetDelegate>

@property (nonatomic, assign) BOOL isFirstWillAppear;
@property (nonatomic, assign) BOOL isFirstDidAppear;

@end

@implementation UIViewControllerExt

- (id)init {
    self = [super init];
    if (self) {
        _isFirstWillAppear = YES;
        _isFirstDidAppear = YES;
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"%@ viewDidLoad", NSStringFromClass([self class]));
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (_isFirstWillAppear) {
        [self viewWillFirstAppear];
        _isFirstWillAppear = NO;
    }
    else {
        [self viewWillOtherAppear];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (_isFirstDidAppear) {
        [self viewDidFirstAppear];
        _isFirstDidAppear = NO;
    }
    else {
        [self viewDidOtherAppear];
    }
}

- (void)dealloc {
    NSLog(@"%@ dealloc", NSStringFromClass([self class]));
}

#pragma mark - public

- (void)viewWillFirstAppear {
    
}

- (void)viewDidFirstAppear {
    
}

- (void)viewWillOtherAppear {
    
}

- (void)viewDidOtherAppear {
    
}

@end
