//
//  TalkfunMoviePlayer.h
//  TalkfunMoviePlayer
//
//  Created by LuoLiuyou on 16/6/30.
//  Copyright © 2016年 luoliuyou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

#pragma mark Notifications

#ifdef __cplusplus
#define TALKFUN_EXTERN extern "C" __attribute__((visibility ("default")))
#else
#define TALKFUN_EXTERN extern __attribute__((visibility ("default")))
#endif

TALKFUN_EXTERN NSString *const TalkfunMoviePlayerName;

TALKFUN_EXTERN NSString *const TalkfunMoviePlayerVersion;

// Posted when the prepared state changes of an object conforming to the MPMoviePlayback protocol changes.
// This supersedes MPMoviePlayerContentPreloadDidFinishNotification.
TALKFUN_EXTERN NSString *const TalkfunMPMoviePlaybackIsPreparedToPlayDidChangeNotification;

// Posted when the scaling mode changes.
TALKFUN_EXTERN NSString* const TalkfunMPMoviePlayerScalingModeDidChangeNotification;

// Posted when movie playback ends or a user exits playback.
TALKFUN_EXTERN NSString* const TalkfunMPMoviePlayerPlaybackDidFinishNotification;
TALKFUN_EXTERN NSString* const TalkfunMPMoviePlayerPlaybackDidFinishReasonUserInfoKey; // NSNumber (TALKFUNMPMovieFinishReason)

// Posted when the playback state changes, either programatically or by the user.
TALKFUN_EXTERN NSString* const TalkfunMPMoviePlayerPlaybackStateDidChangeNotification;

// Posted when the network load state changes.
TALKFUN_EXTERN NSString* const TalkfunMPMoviePlayerLoadStateDidChangeNotification;

// Posted when the movie player begins or ends playing video via AirPlay.
TALKFUN_EXTERN NSString* const TalkfunMPMoviePlayerIsAirPlayVideoActiveDidChangeNotification;

// -----------------------------------------------------------------------------
// Movie Property Notifications

// Calling -prepareToPlay on the movie player will begin determining movie properties asynchronously.
// These notifications are posted when the associated movie property becomes available.
TALKFUN_EXTERN NSString* const TalkfunMPMovieNaturalSizeAvailableNotification;

// -----------------------------------------------------------------------------
//  Extend Notifications

TALKFUN_EXTERN NSString *const TalkfunMPMoviePlayerVideoDecoderOpenNotification;
TALKFUN_EXTERN NSString *const TalkfunMPMoviePlayerFirstVideoFrameRenderedNotification;
TALKFUN_EXTERN NSString *const TalkfunMPMoviePlayerFirstAudioFrameRenderedNotification;

// 播放器状态
typedef NS_ENUM(NSInteger, TalkfunMoviePlayerStatus) {
    TalkfunMoviePlayerStatusPreparedToPlay = 1,
    TalkfunMoviePlayerStatusPlay = 2,
    TalkfunMoviePlayerStatusPause = 3,
    TalkfunMoviePlayerStatusStop = 4,
    TalkfunMoviePlayerStatusShutdown = 5
};

typedef NS_ENUM(NSInteger, TalkfunMPMovieScalingMode) {
    TalkfunMPMovieScalingModeNone,       // No scaling
    TalkfunMPMovieScalingModeAspectFit,  // Uniform scale until one dimension fits
    TalkfunMPMovieScalingModeAspectFill, // Uniform scale until the movie fills the visible bounds. One dimension may have clipped contents
    TalkfunMPMovieScalingModeFill        // Non-uniform scale. Both render dimensions will exactly match the visible bounds
};

// 视频播放状态
typedef NS_ENUM(NSInteger, TalkfunMPMoviePlaybackState) {
    TalkfunMPMoviePlaybackStateStopped,
    TalkfunMPMoviePlaybackStatePlaying,
    TalkfunMPMoviePlaybackStatePaused,
    TalkfunMPMoviePlaybackStateInterrupted,
    TalkfunMPMoviePlaybackStateSeekingForward,
    TalkfunMPMoviePlaybackStateSeekingBackward
};


