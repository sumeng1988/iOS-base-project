//
//  SMEmotionInfo.m
//  Base
//
//  Created by sumeng on 5/5/15.
//  Copyright (c) 2015 sumeng. All rights reserved.
//

#import "EmotionInfo.h"

@interface EmotionInfo ()

@property (nonatomic, strong) NSMutableArray *names;
@property (nonatomic, strong) NSMutableArray *images;

@end

@implementation EmotionInfo

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


- (NSAttributedString *)attributedString:(NSString *)text {
    NSString *pattern = [[self class] buildPattern:[self all]];
    NSRegularExpression *regExp = [[NSRegularExpression alloc] initWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil];
    NSArray *matchs = [regExp matchesInString:text
                                      options:NSMatchingReportCompletion
                                        range:NSMakeRange(0, [text length])];
    NSInteger loc = 0;
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] init];
    for (NSTextCheckingResult *match in matchs) {
        NSString *component = [text substringWithRange:NSMakeRange(loc, match.range.location-loc)];
        [str appendAttributedString:[[NSAttributedString alloc] initWithString:component]];
        
        NSString *emotion = [text substringWithRange:match.range];
        loc = match.range.location + match.range.length;
        
        NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
        attachment.image = [self imageForKey:emotion];
        [str appendAttributedString:[NSAttributedString attributedStringWithAttachment:attachment]];
    }
    if (loc < text.length) {
        NSString *component = [text substringFromIndex:loc];
        [str appendAttributedString:[[NSAttributedString alloc] initWithString:component]];
    }
    return str;
}

+ (NSString *)buildPattern:(NSArray *)keys {
    NSString *ret = @"(";
    for (int i = 0; i < keys.count; i++) {
        NSString *emotion = [keys objectAtIndex:i];
        NSString *key = [NSRegularExpression escapedPatternForString:emotion];
        ret = [ret stringByAppendingString:key];
        if (i != keys.count - 1) {
            ret =[ret stringByAppendingString:@"|"];
        }
    }
    ret = [ret stringByAppendingString:@")"];
    return ret;
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
            for (NSString *str in [[EmotionInfo shared] all]) {
                if ([str isEqualToString:emotion]) {
                    return NSMakeRange(r.location, emotion.length);
                }
            }
        }
    }
    return range;
}

@end
