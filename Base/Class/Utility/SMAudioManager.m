//
//  SMAudioManager.m
//  Base
//
//  Created by sumeng on 9/11/15.
//  Copyright (c) 2015 sumeng. All rights reserved.
//

#import "SMAudioManager.h"
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>

@interface SMAudioManager () <AVAudioPlayerDelegate, AVAudioRecorderDelegate>

@property (nonatomic, strong, readonly) AVAudioPlayer *audioPlayer;
@property (nonatomic, strong, readonly) AVAudioRecorder *audioRecorder;

@property (nonatomic, copy) NSString *recordFile;
@property (nonatomic, strong) NSTimer *meterTimer;

@end

@implementation SMAudioManager

+ (instancetype)shared {
    static id obj = nil;
    if (obj == nil) {
        obj = [[self alloc] init];
    }
    return obj;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _isPlaying = NO;
        _isRecording = NO;
        _maxRecordDuration = 0;
    }
    return self;
}

- (void)play:(NSString *)file validator:(id)validator {
    [self stopPlay];
    [self stopRecord];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:file]) {
        return;
    }
    
    NSError *err;
    NSURL *url = [NSURL fileURLWithPath:file isDirectory:NO];
    _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&err];
    if (err) {
        if(_delegate && [_delegate respondsToSelector:@selector(didAudioPlay:err:)]) {
            [_delegate didAudioPlay:self err:err];
        }
        [self stopPlay];
        return;
    }
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    [audioSession setActive:YES error:nil];
    
    _audioPlayer.delegate = self;
    _audioPlayer.volume = 1.0f;
    [_audioPlayer play];
    [self startProximityMonitering];
    _validator = validator;
    _isPlaying = YES;
    
    if (_delegate && [_delegate respondsToSelector:@selector(didAudioPlayStarted:)]) {
        [_delegate didAudioPlayStarted:self];
    }
}

- (void)stopPlay {
    [self stopPlay:NO];
}

- (void)stopPlay:(BOOL)successfully {
    if (_audioPlayer) {
        [_audioPlayer stop];
        _audioPlayer = nil;
    }
    if (_isPlaying) {
        _isPlaying = NO;
        [self stopProximityMonitering];
        if (_delegate && [_delegate respondsToSelector:@selector(didAudioPlayStoped:successfully:)]) {
            [_delegate didAudioPlayStoped:self successfully:successfully];
        }
    }
}

- (void)record:(NSString *)file {
    [self stopPlay];
    [self stopRecord];
    
    if (file.length > 0) {
        if ([[NSFileManager defaultManager] fileExistsAtPath:file]) {
            [[NSFileManager defaultManager] removeItemAtPath:file error:nil];
        }
        _recordFile = [file copy];
    }
    else {
        _recordFile = [[[FileSystem shared] temporary] stringByAppendingPathExtension:@"m4a"];
    }
    
    NSDictionary *settings = @{AVFormatIDKey:[NSNumber numberWithInt:kAudioFormatMPEG4AAC],
                               AVSampleRateKey:@8000,
                               AVEncoderBitRateKey:@12200,
                               AVNumberOfChannelsKey:@1,
                               AVLinearPCMBitDepthKey:@16};;
    
    
    NSError *err;
    _audioRecorder = [[AVAudioRecorder alloc] initWithURL:[NSURL URLWithString:_recordFile]
                                                 settings:settings
                                                    error:&err];
    if (err) {
        if (_delegate && [_delegate respondsToSelector:@selector(didAudioRecord:err:)]) {
            [_delegate didAudioRecord:self err:err];
        }
        [self stopRecord];
        return;
    }
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    [[AVAudioSession sharedInstance] setActive:YES error: nil];
    
    _isRecording = YES;
    __weak typeof(self) weakSelf = self;
    if ([[AVAudioSession sharedInstance] respondsToSelector:@selector(requestRecordPermission:)]) {
        [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
            if (granted) {
                if (weakSelf.isRecording) {
                    weakSelf.audioRecorder.delegate = weakSelf;
                    weakSelf.audioRecorder.meteringEnabled = YES;
                    [weakSelf.audioRecorder record];
                    weakSelf.validator = nil;
                    [weakSelf startUpdateMeter];
                    
                    if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(didAudioRecordStarted:)]) {
                        [weakSelf.delegate didAudioRecordStarted:weakSelf];
                    }
                }
            }
            else {
                _isRecording = NO;
                NSLog(@"没有权限");
            }
        }];
    }
    else {
        _audioRecorder.delegate = weakSelf;
        _audioRecorder.meteringEnabled = YES;
        [_audioRecorder record];
        _validator = nil;
        [self startUpdateMeter];
        
        if (_delegate && [_delegate respondsToSelector:@selector(didAudioRecordStarted:)]) {
            [_delegate didAudioRecordStarted:self];
        }
    }
}

