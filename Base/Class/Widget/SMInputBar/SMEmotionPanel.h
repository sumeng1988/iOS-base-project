//
//  SMEmotionPanel.h
//  Base
//
//  Created by sumeng on 5/5/15.
//  Copyright (c) 2015 sumeng. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kSMEmotionPageColumn 4
#define kSMEmotionPageRow 2
#define kSMEmotionItemWidth 50
#define kSMEmotionItemHeight 68
#define kSMEmotionItemLineSpacing 6

#define kSMEmotionPageHeight ((kSMEmotionItemHeight+kSMEmotionItemLineSpacing)*kSMEmotionPageRow+kSMEmotionItemLineSpacing)
#define kSMEmotionPanelHeight (kSMEmotionPageHeight+20+38)

@protocol SMEmotionPanelDelegate;

@interface SMEmotionPanel : UIView

@property (nonatomic, weak) id<SMEmotionPanelDelegate> delegate;

@end

@protocol SMEmotionPanelDelegate <NSObject>

@optional

- (void)emotionPanel:(SMEmotionPanel *)panel pickEmotion:(NSString *)emotion;
- (void)emotionPanelDelete:(SMEmotionPanel *)panel;
- (void)emotionPanelSend:(SMEmotionPanel *)panel;

@end
