//
//  BaseListVC.h
//  Base
//
//  Created by sumeng on 4/16/15.
//  Copyright (c) 2015 sumeng. All rights reserved.
//

#import "UIViewControllerExt.h"

@interface UITableViewControllerExt : UIViewControllerExt <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIView *footerView;
@property (nonatomic, assign) BOOL needPullFlush;
@property (nonatomic, assign) BOOL needPullLoadmore;
@property (nonatomic, assign) BOOL noMoreData;

- (BOOL)isFlushing;
- (void)beginFlush;
- (void)endFlush;
- (BOOL)isLoadmore;
- (void)beginLoadmore;
- (void)endLoadmore;

- (void)refresh:(BOOL)flush;

@end
