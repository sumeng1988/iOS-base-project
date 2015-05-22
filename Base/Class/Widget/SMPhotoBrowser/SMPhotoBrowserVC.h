//
//  SMPhotoBrowserVC.h
//  Base
//
//  Created by sumeng on 5/11/15.
//  Copyright (c) 2015 sumeng. All rights reserved.
//

#import "UIViewControllerExt.h"

@interface SMPhotoBrowserVC : UIViewControllerExt

@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) NSArray *imageDataSources;
@property (nonatomic, strong) NSArray *srcViews;  //UIImageView

@property (nonatomic, assign) BOOL fillScreenWhenLongPhoto;

- (void)show;

@end