typedef NS_OPTIONS(NSUInteger, TalkfunMPMovieLoadState) {
    TalkfunMPMovieLoadStateUnknown        = 0,
    TalkfunMPMovieLoadStatePlayable       = 1 << 0,
    TalkfunMPMovieLoadStatePlaythroughOK  = 1 << 1, // Playback will be automatically started in this state when shouldAutoplay is YES
    TalkfunMPMovieLoadStateStalled        = 1 << 2, // Playback will be automatically paused in this state, if started
};

typedef NS_ENUM(NSInteger, TalkfunMPMovieFinishReason) {
    TalkfunMPMovieFinishReasonPlaybackEnded,
    TalkfunMPMovieFinishReasonPlaybackError,
    TalkfunMPMovieFinishReasonUserExited
};


typedef NS_ENUM(NSInteger, TalkfunMovieUrlOpenType) {
    TalkfunMovieUrlOpenEvent_ConcatResolveSegment = 0x10000,
    TalkfunMovieUrlOpenEvent_TcpOpen = 0x10001,
    TalkfunMovieUrlOpenEvent_HttpOpen = 0x10002,
    TalkfunMovieUrlOpenEvent_LiveOpen = 0x10004,
};

@interface TalkfunMediaUrlOpenData: NSObject

- (id)initWithUrl:(NSString *)url
         openType:(TalkfunMovieUrlOpenType)openType
     segmentIndex:(int)segmentIndex
     retryCounter:(int)retryCounter;

@property(nonatomic, readonly) TalkfunMovieUrlOpenType openType;
@property(nonatomic, readonly) int segmentIndex;
@property(nonatomic, readonly) int retryCounter;

@property(nonatomic, retain) NSString *url;
@property(nonatomic) int error; // set a negative value to indicate an error has occured.
@property(nonatomic, getter=isHandled)    BOOL handled;     // auto set to YES if url changed
@property(nonatomic, getter=isUrlChanged) BOOL urlChanged;  // auto set to YES by url changed

@end

@protocol TalkfunMediaUrlOpenDelegate <NSObject>

- (void)willOpenUrl:(TalkfunMediaUrlOpenData*) urlOpenData;

@end



@interface TalkfunMoviePlayer : NSObject

/**
 *  视频地址
 */
@property (nonatomic,strong) NSString *URL;


/**
 * 音频
 */
@property (nonatomic,readonly, strong)MPMusicPlayerController *musicPlayer;//音量对象    [0-1]

/**
 * 播放器状态
 */
@property (nonatomic,readonly) TalkfunMoviePlayerStatus status;

@property(nonatomic, readonly,getter=getPropertyView)  UIView *view;
@property(nonatomic, getter=getCurrentPlaybackTime,setter=setCurrentPlaybackTime:)            NSTimeInterval currentPlaybackTime;
@property(nonatomic, readonly,getter=getDuration)  NSTimeInterval duration;
@property(nonatomic, readonly,getter=getPlayableDuration)  NSTimeInterval playableDuration;
@property(nonatomic, readonly,getter=getBufferingProgress)  NSInteger bufferingProgress;

@property(nonatomic, readonly,getter=getIsPreparedToPlay)  BOOL isPreparedToPlay;


@property(nonatomic, readonly)  TalkfunMPMoviePlaybackState playbackState;
@property(nonatomic, readonly)  TalkfunMPMovieLoadState loadState;

@property(nonatomic, readonly,getter=getNumberOfBytesTransferred) int64_t numberOfBytesTransferred;

@property(nonatomic, readonly,getter=getNaturalSize) CGSize naturalSize;
@property(nonatomic,getter=getScalingMode,setter=setScalingMode:) TalkfunMPMovieScalingMode scalingMode;
@property(nonatomic,getter=getShouldAutoplay,setter=setShouldAutoplay:) BOOL shouldAutoplay;

