//
//  SMExtentionPanel.h
//  Base
//
//  Created by sumeng on 5/5/15.
//  Copyright (c) 2015 sumeng. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kSMExtentionPanelHeight 185

typedef enum _SMExtentionPanelEvent{
    SMExtentionPanelEventGallery = 0,
    SMExtentionPanelEventCamera,
    
    SMExtentionPanelEventTotal
}SMExtentionPanelEvent;

@interface SMExtentionPanel : UIView

- (void)addTarget:(id)target action:(SEL)action forEvent:(SMExtentionPanelEvent)event;

@end

