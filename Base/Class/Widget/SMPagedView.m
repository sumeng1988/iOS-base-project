//
//  SMPagedView.m
//  Base
//
//  Created by sumeng on 15/5/26.
//  Copyright (c) 2015年 sumeng. All rights reserved.
//

#import "SMPagedView.h"

@interface SMPagedView () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageCtrl;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation SMPagedView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)initView {
    self.backgroundColor = [UIColor blackColor];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    _scrollView.delegate = self;
    _scrollView.pagingEnabled = YES;
    _scrollView.alwaysBounceHorizontal = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    [self addSubview:_scrollView];
    
    _pageCtrl = [[UIPageControl alloc] init];
    _pageCtrl.hidesForSinglePage = YES;
    [_pageCtrl addTarget:self
                  action:@selector(onPageValueChanged:)
        forControlEvents:UIControlEventValueChanged];
    [self addSubview:_pageCtrl];
    
    _interval = 5.0f;
}

#pragma mark - Public

- (void)setPages:(NSArray *)pages {
    _pages = pages;
    
    if (_pages.count <= 1) {
        _scrollView.contentSize = CGSizeMake(_scrollView.width, _scrollView.height);
    }
    else {
        _scrollView.contentSize = CGSizeMake(_scrollView.width*3, _scrollView.height);
    }
    
    _pageCtrl.numberOfPages = pages.count;
    
    self.index = 0;
    self.autoSwitching = _autoSwitching;
}

- (void)setIndex:(NSInteger)index {
    if (index >= 0 && index < _pages.count) {
        _index = index;
        _pageCtrl.currentPage = _index;
        if (_pages.count <= 1) {
            _scrollView.contentOffset = CGPointMake(0, 0);
        }
        else {
            _scrollView.contentOffset = CGPointMake(_scrollView.width, 0);
        }
        [self layoutPages];
    }
}

- (void)setAutoSwitching:(BOOL)autoSwitching {
    _autoSwitching = autoSwitching;
    [self stopTimer];
    if (autoSwitching && _pages.count > 1) {
        [self startTimer];
    }
}

- (void)setInterval:(NSTimeInterval)interval {
    _interval = interval;
    self.autoSwitching = _autoSwitching;
}

#pragma mark - Layout

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _scrollView.frame = self.bounds;
    [self layoutScrollView];
    
    _pageCtrl.frame = CGRectMake(0, self.height - 21, self.width, 21);
    
    [self layoutPages];
}

- (void)layoutScrollView {
    NSInteger count = _pages.count <= 1 ? 1 : 3;
    _scrollView.contentSize = CGSizeMake(_scrollView.width * count, _scrollView.height);
    _scrollView.contentOffset = CGPointMake(_scrollView.width * (count == 1 ? 0 : 1), 0);
}

- (void)layoutPages {
    for (UIView *page in _pages) {
        [page removeFromSuperview];
    }
    
    if (_pages.count <= 1) {
        if (_pages.count == 1) {
            UIView *page = _pages[0];
            [page removeFromSuperview];
            page.center = CGPointMake(_scrollView.width/2, _scrollView.height/2);
            [_scrollView addSubview:page];
        }
        return;
    }
    
    for (int i = 0; i < 3; i++) {
        NSInteger index = _index;
        if (i == 0) {
            index = [self prevIndex];
        }
        else if (i == 2) {
            index = [self nextIndex];
        }
        UIView *page = _pages[index];
        [page removeFromSuperview];
        page.center = CGPointMake(_scrollView.width*(i+0.5), _scrollView.height/2);
        [_scrollView addSubview:page];
    }
}

#pragma mark - Private

- (void)startTimer {
    [self stopTimer];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:_interval target:self selector:@selector(switchToNextPage) userInfo:nil repeats:YES];
}

- (void)stopTimer {
    if (_timer) {
        [_timer invalidate];
        self.timer = nil;
    }
}

- (void)switchToNextPage {
    if (_pages.count <= 1) {
        return;
    }
    [_scrollView setContentOffset:CGPointMake(_scrollView.width*2, 0) animated:YES];
}

- (NSInteger)prevIndex {
    NSInteger index = _index - 1;
    if (index < 0) {
        index = _pages.count - 1;
    }
    return index;
}

- (NSInteger)nextIndex {
    NSInteger index = _index + 1;
    if (index >= _pages.count) {
        index = 0;
    }
    return index;
}

- (void)onPageValueChanged:(id)sender {
    self.index = _pageCtrl.currentPage;
    self.autoSwitching = _autoSwitching;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (_autoSwitching) {
        [self stopTimer];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (_autoSwitching) {
        self.autoSwitching = _autoSwitching;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (_pages.count <= 1) {
        return;
    }
    
    CGRect visibleBounds = scrollView.bounds;
    NSInteger page = (NSInteger)(floorf(CGRectGetMidX(visibleBounds) / CGRectGetWidth(visibleBounds)));
    if (page != 1) {
        if (page > 1) {
            _index = [self nextIndex];
            _scrollView.contentOffset = CGPointMake(_scrollView.contentOffset.x - _scrollView.width, 0);
        }
        else {
            _index = [self prevIndex];
            _scrollView.contentOffset = CGPointMake(_scrollView.contentOffset.x + _scrollView.width, 0);
        }
        _pageCtrl.currentPage = _index;
        [self layoutPages];
    }
    
    if (_pages.count == 2) {
        if (scrollView.contentOffset.x < scrollView.width) {
            UIView *page = _pages[[self prevIndex]];
            if (page.center.x > scrollView.width) {
                page.center = CGPointMake(scrollView.width*0.5, scrollView.height/2);
            }
        }
        else {
            UIView *page = _pages[[self nextIndex]];
            if (page.center.x < scrollView.width*2) {
                page.center = CGPointMake(scrollView.width*2.5, scrollView.height/2);
            }
        }
    }
}

@end
