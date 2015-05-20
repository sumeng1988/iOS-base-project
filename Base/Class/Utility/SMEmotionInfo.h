//
//  SMEmotionInfo.h
//  Base
//
//  Created by sumeng on 5/5/15.
//  Copyright (c) 2015 sumeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMEmotionInfo : NSObject

SHARED_DECL

- (NSArray *)all;
- (UIImage *)imageForKey:(NSString *)key;

@end

@interface NSString (emotion)

- (NSRange)endOfEmotion;

@end