- (void)stopRecord {
    [self stopRecord:nil];
}

- (void)stopRecord:(NSError *)error {
    [self stopUpdateMeter];
    NSTimeInterval duration = 0;
    if (_audioRecorder) {
        duration = _audioRecorder.currentTime;
        [_audioRecorder stop];
        _audioRecorder = nil;
    }
    if (_isRecording) {
        _isRecording = NO;
        if (!error) {
            if (_delegate && [_delegate respondsToSelector:@selector(didAudioRecordStoped:file:duration:)]) {
                [_delegate didAudioRecordStoped:self file:_recordFile duration:duration];
            }
        }
        else {
            if (_delegate && [_delegate respondsToSelector:@selector(didAudioRecord:err:)]) {
                [_delegate didAudioRecord:self err:error];
            }
        }
    }
}

- (void)stopAll {
    if (_isPlaying) {
        [self stopPlay];
    }
    if (_isRecording) {
        [self stopRecord];
    }
}

- (void)startUpdateMeter {
    self.meterTimer = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(updateMeter) userInfo:nil repeats:YES];
}

- (void)stopUpdateMeter {
    if (_meterTimer) {
        [_meterTimer invalidate];
        self.meterTimer = nil;
    }
}

- (void)updateMeter {
    [_audioRecorder updateMeters];
    
    double volume; // The linear 0.0 .. 1.0 value we need.
    float minDecibels = -80.0f; // Or use -60dB, which I measured in a silent room.
    float decibels = [_audioRecorder averagePowerForChannel:0];
    
    if (decibels < minDecibels) {
        volume = 0.0f;
    } else if (decibels >= 0.0f) {
        volume = 1.0f;
    } else {
        float root = 2.0f;
        float minAmp = powf(10.0f, 0.05f * minDecibels);
        float inverseAmpRange = 1.0f / (1.0f - minAmp);
        float amp = powf(10.0f, 0.05f * decibels);
        float adjAmp = (amp - minAmp) * inverseAmpRange;
        
        volume = pow(adjAmp, 1.0f / root);
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(didAudioRecording:volume:)]) {
        [_delegate didAudioRecording:self volume:volume];
    }
    
    if (_maxRecordDuration != 0 && _audioRecorder.currentTime >= _maxRecordDuration+0.1f) {
        [self stopRecord];
    }
}

#pragma mark - Proximity

- (void)startProximityMonitering {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(proximityStateDidChange:)
                                                 name:UIDeviceProximityStateDidChangeNotification
                                               object:nil];
    
    [UIDevice currentDevice].proximityMonitoringEnabled = YES;
}

- (void)stopProximityMonitering {
    [UIDevice currentDevice].proximityMonitoringEnabled = NO;
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIDeviceProximityStateDidChangeNotification
                                                  object:nil];
}

- (void)proximityStateDidChange:(NSNotification *)notification {
    [[AVAudioSession sharedInstance] setCategory:([[UIDevice currentDevice] proximityState] ? AVAudioSessionCategoryPlayAndRecord : AVAudioSessionCategoryPlayback) error:nil];
}

#pragma mark - AVAudioPlayerDelegate

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)vplayer successfully:(BOOL)flag {
    [self stopPlay:flag];
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)vplayer error:(NSError *)error {
    [self stopPlay];
}

- (void)audioPlayerBeginInterruption:(AVAudioPlayer *)vplayer {
    [[AVAudioSession sharedInstance] setActive:NO error:nil];
    [self stopPlay];
}

- (void)audioPlayerEndInterruption:(AVAudioPlayer *)vplayer withFlags:(NSUInteger)flags {
    [[AVAudioSession sharedInstance] setActive:NO error:nil];
}

#pragma mark - AVAudioRecorderDelegate

- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)vrecorder successfully:(BOOL)flag {
    [[AVAudioSession sharedInstance] setActive:NO error:nil];
}

- (void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)vrecorder error:(NSError *)error {
    [self stopRecord:error];
}

- (void)audioRecorderBeginInterruption:(AVAudioRecorder *)vrecorder {
    [[AVAudioSession sharedInstance] setActive:NO error:nil];
    [self stopRecord:[NSError errorWithDomain:@"Interruption" code:200 userInfo:nil]];
}

@end

