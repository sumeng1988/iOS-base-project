//
//  SMPhotoBrowserVC.m
//  Base
//
//  Created by sumeng on 5/11/15.
//  Copyright (c) 2015 sumeng. All rights reserved.
//

#import "SMPhotoBrowserVC.h"
#import "SMPhotoView.h"
#import "SDWebImageDownloader.h"
#import "SDWebImageManager.h"

@interface SMPhotoBrowserVC () <UIScrollViewDelegate, SMPhotoViewDelegate> {
    BOOL _statusBarHidden;
    BOOL _isLeave;
}

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageCtrl;
@property (nonatomic, strong) NSMutableArray *photoViews;

@end

@implementation SMPhotoBrowserVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
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
    [self.view addSubview:_scrollView];
    
    _pageCtrl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.view.height - 21, self.view.width, 21)];
    _pageCtrl.hidesForSinglePage = YES;
    _pageCtrl.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    [self.view addSubview:_pageCtrl];
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
    
    NSUInteger count = _imageDataSources.count;
    
    _pageCtrl.numberOfPages = count;
    _pageCtrl.currentPage = _index;
    
    _scrollView.contentSize = CGSizeMake(_scrollView.width * count, _scrollView.contentSize.height);
    _scrollView.contentOffset = CGPointMake(_scrollView.width * _index, 0);
    
    self.photoViews = [[NSMutableArray alloc] initWithCapacity:count];
    for (int i = 0; i < count; i++) {
        SMPhotoView *photoView = [[SMPhotoView alloc] initWithFrame:CGRectMake(_scrollView.width * i, 0, _scrollView.width, _scrollView.height)];
        photoView.tagDelegate = self;
        UIImageView *srcView = [self srcView:i];
        photoView.placeholderImage = srcView.image;
        photoView.imageDataSource = _imageDataSources[i];
        [_scrollView addSubview:photoView];
        [_photoViews addObject:photoView];
    }
    
    UIImageView *srcView = [self srcView:_index];
    CGRect frame = [[srcView superview] convertRect:srcView.frame toView:window];
    UIImageView *translateView = [[UIImageView alloc] initWithFrame:frame];
    translateView.contentMode = UIViewContentModeScaleAspectFill;
    translateView.clipsToBounds = YES;
    [window addSubview:translateView];
    
    UIImage *image = nil;
    if (_index < _imageDataSources.count) {
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
                         translateView.center = CGPointMake(window.width/2, window.height/2);
                     }
                     completion:^(BOOL finished) {
                         [translateView removeFromSuperview];
                         _scrollView.hidden = NO;
                     }];
}

#pragma mark - private

- (void)hide {
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    
    SMPhotoView *photoView = _photoViews[_index];
    CGRect fromFrame = [photoView convertRect:photoView.imageFrame toView:window];
    
    UIImageView *srcView = [self srcView:_index];
    CGRect toFrame = [[srcView superview] convertRect:srcView.frame toView:window];
    
    UIImageView *translateView = [[UIImageView alloc] initWithFrame:fromFrame];
    translateView.image = [photoView image];
    translateView.contentMode = UIViewContentModeScaleAspectFill;
    translateView.clipsToBounds = YES;
    [window addSubview:translateView];
    
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

- (UIImageView *)srcView:(NSUInteger)index {
    if (index < _srcViews.count) {
        id obj = _srcViews[index];
        if ([obj isKindOfClass:[UIImageView class]]) {
            return obj;
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
        defaultSize.width = size.width/size.height*self.view.height;
        defaultSize.height = self.view.height;
    }
    else {
        defaultSize.width = self.view.width;
        defaultSize.height = size.height/size.width*self.view.width;
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

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat contentoffset = scrollView.contentOffset.x;
    _index = floor(contentoffset / scrollView.width);
    _pageCtrl.currentPage = _index;
}

#pragma mark - SMPhotoViewDelegate

- (void)photoViewOnSingleTap:(SMPhotoView *)photoView {
    [self hide];
}

- (void)photoViewOnLongPress:(SMPhotoView *)photoView {
    
}

@end
