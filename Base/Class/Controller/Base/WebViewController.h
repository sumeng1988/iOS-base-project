//
//  WebViewController.h
//  Base
//
//  Created by sumeng on 4/16/15.
//  Copyright (c) 2015 sumeng. All rights reserved.
//

#import "UIViewControllerExt.h"

@interface UIWebViewController : UIViewControllerExt

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *caption;

@end