@property (nonatomic,getter=getAllowsMovieAirPlay,setter=setAllowsMovieAirPlay:) BOOL allowsMovieAirPlay;
@property (nonatomic,getter=getIsDanmakuMovieAirPlay,setter=setIsDanmakuMovieAirPlay:) BOOL isDanmakuMovieAirPlay;
@property (nonatomic, readonly,getter=getAirPlayMediaActive) BOOL airPlayMediaActive;

@property (nonatomic,getter=getPlaybackRate,setter=setPlaybackRate:) float playbackRate;

@property(nonatomic, readonly,getter=getFpsInMeta) CGFloat fpsInMeta;
@property(nonatomic, readonly,getter=getFpsAtOutput) CGFloat fpsAtOutput;


- (id)initWithContentURLString:(NSString *)aUrlString;

- (id)initWithContentURLString:(NSString *)aUrlString withOptions:(NSMutableDictionary *)options;

- (void)prepareToPlay;
- (void)play;
- (void)pause;
- (void)stop;
- (BOOL)isPlaying;
- (void)shutdown;

- (NSString *)getVersion;

//
- (void)setPauseInBackground:(BOOL)pause;
- (BOOL)isVideoToolboxOpen;

- (UIImage *)thumbnailImageAtCurrentTime;

//+ (void)setLogReport:(BOOL)preferLogReport;
//+ (void)setLogLevel:(TalkfunLogLevel)logLevel;


/*
- (void)setOptionValue:(NSString *)value
                forKey:(NSString *)key
            ofCategory:(TalkfunFFOptionCategory)category;

- (void)setOptionIntValue:(int64_t)value
                   forKey:(NSString *)key
               ofCategory:(TalkfunFFOptionCategory)category;



- (void)setFormatOptionValue:       (NSString *)value forKey:(NSString *)key;
- (void)setCodecOptionValue:        (NSString *)value forKey:(NSString *)key;
- (void)setSwsOptionValue:          (NSString *)value forKey:(NSString *)key;
- (void)setPlayerOptionValue:       (NSString *)value forKey:(NSString *)key;

- (void)setFormatOptionIntValue:    (int64_t)value forKey:(NSString *)key;
- (void)setCodecOptionIntValue:     (int64_t)value forKey:(NSString *)key;
- (void)setSwsOptionIntValue:       (int64_t)value forKey:(NSString *)key;
- (void)setPlayerOptionIntValue:    (int64_t)value forKey:(NSString *)key;

 */
@property (nonatomic, retain ,setter=setDelegateSegmentOpenDelegate:) id<TalkfunMediaUrlOpenDelegate> segmentOpenDelegate;
@property (nonatomic, retain ,setter=setDelegateTcpOpenDelegate:) id<TalkfunMediaUrlOpenDelegate> tcpOpenDelegate;
@property (nonatomic, retain ,setter=setDelegateHttpOpenDelegate:) id<TalkfunMediaUrlOpenDelegate> httpOpenDelegate;
@property (nonatomic, retain ,setter=setDelegateLiveOpenDelegate:) id<TalkfunMediaUrlOpenDelegate> liveOpenDelegate;

@end

/*
#define Talkfun_FF_IO_TYPE_READ (1)
void TalkfunFFIOStatDebugCallback(const char *url, int type, int bytes);
void TalkfunFFIOStatRegister(void (*cb)(const char *url, int type, int bytes));

void TalkfunFFIOStatCompleteDebugCallback(const char *url,
                                      int64_t read_bytes, int64_t total_size,
                                      int64_t elpased_time, int64_t total_duration);
void TalkfunFFIOStatCompleteRegister(void (*cb)(const char *url,
                                            int64_t read_bytes, int64_t total_size,
                                            int64_t elpased_time, int64_t total_duration));

 */



