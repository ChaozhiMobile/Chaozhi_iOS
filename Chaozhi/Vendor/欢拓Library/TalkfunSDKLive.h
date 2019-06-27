//
//  TalkfunSDKLive.h
//  TalkfunSDKLive
//
//  Created by LuoLiuyou on 2017/7/20.
//  Copyright © 2017年 Talkfun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TalkfunSDKRtc.h"
#import "TalkfunSDK.h"
//SDK代理
@protocol TalkfunSDKLiveDelegate <NSObject>

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

@interface TalkfunSDKLive : NSObject




//代理
@property (nonatomic,weak) id<TalkfunSDKLiveDelegate> delegate;
//获取当前token
@property (nonatomic,copy,readonly) NSString * access_token;
//获取当前播放视频的模式
@property (nonatomic,assign) TalkfunLiveMode liveMode;
//获取视频窗口容器
@property (nonatomic,weak,readonly)   UIView * cameraContainerView;
//获取ppt容器
@property (nonatomic,weak,readonly)   UIView * pptContainerView;
//获取播放桌面分享的容器
@property (nonatomic,weak,readonly)   UIView * desktopContainerView;
//获取视频的播放状态
@property (nonatomic,assign) TalkfunPlayStatus playStatus;

//当前用户信息
@property (nonatomic) NSDictionary *me;

//是否开启cache模式(默认开启)
@property (nonatomic,assign) BOOL cacheSwitch;


//是否开启自动的线路选择 默认为YES
@property (nonatomic) BOOL autoSelectNetwork;

//评分系统是否开启
@property(nonatomic,assign)BOOL evaluate;

//是否切换了摄像头和ppt容器
@property (nonatomic,assign) BOOL isExchanged;
/**
 *  TalkfunLive单例
 **/
+ (TalkfunSDKLive *)shareInstance;

/**
 *  初始化TalkfunLive，需要传入AccessToken和parameters（传入是否点播等参数）
 **/
- (TalkfunSDKLive *)initWithAccessToken:(NSString *)token parameters:(NSDictionary *)parameters;

/**
 *  初始化TalkfunLive，需要传入AccessKey和parameters（传入是否点播等参数）
 **/
- (TalkfunSDKLive *)initWithAccessKey:(NSString *)accessKey parameters:(NSDictionary *)parameters;

/**
 *  传入appID和appSecret来初始化TalkfunLive，parameters参数同上
 **/
- (TalkfunSDKLive *)initWithAppID:(NSString *)appID appSecret:(NSString *)appSecret parameters:(NSDictionary *)parameters;

/**
 *  配置appID和appSecret
 **/
- (void)configureAppID:(NSString *)appID appSecret:(NSString *)appSecret;

/**
 *  开关日志输出
 **/
- (void)setLogEnable:(BOOL)enable;

/**
 *  配置日志输出等级
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
 *  向服务器发送消息，处理回调数据
 *
 *  监听事件，event为事件名，获取的数据在回调的callback里面
 **/
- (void)emit:(NSString *)event parameter:(NSDictionary *)parameter callback:(void (^)(id obj))callback;

/**
 *  向服务器发送消息，处理回调数据
 *
 *  监听事件，event为事件名，获取的数据在回调的callback里面
 **/
- (void)emit:(NSString *)event withParameter:(NSDictionary *)parameter withCallback:(void (^)(id obj))callback NS_DEPRECATED(2_0, 2_0, 2_0, 2_0, "该方法已过期，请查看TalkfunLive.h头文件");

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
 *  进入后台时是否暂停(默认暂停YES)
 **/
- (void)setPauseInBackground:(BOOL)pause;

/**
 *  获取网络列表(根据返回的数据判断是直播或伪直播)
 *
 **/
- (void)getNetworkList:(void (^)(id result))callback;

/**
 *  设置网络获取网络列表(根据是直播或伪直播,设置线路)
 *
 *  把相应网络的key作为operatorID参数传进SDK，key在获取网络列表中得到
 **/
- (void)setNetwork:(NSString *)operatorID  selectedSegmentIndex:(NSInteger)selectedSegmentIndex;


/*
 *  初始化时  默认的清晰度从监听 TALKFUN_EVENT_CURRENT_VIDEO_DEFINITION_LIST 事件获取
 */

/**
 * 获取视频清晰度
 *
 *
 **/
- (NSArray*)getVideoDefinitionList;


//设置视频清晰度
- (void)setVideoDefinition:(NSString*)definition;

/**
 *  切换token
 *
 *  当你需要切换accessToken又不销毁SDK时调用
 **/
- (void)configureAccessToken:(NSString * )token;

/**
 *  获取问答数据
 *
 **/
- (void)getQuestionList:(void (^)(id result))callback;

/**
 *  SDK内部将维护接收聊天消息的队列
 *  设置该队列最大的聊天消息数量，及每秒展示的聊天消息数量
 *  queueSize: 默认 1000
 *  numberHandlePerSecond : 默认 3
 *
 **/
- (void)setChatReceiveQueueMaxSize:(NSInteger)queueSize numberHandlePerSecond:(NSInteger)number;

/**
 *  重新加载SDK
 **/
- (void)reload;


//获取全部投票
-(void)getVotes:(void (^)(id  result))callback;

//获取未收到的投票
-(void)getVotesUnreceived:(void (^)(id  result))callback;

//获取全部的广播
-(void)getBroadcasts:(void (^)(id  result))callback;

//获取未收到的广播
-(void)getBroadcastsUnreceived:(void (^)(id  result))callback;

//设置老师得分
-(void)sendScore:(NSDictionary*)parameter  callback:(void (^)(id  result))callback;



@property (nonatomic, assign)   TalkfunLiveStatus  liveStatus;//直播间状态

@property (nonatomic, strong)   TalkfunSDKRtc *rtcManager;


/**
 *  配置摄像头容器（可用于重新设置摄像头容器）
 *
 *  初始化完SDK后即可调用
 **/


//纯小班初始化sdk
- (TalkfunSDKLive *)initWithAccessToken:(NSString *)token whiteboard:(UIView*)view configureCameraContainerView:(UIView *)cameraContainerView  ;

/**
 *  销毁SDK
 *
 *  销毁SDK时调用以便彻底销毁SDK
 **/
- (void)destroy;
@end
