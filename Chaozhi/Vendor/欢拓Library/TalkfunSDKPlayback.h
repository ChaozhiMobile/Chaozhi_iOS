//
//  TalkfunSDKPlayback.h
//  TalkfunSDKPlayback
//
//  Created by LuoLiuyou on 2017/7/20.
//  Copyright © 2017年 Talkfun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TalkfunSDK.h"
//SDK代理
@protocol TalkfunSDKPlaybackDelegate <NSObject>

@optional
/**
 *  播放状态发生变化时候调用
 **/
- (void)playStatusChange:(TalkfunPlayStatus)status;

/**
 *  视频播放状态改变
 */
- (void)playerLoadStateDidChange:(TalkfunPlayerLoadState)loadState;

/**
 *  视频播放结束代理
 */
- (void)playerPlaybackDidFinish:(TalkfunPlayerMovieFinishReason)reason;

@end

@interface TalkfunSDKPlayback : NSObject

//代理
@property (nonatomic,weak) id<TalkfunSDKPlaybackDelegate> delegate;
//获取当前token
@property (nonatomic,copy,readonly)     NSString * access_token;
//获取当前播放视频的模式
@property (nonatomic,assign,readonly) TalkfunLiveMode liveMode;
//获取视频窗口容器
@property (nonatomic,weak,readonly)   UIView * cameraContainerView;
//获取ppt容器
@property (nonatomic,weak,readonly)   UIView * pptContainerView;
//获取播放桌面分享的容器
@property (nonatomic,weak,readonly)   UIView * desktopContainerView;
//获取视频的播放状态
@property (nonatomic,assign,readonly) TalkfunPlayStatus playStatus;
//点播播放速度 [0-2]
@property (nonatomic) float playbackRate;
//是否开启cache模式(默认开启)
@property (nonatomic,assign) BOOL cacheSwitch;

//是否开启自动的线路选择 默认为YES
@property (nonatomic) BOOL autoSelectNetwork;

//当前用户信息
@property (nonatomic) NSDictionary *me;

/**
 *  TalkfunPlayback单例
 **/
+ (TalkfunSDKPlayback *)shareInstance;

/**
 *  初始化TalkfunPlayback，需要传入AccessToken和parameters（传入是否点播等参数）
 **/
- (TalkfunSDKPlayback *)initWithAccessToken:(NSString *)token parameters:(NSDictionary *)parameters;

/**
 *  初始化TalkfunPlayback，需要传入AccessKey和parameters（传入是否点播等参数）
 **/
- (TalkfunSDKPlayback *)initWithAccessKey:(NSString *)accessKey parameters:(NSDictionary *)parameters;

/**
 *  传入appID和appSecret来初始化TalkfunPlayback，parameters参数同上
 **/
- (TalkfunSDKPlayback *)initWithAppID:(NSString *)appID appSecret:(NSString *)appSecret parameters:(NSDictionary *)parameters;
/**
 *  开关日志输出
 *
 **/
- (void)setLogEnable:(BOOL)enable;

/**
 *  设置日志输出等级，默认 TalkfunLoggerLevelAll
 */
- (void)setLogLevel:(TalkfunLoggerLevel)level;

/**
 *  配置摄像头容器（可用于重新设置摄像头容器）
 *
 *  初始化完SDK后即可调用
 **/
- (void)configureCameraContainerView:(UIView *)cameraContainerView;

/**
 *  配置ppt容器（可用于重新设置ppt容器）
 *
 *  初始化完SDK后即可调用
 **/
- (void)configurePPTContainerView:(UIView *)pptContainerView;

/**
 *  配置桌面分享容器(默认是ppt容器)
 *
 *  初始化完SDK后即可调用
 **/
- (void)configureDesktopContainerView:(UIView *)desktopContainerView;

/**
 *  交换ppt容器和摄像头容器，在你切换ppt和摄像头容器的时候调用
 **/
- (void)exchangePPTAndCameraContainer;


/**
 *  监听事件，处理回调数据
 *
 *  监听事件，event为事件名，获取的数据在回调的callback里面
 **/
- (void)on:(NSString *)event callback:(void (^)(id obj))callback;


/**
 *  监听事件，处理回调数据
 *
 *  监听事件，event为事件名，获取的数据在回调的callback里面
 **/
- (void)on:(NSString *)event withCallback:(void (^)(id obj))callback NS_DEPRECATED(2_0, 2_0, 2_0, 2_0, "该方法已过期，请查看TalkfunSDKLive.h头文件");

/**
 *  暂停
 *
 *  点播或者直播都可以暂停，一般只是用于点播的暂停
 **/
- (void)pause;

/**
 *  播放
 *  在暂停之后的播放调用
 **/
- (void)play;

/**
 *  设置播放进度（点播）
 *
 *  点播的时候想seek到某个时间就调用这个方法把时间传进SDK，单位是秒
 **/
- (void)seek:(CGFloat)duration;

/**
 *  进入后台时是否暂停(默认暂停YES)
 **/
- (void)setPauseInBackground:(BOOL)pause;

/**
 *  切换token
 *
 *  当你需要切换accessToken又不销毁SDK时调用，playbackID是离线播放时候用的playbackID，不需要可以传nil
 **/
- (void)configureAccessToken:(NSString * )token playbackID:(NSString *)playbackID;




/**
 *  获取网络列表
 *
 **/
- (void)getNetworkList:(void (^)(id result))callback;

/**
 *  获取网络列表
 *
 **/
- (NSArray *)getNetworkLinesList
NS_DEPRECATED(2_0, 2_0, 2_0, 2_0, "该方法已过期");

/**
 *  设置播放对应的线路(点播)
 *
 *  把相应线路传进SDK
 **/
- (void)setNetworkLine:(NSNumber *)networkLineIndex;


/**
 *  按照时间点获取前后时间区间的聊天记录
 *
 */
- (void)getChatWithDuration:(NSInteger)duration callback:(void (^)(id result))callback;

/**
 *  按照时间点获取前后时间区间的问答记录
 *
 **/
- (void)getQuestionWithDuration:(NSInteger)duration callback:(void (^)(id result))callback;


/**
 *  重新加载SDK
 **/
- (void)reload;

/**
 *  销毁SDK
 *
 *  销毁SDK时调用以便彻底销毁SDK
 **/
- (void)destroy;

@end
