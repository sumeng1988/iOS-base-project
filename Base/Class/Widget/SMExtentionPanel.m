//
//  SMExtentionPanel.m
//  Base
//
//  Created by sumeng on 5/5/15.
//  Copyright (c) 2015 sumeng. All rights reserved.
//

#import "SMExtentionPanel.h"

@interface SMExtentionPanel ()

@property (nonatomic, strong) UIButton *galleryBtn;
@property (nonatomic, strong) UIButton *cameraBtn;

@end

@implementation SMExtentionPanel

- (instancetype)init {
    return [self initWithFrame:CGRectMake(0, 0, kUIScreenSize.width, kSMExtentionPanelHeight)];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)initView {
    CGFloat margin = (self.width-60*4)/5;
    CGFloat x = margin;
    CGFloat y = 15;
    
    _galleryBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_galleryBtn setImage:[UIImage imageNamed:@"inputbar_gallery"] forState:UIControlStateNormal];
    [_galleryBtn sizeToFit];
    _galleryBtn.leftTop = CGPointMake(x, y);
    _galleryBtn.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    [self addSubview:_galleryBtn];
    x += 60 + margin;
    
    _cameraBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_cameraBtn setImage:[UIImage imageNamed:@"inputbar_camera"] forState:UIControlStateNormal];
    [_cameraBtn sizeToFit];
    _cameraBtn.leftTop = CGPointMake(x, y);
    _cameraBtn.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    [self addSubview:_cameraBtn];
    x += 60 + margin;
}

#pragma mark - publick

- (void)addTarget:(id)target action:(SEL)action forEvent:(SMExtentionPanelEvent)event
{
    switch (event) {
        case SMExtentionPanelEventGallery:
            [_galleryBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
            break;
        case SMExtentionPanelEventCamera:
            [_cameraBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
            break;
        default:
            break;
    }
}

@end
