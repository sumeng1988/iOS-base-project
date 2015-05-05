//
//  SMInputBar.h
//  Base
//
//  Created by sumeng on 5/5/15.
//  Copyright (c) 2015 sumeng. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kInputBarHeightDefault 44
#define kInputBarHeightMax 100

typedef enum _SMInputBarStatus {
    SMInputBarStatusNone = 0,
    SMInputBarStatusKeyboard,
    SMInputBarStatusEmotion,
    SMInputBarStatusExtantion,
    
    SMInputBarStatusTotal
}SMInputBarStatus;

@protocol SMInputBarDelegate;

@interface SMInputBar : UIView

@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSString *placeholder;
@property (nonatomic, weak) id<SMInputBarDelegate> delegate;
@property (nonatomic, assign) SMInputBarStatus status;

@end

@protocol SMInputBarDelegate <NSObject>

@optional

- (void)inputBar:(SMInputBar *)bar sendText:(NSString *)text;

- (void)inputBar:(SMInputBar *)bar sendImages:(NSArray *)paths;

- (void)inputBar:(SMInputBar *)bar willChangeFrame:(CGRect)frame withDuration:(NSTimeInterval)duration;

- (void)inputBar:(SMInputBar *)bar didChangeFrame:(CGRect)frame;

@end