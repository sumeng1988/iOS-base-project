//
//  SMAudioPlayView.m
//  Base
//
//  Created by sumeng on 9/11/15.
//  Copyright (c) 2015 sumeng. All rights reserved.
//

#import "SMAudioPlayView.h"
#import "SMAudioManager.h"
#import "HttpRequest.h"

@interface SMAudioPlayView () <SMAudioManagerDelegate>

@property (nonatomic, strong) id validator;

@end

@implementation SMAudioPlayView

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self initAudioPlayView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initAudioPlayView];
    }
    return self;
}

- (void)initAudioPlayView {
    self.playState = SMAudioPlayViewStateNormal;
    [self addTarget:self action:@selector(onClicked:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setUrl:(NSURL *)url {
    [self setUrl:url validator:url];
}

- (void)setUrl:(NSURL *)url validator:(id)validator {
    _url = url;
    _validator = validator;
    if ([[SMAudioManager shared].validator isEqual:validator] && [SMAudioManager shared].isPlaying) {
        [SMAudioManager shared].delegate = self;
        self.playState = SMAudioPlayViewStatePlaying;
    }
    else if ([[SMAudioManager shared].validator isEqual:validator] && [self isDownloading:url]) {
        [SMAudioManager shared].delegate = self;
        self.playState = SMAudioPlayViewStateDownloading;
    }
    else {
        self.playState = SMAudioPlayViewStateNormal;
    }
}

- (void)play {
    [self stop];
    
    if (_url == nil) {
        return;
    }
    
    if ([[SMAudioManager shared].delegate isKindOfClass:[SMAudioPlayView class]]
        && [SMAudioManager shared].delegate != self) {
        SMAudioPlayView *view = (SMAudioPlayView *)[SMAudioManager shared].delegate;
        if (view.playState == SMAudioPlayViewStateDownloading) {
            view.playState = SMAudioPlayViewStateNormal;
        }
    }
    [SMAudioManager shared].delegate = self;
    
    if ([_url isFileURL]) {
        [self play:_url.path];
    }
    else {
        NSString *file = [[self class] downloadFile:_url.absoluteString];
        if ([[NSFileManager defaultManager] fileExistsAtPath:file]) {
            [self play:file];
        }
        else {
            [SMAudioManager shared].validator = self.validator;
            [self startDownload:_url];
        }
    }
}

- (void)play:(NSString *)file {
    [self stop];
    if (file.length == 0) {
        return;
    }
    
    self.playState = SMAudioPlayViewStatePlaying;
    [[SMAudioManager shared] play:file validator:self.validator];
}

- (void)stop {
    self.playState = SMAudioPlayViewStateNormal;
    [[SMAudioManager shared] stopPlay];
}

- (void)onClicked:(id)sender {
    if (_playState == SMAudioPlayViewStatePlaying) {
        [self stop];
    }
    else if (_playState == SMAudioPlayViewStateNormal) {
        [self play];
    }
}

#pragma mark - Download

- (void)startDownload:(NSURL *)url {
    if (url == nil) {
        return;
    }
    if (![self isDownloading:url]) {
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        NSProgress *progress;
        NSURLSessionDownloadTask *downloadTask = [[HttpRequest shared].manager downloadTaskWithRequest:request progress:&progress destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
            return [NSURL fileURLWithPath:[[self class] downloadFile:response.URL.absoluteString]];
        } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
            if (error) {
                [self didDownloadError:error];
                self.playState = SMAudioPlayViewStateNormal;
            }
            else {
                if ([self.validator isEqual:[SMAudioManager shared].validator]) {
                    [self play:filePath.path];
                }
                else {
                    self.playState = SMAudioPlayViewStateNormal;
                }
            }
        }];
        [downloadTask resume];
    }
    self.playState = SMAudioPlayViewStateDownloading;
}

- (void)didDownloadError:(NSError *)error {
    
}

- (BOOL)isDownloading:(NSURL *)url {
    for (NSURLSessionDownloadTask *downloadTask in [HttpRequest shared].manager.downloadTasks) {
        if ([downloadTask.originalRequest.URL isEqual:url]) {
            return YES;
        }
    }
    return NO;
}

#pragma mark - FileManager

+ (NSString *)downloadDir {
    NSString *dir = [[FileSystem shared].cacheDir stringByAppendingPathComponent:@"AudioDownload"];
    [[FileSystem shared] mkdir:dir];
    return dir;
}

+ (NSString *)downloadFile:(NSString *)url {
    NSString *file = [[url MD5] stringByAppendingPathExtension:[url pathExtension]];
    return [[self downloadDir] stringByAppendingPathComponent:file];
}

+ (BOOL)cleanCache {
    return [[FileSystem shared] remove:[self downloadDir]];
}

#pragma mark - AudioManagerDelegate

- (void)didAudioPlayStarted:(SMAudioManager *)am {
    
}

- (void)didAudioPlayStoped:(SMAudioManager *)am successfully:(BOOL)successfully {
    self.playState = SMAudioPlayViewStateNormal;
}

- (void)didAudioPlay:(SMAudioManager *)am err:(NSError *)err {
    self.playState = SMAudioPlayViewStateNormal;
    [SMHud text:err.domain];
}

@end
