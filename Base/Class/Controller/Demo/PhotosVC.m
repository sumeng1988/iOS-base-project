//
//  PhotosVC.m
//  Base
//
//  Created by sumeng on 5/11/15.
//  Copyright (c) 2015 sumeng. All rights reserved.
//

#import "PhotosVC.h"
#import "SMPhotoBrowserVC.h"
#import "SMImageView.h"

@interface PhotosVC ()

@property (nonatomic, strong) NSArray *imageViews;
@property (nonatomic, strong) NSArray *urls;

@end

@implementation PhotosVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _urls = @[[NSURL URLWithString:@"http://c.hiphotos.baidu.com/image/pic/item/4610b912c8fcc3ce995e92589045d688d43f203a.jpg"],
              [NSURL URLWithString:@"http://h.hiphotos.baidu.com/image/pic/item/9922720e0cf3d7ca0cfbcf56f71fbe096b63a985.jpg"],
              [NSURL URLWithString:@"http://ww2.sinaimg.cn/bmiddle/718bbf61gw1es1mwd1b6pj20c84dwb26.jpg"],
              [NSURL URLWithString:@"http://c.hiphotos.baidu.com/image/pic/item/4610b912c8fcc3ce995e92589045d688d43f203a.jpg"],
              [NSURL URLWithString:@"http://h.hiphotos.baidu.com/image/pic/item/9922720e0cf3d7ca0cfbcf56f71fbe096b63a985.jpg"],
              [NSURL URLWithString:@"http://ww2.sinaimg.cn/bmiddle/718bbf61gw1es1mwd1b6pj20c84dwb26.jpg"],
              [NSURL URLWithString:@"http://c.hiphotos.baidu.com/image/pic/item/4610b912c8fcc3ce995e92589045d688d43f203a.jpg"],
              [NSURL URLWithString:@"http://h.hiphotos.baidu.com/image/pic/item/9922720e0cf3d7ca0cfbcf56f71fbe096b63a985.jpg"],
              [NSURL URLWithString:@"http://ww2.sinaimg.cn/bmiddle/718bbf61gw1es1mwd1b6pj20c84dwb26.jpg"],
              [NSURL URLWithString:@"http://c.hiphotos.baidu.com/image/pic/item/4610b912c8fcc3ce995e92589045d688d43f203a.jpg"],
              [NSURL URLWithString:@"http://h.hiphotos.baidu.com/image/pic/item/9922720e0cf3d7ca0cfbcf56f71fbe096b63a985.jpg"],
              [NSURL URLWithString:@"http://ww2.sinaimg.cn/bmiddle/718bbf61gw1es1mwd1b6pj20c84dwb26.jpg"]];
    
    SMImageView *image1View = [[SMImageView alloc] init];
    image1View.frame = CGRectMake(10, 100, 80, 80);
    image1View.userInteractionEnabled = YES;
    image1View.imageDataSource = _urls[0];
    image1View.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:image1View];
    
    SMImageView *image2View = [[SMImageView alloc] init];
    image2View.frame = CGRectMake(110, 100, 80, 80);
    image2View.userInteractionEnabled = YES;
    image2View.imageDataSource = _urls[1];
    image2View.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:image2View];
    
    SMImageView *image3View = [[SMImageView alloc] init];
    image3View.frame = CGRectMake(210, 100, 80, 80);
    image3View.userInteractionEnabled = YES;
    image3View.imageDataSource = _urls[2];
    image3View.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:image3View];
    
    _imageViews = @[image1View, image2View, image3View];
    
    for (UIView *v in _imageViews) {
        UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        [v addGestureRecognizer:tapGr];
    }
}

- (void)handleTap:(UITapGestureRecognizer *)gesture {
    NSUInteger index = [_imageViews indexOfObject:gesture.view];
    
    SMPhotoBrowserVC *vc = [[SMPhotoBrowserVC alloc] init];
    vc.index = index;
    vc.imageDataSources = _urls;
    vc.srcViews = _imageViews;
    [vc show];
}

@end
