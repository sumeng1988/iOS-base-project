//
//  SMEmotionPanel.m
//  Base
//
//  Created by sumeng on 5/5/15.
//  Copyright (c) 2015 sumeng. All rights reserved.
//

#import "SMEmotionPanel.h"
#import "EmotionInfo.h"

@interface SMEmotionItem : UIControl

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, copy) NSString *emotion;

@end

@implementation SMEmotionItem

- (instancetype)init {
    return [self initWithFrame:CGRectMake(0, 0, kSMEmotionItemWidth, kSMEmotionItemHeight)];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)initView {
    _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:_imageView];
}

@end

@class SMEmotionsPage;

@protocol SMEmotionsPageDelegate <NSObject>

@optional
- (void)emotionsPage:(SMEmotionsPage *)page pickEmotion:(NSString *)emotion;

@end

@interface SMEmotionsPage : UIView

@property (nonatomic, strong) NSArray *itemViews;
@property (nonatomic, weak) id<SMEmotionsPageDelegate> delegate;

@end

@implementation SMEmotionsPage

- (instancetype)init {
    return [self initWithFrame:CGRectMake(0, 0, kUIScreenSize.width, 196)];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)initView {
    int count = kSMEmotionPageRow * kSMEmotionPageColumn;
    NSMutableArray *items = [[NSMutableArray alloc] initWithCapacity:count];
    for (int i = 0; i < count; i++) {
        int x = self.size.width / kSMEmotionPageColumn * (i % kSMEmotionPageColumn + 0.5);
        int y = kSMEmotionItemLineSpacing + i / kSMEmotionPageColumn * (kSMEmotionItemLineSpacing + kSMEmotionItemHeight);
        
        SMEmotionItem *itemView = [[SMEmotionItem alloc] init];
        itemView.hidden = YES;
        itemView.topCenter = CGPointMake(x, y);
        [itemView addTarget:self action:@selector(itemClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:itemView];
        [items addObject:itemView];
    }
    _itemViews = items;
}

- (void)setEmotions:(NSArray *)emotions {
    for (int i = 0; i < _itemViews.count; i++) {
        SMEmotionItem *itemView = [_itemViews objectAtIndex:i];
        itemView.hidden = (i >= emotions.count);
        if (!itemView.hidden) {
            NSString *emotion = [emotions objectAtIndex:i];
            itemView.emotion = emotion;
            itemView.imageView.image = [[EmotionInfo shared] imageForKey:emotion];
        }
    }
}

- (void)itemClicked:(id)sender {
    SMEmotionItem *itemView = (SMEmotionItem *)sender;
    NSString *emotion = itemView.emotion;
    if (emotion.notEmpty && _delegate && [_delegate respondsToSelector:@selector(emotionsPage:pickEmotion:)]) {
        [_delegate emotionsPage:self pickEmotion:emotion];
    }
}

@end


@interface SMEmotionPanel () <SMEmotionsPageDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;

@end

@implementation SMEmotionPanel

- (instancetype)init {
    return [self initWithFrame:CGRectMake(0, 0, kUIScreenSize.width, kSMEmotionPanelHeight)];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)initView {
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.width, kSMEmotionPageHeight)];
    _scrollView.pagingEnabled = YES;
    _scrollView.alwaysBounceHorizontal = YES;
    _scrollView.delegate = self;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    [self addSubview:_scrollView];
    
    NSArray *emotions = [[EmotionInfo shared] all];
    NSUInteger countOfPage = kSMEmotionPageColumn * kSMEmotionPageRow;
    NSUInteger numberOfPage = (emotions.count - 1) / countOfPage + 1;
    for (int i = 0; i < numberOfPage; i++) {
        SMEmotionsPage *page = [[SMEmotionsPage alloc] initWithFrame:CGRectMake(i*_scrollView.width, 0, _scrollView.width, _scrollView.height)];
        page.delegate = self;
        [_scrollView addSubview:page];
        
        NSRange range = NSMakeRange(i * countOfPage, MIN(countOfPage, emotions.count - i * countOfPage));
        [page setEmotions:[emotions subarrayWithRange:range]];
    }
    _scrollView.contentSize = CGSizeMake(numberOfPage * _scrollView.width, _scrollView.height);
    
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, kSMEmotionPageHeight, self.width, 20)];
    _pageControl.pageIndicatorTintColor = [UIColor colorWithRGB:0xbbbbbb];
    _pageControl.currentPageIndicatorTintColor = [UIColor colorWithRGB:0x8b8b8b];
    _pageControl.numberOfPages = numberOfPage;
    _pageControl.currentPage = 0;
    [_pageControl addTarget:self action:@selector(actionControlPage:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:_pageControl];
    
    UIView *bottomBar = [[UIView alloc] initWithFrame:CGRectMake(0, _pageControl.y+_pageControl.height, self.width, 38)];
    bottomBar.backgroundColor = [UIColor colorWithRGB:0xFAFAFA];
    [self addSubview:bottomBar];
    
    UIButton *delBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    delBtn.frame = CGRectMake(0, 0, 65, bottomBar.height);
    delBtn.backgroundColor = [UIColor colorWithRGB:0xe6e6e6];
    [delBtn setImage:[UIImage imageNamed:@"inputbar_del"] forState:UIControlStateNormal];
    [delBtn addTarget:self action:@selector(delBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [bottomBar addSubview:delBtn];
    
    UIButton *sendBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    sendBtn.frame = CGRectMake(bottomBar.width-65, 0, 65, bottomBar.height);
    sendBtn.backgroundColor = [UIColor colorWithRGB:0xe6e6e6];
    [sendBtn setTitle:@"Send" forState:UIControlStateNormal];
    [sendBtn addTarget:self action:@selector(sendBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [bottomBar addSubview:sendBtn];
}

- (void)delBtnClicked:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(emotionPanelDelete:)]) {
        [_delegate emotionPanelDelete:self];
    }
}

- (void)sendBtnClicked:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(emotionPanelSend:)]) {
        [_delegate emotionPanelSend:self];
    }
}

- (void)emotionsPage:(SMEmotionsPage *)page pickEmotion:(NSString *)emotion {
    if (_delegate && [_delegate respondsToSelector:@selector(emotionPanel:pickEmotion:)]) {
        [_delegate emotionPanel:self pickEmotion:emotion];
    }
}

- (void)actionControlPage:(id)sender {
    [_scrollView setContentOffset:CGPointMake(_pageControl.currentPage * _scrollView.width, 0) animated:YES];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    _pageControl.currentPage = _scrollView.contentOffset.x / _scrollView.width;
}

@end
