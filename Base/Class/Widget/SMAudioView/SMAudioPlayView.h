//
//  SMAudioPlayView.h
//  Base
//
//  Created by sumeng on 9/11/15.
//  Copyright (c) 2015 sumeng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, AudioPlayViewState) {
    SMAudioPlayViewStateNormal,
    SMAudioPlayViewStateDownloading,
    SMAudioPlayViewStatePlaying
};

@interface SMAudioPlayView : UIControl

@property (nonatomic, strong) NSURL *url;
@property (nonatomic, assign) AudioPlayViewState playState;

- (void)setUrl:(NSURL *)url validator:(id)validator;

- (void)play;
- (void)stop;

- (void)didDownloadError:(NSError *)error;

+ (BOOL)cleanCache;

@end