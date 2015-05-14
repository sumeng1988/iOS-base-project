//
//  SMPhotoView.m
//  Base
//
//  Created by sumeng on 15/5/12.
//  Copyright (c) 2015年 sumeng. All rights reserved.
//

#import "SMPhotoView.h"
#import "UIImageView+WebCache.h"
#import "ImageUtils.h"

@interface SMPhotoView () <UIScrollViewDelegate> {
    CGPoint zoomCenter;
}

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation SMPhotoView

- (instancetype)init {
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)initView {
    self.userInteractionEnabled = YES;
    self.backgroundColor = [UIColor clearColor];
    self.bouncesZoom = YES;
    self.delegate = self;
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    self.minimumZoomScale = 1.0f;
    self.maximumZoomScale = 1.0f;
    
    _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    _imageView.clipsToBounds = YES;
    [self addSubview:_imageView];
    
    UILongPressGestureRecognizer *longGr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    [self addGestureRecognizer:longGr];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    NSUInteger tapCount = touch.tapCount;
    switch (tapCount) {
        case 1:
            [self performSelector:@selector(handleSingleTap:)
                       withObject:touch
                       afterDelay:0.2f];
            break;
        case 2:
            [NSObject cancelPreviousPerformRequestsWithTarget:self];
            [self handleDoubleTap:touch];
            break;
        default:
            break;
    }
    [[self nextResponder] touchesEnded:touches withEvent:event];
}

#pragma mark - public

- (void)setPlaceholderImage:(UIImage *)placeholderImage {
    _placeholderImage = placeholderImage;
    if (_imageView.image == nil) {
        [_imageView setImage:placeholderImage];
    }
}

- (void)setImageDataSource:(id)imageDataSource {
    if (_imageDataSource == imageDataSource) {
        return;
    }
    _imageDataSource = imageDataSource;
    if ([imageDataSource isKindOfClass:[UIImage class]]) {
        [self __setImage:imageDataSource];
    }
    else if ([imageDataSource isKindOfClass:[NSString class]]) {
        if ([[FileSystem shared] existsFile:imageDataSource]) {
            [self __setImage:[UIImage imageWithContentsOfFile:imageDataSource]];
        }
    }
    else if ([imageDataSource isKindOfClass:[NSURL class]]) {
        [self __setImageWithURL:imageDataSource];
    }
    else {
        [self __setImage:_placeholderImage];
    }
}

- (UIImage *)image {
    return _imageView.image;
}

- (CGRect)imageFrame {
    return _imageView.frame;
}

- (void)clear {
    self.contentOffset = CGPointZero;
    self.minimumZoomScale = 1.0f;
    self.maximumZoomScale = 1.0f;
    self.zoomScale = self.minimumZoomScale;
    self.placeholderImage = nil;
    self.imageDataSource = nil;
}

#pragma mark - private

- (void)__setImageWithURL:(NSURL *)url {
    [_imageView sd_setImageWithURL:url
                  placeholderImage:_placeholderImage
                           options:0
                          progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                              
                          } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                              [self __setImage:image];
                          }];
}

- (void)__setImage:(UIImage *)image {
    if (image == nil) {
        return;
    }
    _imageView.image = image;
    _imageView.size = [self defaultSize:image.size];
    if (!_fillScreenWhenLongPhoto || ![ImageUtils isLongImage:image.size]) {
        _imageView.center = CGPointMake(self.width/2, self.height/2);
    }
    else {
        _imageView.leftTop = CGPointZero;
    }
    
    if (!_fillScreenWhenLongPhoto || ![ImageUtils isLongImage:image.size]) {
        if (_imageView.width < self.width/2) {
            self.maximumZoomScale = self.width / _imageView.width;
        }
        else if (_imageView.height < self.height/2) {
            self.maximumZoomScale = self.height / _imageView.height;
        }
        else {
            self.maximumZoomScale = 2.0f;
        }
    }
    else {
        self.maximumZoomScale = 2.0f;
    }
    self.zoomScale = self.minimumZoomScale;
}

- (CGSize)defaultSize:(CGSize)size {
    if (size.width == 0 || size.height == 0) {
        return self.size;
    }
    CGSize defaultSize;
    if (size.height/size.width >= self.height/self.width) {
        if (!_fillScreenWhenLongPhoto || ![ImageUtils isLongImage:size]) {
            defaultSize.width = size.width/size.height*self.height;
            defaultSize.height = self.height;
        }
        else {
            defaultSize.width = self.width;
            defaultSize.height = size.height/size.width*self.width;
        }
    }
    else {
        if (!_fillScreenWhenLongPhoto || ![ImageUtils isLongImage:size]) {
            defaultSize.width = self.width;
            defaultSize.height = size.height/size.width*self.width;
        }
        else {
            defaultSize.width = size.width/size.height*self.height;
            defaultSize.height = self.height;
        }
    }
    return defaultSize;
}

#pragma mark - TapHandle

- (void)handleSingleTap:(UITouch *)touch {
    if (_tagDelegate && [_tagDelegate respondsToSelector:@selector(photoViewOnSingleTap:)])
    {
        [_tagDelegate photoViewOnSingleTap:self];
    }
}

- (void)handleDoubleTap:(UITouch *)touch {
    if (self.zoomScale != self.minimumZoomScale) {
        [self setZoomScale:self.minimumZoomScale animated:YES];
    }
    else {
        CGPoint point = [touch locationInView:_imageView];
        [self zoomToRect:CGRectMake(point.x, point.y, 1, 1) animated:YES];
    }
}

- (void)handleLongPress:(UILongPressGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateBegan) {
        if (_tagDelegate && [_tagDelegate respondsToSelector:@selector(photoViewOnLongPress:)])
        {
            [_tagDelegate photoViewOnLongPress:self];
        }
    }
}


#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return _imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    CGSize boundsSize = scrollView.bounds.size;
    CGSize contentSize = scrollView.contentSize;
    CGRect imgFrame = _imageView.frame;
    
    CGPoint centerPoint = CGPointMake(contentSize.width/2, contentSize.height/2);
    
    // center horizontally
    if (imgFrame.size.width <= boundsSize.width)
    {
        centerPoint.x = boundsSize.width/2;
    }
    
    // center vertically
    if (imgFrame.size.height <= boundsSize.height)
    {
        centerPoint.y = boundsSize.height/2;
    }
    
    _imageView.center = centerPoint;
}

@end
