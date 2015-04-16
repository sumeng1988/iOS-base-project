//
//  UICollectionViewControllerExt.m
//  Base
//
//  Created by sumeng on 4/16/15.
//  Copyright (c) 2015 sumeng. All rights reserved.
//

#import "UICollectionViewControllerExt.h"
#import "MJRefresh.h"

@implementation UICollectionViewControllerExt

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.needPullFlush = YES;
    self.needPullLoadmore = NO;
}

#pragma mark - public

- (BOOL)isFlushing {
    return [self.collectionView.header isRefreshing];
}

- (void)beginFlush {
    [self.collectionView.header beginRefreshing];
}

- (void)endFlush {
    [self.collectionView.header endRefreshing];
}

- (BOOL)isLoadmore {
    return [self.collectionView.footer isRefreshing];
}

- (void)beginLoadmore {
    [self.collectionView.footer beginRefreshing];
}

- (void)endLoadmore {
    [self.collectionView.footer endRefreshing];
}

- (void)refresh:(BOOL)flush {
    
}

- (void)setNeedPullFlush:(BOOL)needPullFlush {
    if (_needPullFlush != needPullFlush) {
        _needPullFlush = needPullFlush;
        
        if (needPullFlush) {
            __weak typeof(self) weakSelf = self;
            [self.collectionView addLegendHeaderWithRefreshingBlock:^{
                [weakSelf refresh:YES];
            }];
        }
        else {
            [self.collectionView removeHeader];
        }
    }
}

- (void)setNeedPullLoadmore:(BOOL)needPullLoadmore {
    if (_needPullLoadmore != needPullLoadmore) {
        _needPullLoadmore = needPullLoadmore;
        
        if (needPullLoadmore) {
            __weak typeof(self) weakSelf = self;
            [self.collectionView addLegendFooterWithRefreshingBlock:^{
                [weakSelf refresh:NO];
            }];
        }
        else {
            [self.collectionView removeFooter];
        }
    }
}

- (void)setNoMoreData:(BOOL)noMoreData {
    _noMoreData = noMoreData;
    if (noMoreData) {
        [self.collectionView.footer noticeNoMoreData];
    }
    else {
        [self.collectionView.footer resetNoMoreData];
    }
}
@end
