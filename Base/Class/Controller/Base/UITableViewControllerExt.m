//
//  UITableViewControllerExt.m
//  Base
//
//  Created by sumeng on 4/16/15.
//  Copyright (c) 2015 sumeng. All rights reserved.
//

#import "UITableViewControllerExt.h"
#import "MJRefresh.h"

@implementation UITableViewControllerExt

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.needPullFlush = YES;
    self.needPullLoadmore = NO;
}

#pragma mark - public

- (BOOL)isFlushing {
    return [self.tableView.header isRefreshing];
}

- (void)beginFlush {
    [self.tableView.header beginRefreshing];
}

- (void)endFlush {
    [self.tableView.header endRefreshing];
}

- (BOOL)isLoadmore {
    return [self.tableView.footer isRefreshing];
}

- (void)beginLoadmore {
    [self.tableView.footer beginRefreshing];
}

- (void)endLoadmore {
    [self.tableView.footer endRefreshing];
}

- (void)refresh:(BOOL)flush {
    
}

- (void)setNeedPullFlush:(BOOL)needPullFlush {
    if (_needPullFlush != needPullFlush) {
        _needPullFlush = needPullFlush;
        
        if (needPullFlush) {
            __weak typeof(self) weakSelf = self;
            [self.tableView addLegendHeaderWithRefreshingBlock:^{
                [weakSelf refresh:YES];
            }];
        }
        else {
            [self.tableView removeHeader];
        }
    }
}

- (void)setNeedPullLoadmore:(BOOL)needPullLoadmore {
    if (_needPullLoadmore != needPullLoadmore) {
        _needPullLoadmore = needPullLoadmore;
        
        if (needPullLoadmore) {
            __weak typeof(self) weakSelf = self;
            [self.tableView addLegendFooterWithRefreshingBlock:^{
                [weakSelf refresh:NO];
            }];
        }
        else {
            [self.tableView removeFooter];
        }
    }
}

- (void)setNoMoreData:(BOOL)noMoreData {
    _noMoreData = noMoreData;
    if (noMoreData) {
        [self.tableView.footer noticeNoMoreData];
    }
    else {
        [self.tableView.footer resetNoMoreData];
    }
}

@end
