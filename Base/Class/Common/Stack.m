//
//  Stack.m
//  Base
//
//  Created by sumeng on 15/5/12.
//  Copyright (c) 2015年 sumeng. All rights reserved.
//

#import "Stack.h"

@interface Stack ()

@property (nonatomic, strong) NSMutableArray *data;

@end

@implementation Stack

- (instancetype)init {
    self = [super init];
    if (self) {
        _data = [[NSMutableArray alloc] init];
    }
    return self;
}

- (BOOL)empty {
    return _data.count == 0;
}

- (void)pop {
    [_data removeLastObject];
}

- (void)push:(id)obj {
    [_data addObject:obj];
}

- (NSUInteger)size {
    return _data.count;
}

- (id)top {
    return [_data lastObject];
}


@end
