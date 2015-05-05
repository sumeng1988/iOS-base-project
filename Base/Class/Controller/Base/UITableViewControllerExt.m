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
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.autoresizesSubviews = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    
    self.needPullFlush = YES;
    self.needPullLoadmore = NO;
}

#pragma mark - public

- (void)setHeaderView:(UIView *)headerView {
    if (_headerView != headerView) {
        [headerView removeFromSuperview];
        [_headerView removeFromSuperview];
        _headerView = headerView;
        [self.view addSubview:_headerView];
    }
    _headerView.y = 0;
    _headerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self layoutTableView];
}

- (void)setFooterView:(UIView *)footerView {
    if (_footerView != footerView) {
        [footerView removeFromSuperview];
        [_footerView removeFromSuperview];
        _footerView = footerView;
        [self.view addSubview:_footerView];
    }
    _footerView.y = self.view.height - _footerView.height;
    _footerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    [self layoutTableView];
}

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

#pragma mark - private 

- (void)layoutTableView {
    _tableView.frame = CGRectMake(0, _headerView.height, self.view.width, self.view.height - _headerView.height - _footerView.height);
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

@end
