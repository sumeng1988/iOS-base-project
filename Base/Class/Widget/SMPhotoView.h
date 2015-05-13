//
//  SMPhotoView.h
//  Base
//
//  Created by sumeng on 15/5/12.
//  Copyright (c) 2015年 sumeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SMPhotoViewDelegate;

@interface SMPhotoView : UIScrollView

@property (nonatomic, strong) UIImage *placeholderImage;
@property (nonatomic, strong) id imageDataSource;
@property (nonatomic, assign) id<SMPhotoViewDelegate> tagDelegate;

@property (nonatomic, assign) BOOL fillScreenWhenLongPhoto;

- (UIImage *)image;
- (CGRect)imageFrame;

@end

@protocol SMPhotoViewDelegate <NSObject>

@optional

- (void)photoViewOnSingleTap:(SMPhotoView *)photoView;
- (void)photoViewOnLongPress:(SMPhotoView *)photoView;

@end