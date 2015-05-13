//
//  SMImageView.h
//  Base
//
//  Created by sumeng on 5/11/15.
//  Copyright (c) 2015 sumeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMImageView : UIImageView

@property (nonatomic, strong) UIImage *placeholderImage;
@property (nonatomic, strong) id imageDataSource;

@end