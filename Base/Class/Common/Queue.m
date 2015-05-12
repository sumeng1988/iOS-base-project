//
//  Queue.m
//  Base
//
//  Created by sumeng on 15/5/12.
//  Copyright (c) 2015年 sumeng. All rights reserved.
//

#import "Queue.h"

@interface Queue ()

@property (nonatomic, strong) NSMutableArray *data;

@end

@implementation Queue

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
    if (_data.count > 0) {
        [_data removeObjectAtIndex:0];
    }
}

- (void)push:(id)obj {
    [_data addObject:obj];
}

- (NSUInteger)size {
    return _data.count;
}

- (id)front {
    if (_data.count > 0) {
        return [_data objectAtIndex:0];
    }
    return nil;
}

- (id)back {
    return [_data lastObject];
}

@end
