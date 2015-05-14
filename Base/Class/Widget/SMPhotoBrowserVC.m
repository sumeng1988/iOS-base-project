//
//  SMPhotoBrowserVC.m
//  Base
//
//  Created by sumeng on 5/11/15.
//  Copyright (c) 2015 sumeng. All rights reserved.
//

#import "SMPhotoBrowserVC.h"
#import "SMPhotoView.h"
#import "SDWebImageManager.h"
#import "ImageUtils.h"

#define kPhotoViewInvalidTag -1

@interface SMPhotoBrowserVC () <UIScrollViewDelegate, SMPhotoViewDelegate> {
    BOOL _statusBarHidden;
    BOOL _isLeave;
}

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageCtrl;
@property (nonatomic, strong) NSMutableArray *photoViewPool;

@end

@implementation SMPhotoBrowserVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _fillScreenWhenLongPhoto = YES;
    _photoViewPool = [[NSMutableArray alloc] initWithCapacity:3];
    
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        _isLeave = NO;
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    }
    else {
        _statusBarHidden = [UIApplication sharedApplication].statusBarHidden;
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    }
    
    _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    _scrollView.delegate = self;
    _scrollView.pagingEnabled = YES;
    _scrollView.alwaysBounceHorizontal = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _scrollView.contentSize = CGSizeMake(_scrollView.width * _imageDataSources.count, _scrollView.contentSize.height);
    _scrollView.contentOffset = CGPointMake(_scrollView.width * _index, 0);
    [self.view addSubview:_scrollView];
    
    _pageCtrl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.view.height - 21, self.view.width, 21)];
    _pageCtrl.hidesForSinglePage = YES;
    _pageCtrl.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    _pageCtrl.numberOfPages = _imageDataSources.count;
    [self.view addSubview:_pageCtrl];
    
    [self photoViewPoolUpdate:_index];
}

- (BOOL)prefersStatusBarHidden {
    return _isLeave ? [self presentingViewControllerPrefersStatusBarHidden] : YES;
}

#pragma mark - public

- (void)show {
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    if (window.rootViewController) {
        [window.rootViewController addChildViewController:self];
        [window addSubview:self.view];
    }
    
    UIImageView *srcView = [self srcView:_index];
    CGRect frame = [[srcView superview] convertRect:srcView.frame toView:window];
    UIImageView *translateView = [[UIImageView alloc] initWithFrame:frame];
    translateView.contentMode = UIViewContentModeScaleAspectFill;
    translateView.clipsToBounds = YES;
    [window addSubview:translateView];
    
    UIImage *image = nil;
    if (_index >= 0 && _index < _imageDataSources.count) {
        image = [self imageFromDataSource:_imageDataSources[_index]];
    }
    if (image == nil) {
        image = srcView.image;
    }
    translateView.image = image;
    
    _scrollView.hidden = YES;
    [UIView animateWithDuration:0.25f
                     animations:^{
                         translateView.size = [self defaultSize:translateView.image.size];
                         if (!_fillScreenWhenLongPhoto
                             || ![ImageUtils isLongImage:translateView.image.size])
                         {
                             translateView.center = CGPointMake(window.width/2, window.height/2);
                         }
                         else {
                             translateView.leftTop = CGPointZero;
                         }
                     }
                     completion:^(BOOL finished) {
                         [translateView removeFromSuperview];
                         _scrollView.hidden = NO;
                     }];
}

- (void)setIndex:(NSInteger)index {
    _index = index;
    _pageCtrl.currentPage = index;
}

#pragma mark - private

- (void)hide {
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    
    SMPhotoView *photoView = [self photoViewWithIndex:_index];
    CGRect fromFrame = [photoView convertRect:photoView.imageFrame toView:window];
    
    UIImageView *srcView = [self srcView:_index];
    CGRect toFrame = [[srcView superview] convertRect:srcView.frame toView:window];
    
    UIImageView *translateView = [[UIImageView alloc] initWithFrame:fromFrame];
    translateView.contentMode = srcView.contentMode;
    translateView.clipsToBounds = YES;
    [window addSubview:translateView];
    
    UIImage *image = srcView.image;
    if (image == nil) {
        image = [photoView image];
    }
    translateView.image = image;
    
    _scrollView.hidden = YES;
    [UIView animateWithDuration:0.25f
                     animations:^{
                         self.view.alpha = 0;
                         translateView.frame = toFrame;
                     } completion:^(BOOL finished) {
                         [translateView removeFromSuperview];
                         [self.view removeFromSuperview];
                         [self removeFromParentViewController];
                     }];
    
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        _isLeave = YES;
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    }
    else {
        [[UIApplication sharedApplication] setStatusBarHidden:_statusBarHidden withAnimation:UIStatusBarAnimationFade];
    }
}

- (UIImageView *)srcView:(NSInteger)index {
    if (index >= 0 && index < _srcViews.count) {
        id obj = _srcViews[index];
        if ([obj isKindOfClass:[UIImageView class]]) {
            return obj;
        }
        else if ([obj isKindOfClass:[UIView class]]) {
            return [[UIImageView alloc] initWithFrame:((UIView *)obj).frame];
        }
    }
    return nil;
}

