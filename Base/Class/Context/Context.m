//
//  Context.m
//  Base
//
//  Created by sumeng on 4/16/15.
//  Copyright (c) 2015 sumeng. All rights reserved.
//

#import "Context.h"

#define kCrontabInterval (60)

@interface Context ()

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation Context

SHARED_IMPL

- (id)init {
    self = [super init];
    if (self) {
        _device = [[Device alloc] init];
        _app = [[App alloc] init];
    }
    return self;
}

- (void)startCrontab {
    [self stopCrontab];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:kCrontabInterval
                                     target:self
                                   selector:@selector(postCrontab)
                                   userInfo:nil
                                    repeats:YES];
}

- (void)stopCrontab {
    if (_timer != nil) {
        [_timer invalidate];
        self.timer = nil;
    }
}

- (void)postCrontab {
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationCrontab object:nil];
}

@end
