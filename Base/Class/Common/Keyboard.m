//
//  Keyboard.m
//  Base
//
//  Created by sumeng on 4/16/15.
//  Copyright (c) 2015 sumeng. All rights reserved.
//

#import "Keyboard.h"

@implementation Keyboard

SHARED_IMPL

+ (void)close {
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

- (id)init {
    self = [super init];
    if (self) {
        _visible = NO;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(kbShowing:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(kbHiding:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)kbShowing:(NSNotification *)info {
    _visible = YES;
}

- (void)kbHiding:(NSNotification *)info {
    _visible = NO;
}

@end
