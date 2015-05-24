//
//  SMEmotionInfo.m
//  Base
//
//  Created by sumeng on 5/5/15.
//  Copyright (c) 2015 sumeng. All rights reserved.
//

#import "SMEmotionInfo.h"

@interface SMEmotionInfo ()

@property (nonatomic, strong) NSMutableArray *names;
@property (nonatomic, strong) NSMutableArray *images;

@end

@implementation SMEmotionInfo

SHARED_IMPL

- (instancetype)init {
    self = [super init];
    if (self) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"emotions"
                                                         ofType:@"plist"];
        NSArray *datas = [NSArray arrayWithContentsOfFile:path];
        _names = [[NSMutableArray alloc] initWithCapacity:datas.count];
        _images = [[NSMutableArray alloc] initWithCapacity:datas.count];
        for (NSDictionary *dict in datas) {
            [_names addObject:[dict objectForKey:@"name"]];
            [_images addObject:[dict objectForKey:@"image"]];
        }
    }
    return self;
}

- (NSArray *)all {
    return _names;
}

- (UIImage *)imageForKey:(NSString *)key {
    for (int i = 0; i < _names.count; i++) {
        NSString *name = [_names objectAtIndex:i];
        if ([name isEqualToString:key]) {
            NSString *image = [_images objectAtIndex:i];
            if (image.notEmpty) {
                return [UIImage imageNamed:image];
            }
            break;
        }
    }
    return nil;
}

@end

@implementation NSString (emotion)

- (NSRange)endOfEmotion {
    NSRange range = NSMakeRange(0, 0);
    if (!self.notEmpty) {
        return range;
    }
    if ([@"]" isEqualToString:[self substringFromIndex:self.length-1]]) {
        NSRange r = [self rangeOfString:@"[" options:NSBackwardsSearch];
        if (r.length > 0) {
            NSString *emotion = [self substringFromIndex:r.location];
            for (NSString *str in [[SMEmotionInfo shared] all]) {
                if ([str isEqualToString:emotion]) {
                    return NSMakeRange(r.location, emotion.length);
                }
            }
        }
    }
    return range;
}

@end
