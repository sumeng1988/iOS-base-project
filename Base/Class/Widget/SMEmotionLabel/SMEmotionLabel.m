//
//  SMEmotionLabel.m
//  Base
//
//  Created by sumeng on 15/5/24.
//  Copyright (c) 2015年 sumeng. All rights reserved.
//

#import "SMEmotionLabel.h"
#import "SMEmotionInfo.h"

@interface SMEmotionLabel ()

@property (nonatomic, copy) NSString *emotionText;

@end

@implementation SMEmotionLabel

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initial];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initial];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self initial];
    }
    return self;
}

- (void)initial {
    self.numberOfLines = 1;
    
    [self setUserInteractionEnabled:YES];
    UILongPressGestureRecognizer *longGr = [[UILongPressGestureRecognizer alloc]
                                            initWithTarget:self action:@selector(handleLongPress:)];
    [self addGestureRecognizer:longGr];
}

- (void)setText:(NSString *)text {
    [super setText:@""];
    self.emotionText = text;
    
    NSString *str = text;
    if (str == nil) {
        str = @"";
    }
    NSString *pattern = [SMEmotionLabel buildPattern:[[SMEmotionInfo shared] all]];
    NSRegularExpression *regExp = [[NSRegularExpression alloc] initWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil];
    NSArray *matchs = [regExp matchesInString:str
                                      options:NSMatchingReportCompletion
                                        range:NSMakeRange(0, [str length])];
    NSInteger loc = 0;
    for (NSTextCheckingResult *match in matchs) {
        NSString *component = [str substringWithRange:NSMakeRange(loc, match.range.location-loc)];
        NSString *emotion = [str substringWithRange:match.range];
        loc = match.range.location + match.range.length;
        [self appendText:component];
        [self appendImage:[[SMEmotionInfo shared] imageForKey:emotion]
                  maxSize:CGSizeZero
                   margin:UIEdgeInsetsMake(0, 1, 0, 1)];
    }
    if (loc < str.length) {
        NSString *component = [str substringFromIndex:loc];
        [self appendText:component];
    }
}

- (NSString *)getText {
    return _emotionText;
}

#pragma mark - Clipboard

- (void)handleLongPress:(UIGestureRecognizer*)recognizer {
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        [self becomeFirstResponder];
        UIMenuController *menu = [UIMenuController sharedMenuController];
        [menu setTargetRect:self.frame inView:self.superview];
        [menu setMenuVisible:YES animated:YES];
    }
}

- (void)copy:(id)sender {
    UIPasteboard *pb = [UIPasteboard generalPasteboard];
    [pb setString:[self getText]];
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    return (action == @selector(copy:));
}

+ (NSString *)buildPattern:(NSArray *)keys {
    NSString *ret = @"(";
    for (int i = 0; i < keys.count; i++) {
        NSString *key = [NSRegularExpression escapedPatternForString:[keys objectAtIndex:i]];
        ret = [ret stringByAppendingString:key];
        if (i != keys.count - 1) {
            ret =[ret stringByAppendingString:@"|"];
        }
    }
    ret = [ret stringByAppendingString:@")"];
    return ret;
}

@end
