//
//  SMAudioManager.h
//  Base
//
//  Created by sumeng on 9/11/15.
//  Copyright (c) 2015 sumeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SMAudioManagerDelegate;

@interface SMAudioManager : NSObject

@property (nonatomic, assign, readonly) BOOL isPlaying;
@property (nonatomic, assign, readonly) BOOL isRecording;
@property (nonatomic, assign) NSTimeInterval maxRecordDuration;
@property (nonatomic, weak) id<SMAudioManagerDelegate> delegate;
@property (nonatomic, strong) id validator;

+ (instancetype)shared;

- (void)play:(NSString *)file validator:(id)validator;
- (void)stopPlay;
- (void)record:(NSString *)file;
- (void)stopRecord;
- (void)stopAll;

@end


@protocol SMAudioManagerDelegate <NSObject>

@optional

- (void)didAudioPlayStarted:(SMAudioManager *)am;
- (void)didAudioPlayStoped:(SMAudioManager *)am successfully:(BOOL)successfully;
- (void)didAudioPlay:(SMAudioManager *)am err:(NSError *)err;

- (void)didAudioRecordStarted:(SMAudioManager *)am;
- (void)didAudioRecording:(SMAudioManager *)am volume:(double)volume;
- (void)didAudioRecordStoped:(SMAudioManager *)am file:(NSString *)file duration:(NSTimeInterval)duration;
- (void)didAudioRecord:(SMAudioManager *)am err:(NSError *)err;

@end