- (BOOL)presentingViewControllerPrefersStatusBarHidden {
    UIViewController *presenting = self.presentingViewController;
    if (presenting) {
        if ([presenting isKindOfClass:[UINavigationController class]]) {
            presenting = [(UINavigationController *)presenting topViewController];
        }
    } else {
        // We're in a navigation controller so get previous one!
        if (self.navigationController && self.navigationController.viewControllers.count > 1) {
            presenting = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-2];
        }
    }
    if (presenting) {
        return [presenting prefersStatusBarHidden];
    } else {
        return NO;
    }
}

- (CGSize)defaultSize:(CGSize)size {
    if (size.width == 0 || size.height == 0) {
        return self.view.size;
    }
    CGSize defaultSize;
    if (size.height/size.width >= self.view.height/self.view.width) {
        if (!_fillScreenWhenLongPhoto || ![ImageUtils isLongImage:size]) {
            defaultSize.width = size.width/size.height*self.view.height;
            defaultSize.height = self.view.height;
        }
        else {
            defaultSize.width = self.view.width;
            defaultSize.height = size.height/size.width*self.view.width;
        }
    }
    else {
        if (!_fillScreenWhenLongPhoto || ![ImageUtils isLongImage:size]) {
            defaultSize.width = self.view.width;
            defaultSize.height = size.height/size.width*self.view.width;
        }
        else {
            defaultSize.width = size.width/size.height*self.view.height;
            defaultSize.height = self.view.height;
        }
    }
    return defaultSize;
}

- (UIImage *)imageFromDataSource:(id)imageDataSource {
    if ([imageDataSource isKindOfClass:[UIImage class]]) {
        return imageDataSource;
    }
    else if ([imageDataSource isKindOfClass:[NSString class]]) {
        if ([[FileSystem shared] existsFile:imageDataSource]) {
            return [UIImage imageWithContentsOfFile:imageDataSource];
        }
    }
    else if ([imageDataSource isKindOfClass:[NSURL class]]) {
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        if ([manager cachedImageExistsForURL:imageDataSource]) {
            NSString *key = [manager cacheKeyForURL:imageDataSource];
            return [manager.imageCache imageFromDiskCacheForKey:key];
        }
    }
    return nil;
}

- (NSInteger)currentIndex:(UIScrollView *)scrollView {
    CGRect visibleBounds = scrollView.bounds;
    NSInteger index = (NSInteger)(floorf(CGRectGetMidX(visibleBounds) / CGRectGetWidth(visibleBounds)));
    if (index < 0) {
        index = 0;
    }
    if (index >= _imageDataSources.count) {
        index = _imageDataSources.count - 1;
    }
    return index;
}

#pragma mark - Layout

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    [self layoutPhotoViews];
}

- (void)layoutPhotoViews {
    _scrollView.contentSize = CGSizeMake(_scrollView.width * _imageDataSources.count, _scrollView.contentSize.height);
    _scrollView.contentOffset =CGPointMake(_scrollView.width * _index, 0);
    
    for (SMPhotoView *photoView in _photoViewPool) {
        if (photoView.tag != kPhotoViewInvalidTag) {
            photoView.frame = CGRectMake(_scrollView.width * photoView.tag, 0, _scrollView.width, _scrollView.height);
            photoView.zoomScale = photoView.minimumZoomScale;
        }
    }
}

#pragma mark - SMPhotoView Pool

- (void)photoViewPoolUpdate:(NSInteger)currentIndex {
    //clean pool
    for (SMPhotoView *photoView in _photoViewPool) {
        NSInteger tag = photoView.tag;
        if (tag != kPhotoViewInvalidTag && (tag < currentIndex - 1 || tag > currentIndex + 1)) {
            photoView.tag = kPhotoViewInvalidTag;
            [photoView clear];
            [photoView removeFromSuperview];
        }
    }
    //update current
    [self photoViewWithIndex:currentIndex];
    //update prev
    if (currentIndex - 1 >= 0) {
        [self photoViewWithIndex:currentIndex - 1];
    }
    //update next
    if (currentIndex + 1 < _imageDataSources.count) {
        [self photoViewWithIndex:currentIndex + 1];
    }
}

- (SMPhotoView *)photoViewWithIndex:(NSInteger)index {
    if (index < 0 || index >= _imageDataSources.count) {
        return nil;
    }
    
    for (SMPhotoView *photoView in _photoViewPool) {
        if (photoView.tag == index) {
            return photoView;
        }
    }
    SMPhotoView *photoView = [self dequeueReusablePhotoView];
    if (photoView == nil) {
        photoView = [[SMPhotoView alloc] init];
        [_photoViewPool addObject:photoView];
    }
    photoView.tag = index;
    photoView.frame = CGRectMake(_scrollView.width * index, 0, _scrollView.width, _scrollView.height);
    photoView.tagDelegate = self;
    photoView.fillScreenWhenLongPhoto = _fillScreenWhenLongPhoto;
    photoView.placeholderImage = [self srcView:index].image;
    photoView.imageDataSource = _imageDataSources[index];
    [_scrollView addSubview:photoView];
    return photoView;
}

- (SMPhotoView *)dequeueReusablePhotoView {
    for (SMPhotoView *photoView in _photoViewPool) {
        if (photoView.tag == kPhotoViewInvalidTag) {
            return photoView;
        }
    }
    return nil;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.index = [self currentIndex:scrollView];
    [self photoViewPoolUpdate:_index];
}

#pragma mark - SMPhotoViewDelegate

- (void)photoViewOnSingleTap:(SMPhotoView *)photoView {
    [self hide];
}

- (void)photoViewOnLongPress:(SMPhotoView *)photoView {
    
}

@end
