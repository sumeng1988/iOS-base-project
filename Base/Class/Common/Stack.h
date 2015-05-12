//
//  Stack.h
//  Base
//
//  Created by sumeng on 15/5/12.
//  Copyright (c) 2015年 sumeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Stack : NSObject

- (BOOL)empty;
- (void)pop;
- (void)push:(id)obj;
- (NSUInteger)size;
- (id)top;

@end
