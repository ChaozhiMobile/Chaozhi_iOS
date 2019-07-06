//
//  TalkfunSDK.h
//  TalkfunSDK
//
//  Created by LuoLiuyou on 2017/7/20.
//  Copyright © 2017年 Talkfun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

extern NSString * const TalkfunSDKVersion;

/**
 *  用户事件（public）
 */
extern NSString * const TALKFUN_EVENT_PLAY;                 //播放
extern NSString * const TALKFUN_EVENT_PAUSE;                //暂停
extern NSString * const TALKFUN_EVENT_STOP;                 //停止
extern NSString * const TALKFUN_EVENT_CAMERA_SHOW;          //摄像头开
extern NSString * const TALKFUN_EVENT_CAMERA_HIDE;          //摄像头关
extern NSString * const TALKFUN_EVENT_DESKTOP_START;        //桌面分享开始
extern NSString * const TALKFUN_EVENT_DESKTOP_STOP;         //桌面分享结束
extern NSString * const TALKFUN_EVENT_DESKTOP_PAUSE;        //桌面分享暂停
extern NSString * const TALKFUN_EVENT_MODE_CHANGE;          //模式切换
extern NSString * const TALKFUN_EVENT_NETWORK_SPEED;        //网络速度
/**
 *  用户事件（live）
 */
extern NSString * const TALKFUN_EVENT_VOTE_NEW;             //投票开始
extern NSString * const TALKFUN_EVENT_VOTE_PUB;             //投票结束
extern NSString * const TALKFUN_EVENT_VOTE_INFO;            //查看投票信息
extern NSString * const TALKFUN_EVENT_VOTE_SUBMIT;          //提交投票
extern NSString * const TALKFUN_EVENT_LOTTERY_START;        //抽奖开始
extern NSString * const TALKFUN_EVENT_LOTTERY_STOP;         //抽奖结束

extern NSString * const TALKFUN_SIGN_NEW;        //签到开始
extern NSString * const TALKFUN_SIGN_END;         //签到结束
extern NSString * const TALKFUN_SIGN_IN;     //提交签到



extern NSString * const TALKFUN_EVENT_BROADCAST;            //广播
extern NSString * const TALKFUN_EVENT_CHAT_DISABLE;         //禁言
extern NSString * const TALKFUN_EVENT_CHAT_DISABLE_ALL;     //全体禁言
extern NSString * const TALKFUN_EVENT_CHAT_SEND;            //信息发送接收
extern NSString * const TALKFUN_EVENT_CHAT_PRIVATE;         //私聊
extern NSString * const TALKFUN_EVENT_FLOWER_SEND;          //送花
extern NSString * const TALKFUN_EVENT_FLOWER_INIT;      //送花初始化
extern NSString * const TALKFUN_EVENT_FLOWER_TOTAL;         //花朵总数
extern NSString * const TALKFUN_EVENT_FLOWER_TIME_LEFT;     //送花剩余时间
extern NSString * const TALKFUN_EVENT_QUESTION_LIST;        //问题列表
extern NSString * const TALKFUN_EVENT_QUESTION_ASK;         //提问
extern NSString * const TALKFUN_EVENT_QUESTION_AUDIT;//通过
extern NSString * const TALKFUN_EVENT_QUESTION_REPLY;       //问题回复
extern NSString * const TALKFUN_EVENT_QUESTION_DELETE;      //问题删除
extern NSString * const TALKFUN_EVENT_MEMBER_JOIN_ME;       //我进入房间
extern NSString * const TALKFUN_EVENT_MEMBER_JOIN_OTHER;    //其他人进入房间
extern NSString * const TALKFUN_EVENT_MEMBER_LEAVE;         //其他人离开房间
extern NSString * const TALKFUN_EVENT_MEMBER_TOTAL;         //房间总人数
extern NSString * const TALKFUN_EVENT_MEMBER_KICK;          //踢人
extern NSString * const TALKFUN_EVENT_MEMBER_FORCEOUT;      //被强迫退出房间
extern NSString * const TALKFUN_EVENT_MEMBER_LIST;          //用户列表
extern NSString * const TALKFUN_EVENT_ANNOUNCE_NOTICE;      //公告
extern NSString * const TALKFUN_EVENT_ANNOUNCE_ROLL;        //滚动公告
extern NSString * const TALKFUN_EVENT_LIVE_WAIT;            //直播未开始
extern NSString * const TALKFUN_EVENT_LIVE_START;           //直播开始
extern NSString * const TALKFUN_EVENT_LIVE_STOP;            //直播结束
extern NSString * const TALKFUN_EVENT_ROOM_INIT;            //房间初始化


extern NSString * const TALKFUN_EVENT_CURRENT_VIDEO_DEFINITION_LIST;        //默认视频清晰度
/**
 *  用户事件（playback）
 */
extern NSString * const TALKFUN_EVENT_VOD_START;            //点播开始
extern NSString * const TALKFUN_EVENT_VOD_STOP;             //点播结束
extern NSString * const TALKFUN_EVENT_VOD_DURATION;         //点播总时长
extern NSString * const TALKFUN_EVENT_VOD_INFO;             //点播信息
extern NSString * const TALKFUN_EVENT_VOD_QUESTION_APPEND;  //追加问题列表
extern NSString * const TALKFUN_EVENT_VOD_QUESTION_REFRESH; //刷新问题列表
extern NSString * const TALKFUN_EVENT_VOD_QUESTION_SCROOL;  //获得问答滚动的索引，必须使用TALKFUN_EVENT_VOD_QUESTION_REFRESH获得的数据列表
extern NSString * const TALKFUN_EVENT_VOD_MESSAGE_APPEND;   //聊天信息列表
extern NSString * const TALKFUN_EVENT_VOD_MESSAGE_REFRESH;  //刷新聊天列表
extern NSString * const TALKFUN_EVENT_VOD_MESSAGE_SCROOL;   //获得聊天滚动的索引，必须使用TALKFUN_EVENT_VOD_MESSAGE_REFRESH获得的数据列表
extern NSString * const TALKFUN_EVENT_VOD_CHAPTER_LIST;     //章节列表

extern NSString * const TALKFUN_EVENT_WHITEOARD_PAGE_FRAME;     //画板当前页的白板与ppt的frame

extern NSString * const TALKFUN_EVENT_SCORE_CONFIG;   //评分配置
/**
 *  用户事件（download）
 */
extern NSString * const TALKFUN_EVENT_DOWNLOAD_STATUS;      //下载状态
extern NSString * const TALKFUN_EVENT_DOWNLOAD_PROGRESS;    //下载进度

//extern NSString * const  TALKFUN_EVENT_INSUFFICIENT_DISK_SPACE_WARNING; //警告磁盘空间不足

/**
 *  广播名
 */
extern NSString * const TalkfunErrorNotification;       //错误信息广播（类型看错误信息类型）


/**
 用户角色
 **/
extern NSString * const TalkfunMemberRoleSpadmin;       //超级管理员(老师)
extern NSString * const TalkfunMemberRoleAdmin;         //管理员(助教)
extern NSString * const TalkfunMemberRoleUser;          //普通用户(学生)
extern NSString * const TalkfunMemberRoleGuest;         //游客

extern int const TalkfunMemberGenderUnknow;             //未知性别
extern int const TalkfunMemberGenderMale;               //男性
extern int const TalkfunMemberGenderFemale;             //女性

extern NSString * const TalkfunPlaybackID;              //点播离线播放的key



@interface TalkfunSDK : NSObject

#ifndef TalkfunError

//错误信息类型
typedef enum {
    //详细错误代码
    TalkfunErrrorCourseIsFinish = 1262,           //课程已结束
    TalkfunErrorAuthenticationFail = 10010,      //鉴权失败,access_token错误或者过期
    
    
    //错误大类
    TalkfunErrorLoadingData = 200000,            //加载数据出错
    TalkfunErrorNetworkDisconnect = 200001,       //网络连接错误
    TalkfunErrorVideoError = 200002,              //视频加载错误
    TalkfunErrorDownloadError = 200003,           //下载错误
    TalkfunErrorLoadingOfflineFileError = 200004,  //加载离线文件错误
    TalkfunErrorConnectionFailedError = 200005,  //socket连接失败
    TalkfunErrorNoMoreSpace = 10035  //房间已满
}TalkfunError;

#endif


//视频加载状态
typedef NS_OPTIONS(NSUInteger, TalkfunPlayerLoadState) {
    TalkfunPlayerLoadStateUnknown        = 0,
    TalkfunPlayerLoadStatePlayable       = 1 << 0,
    TalkfunPlayerLoadStatePlaythroughOK  = 1 << 1, // Playback will be automatically started in this state when shouldAutoplay is YES
    TalkfunPlayerLoadStateStalled        = 1 << 2, // Playback will be automatically paused in this state, if started
};

//视频播放结束原因
typedef NS_ENUM(NSInteger, TalkfunPlayerMovieFinishReason) {
    TalkfunPlayerMovieFinishReasonPlaybackEnded,
    TalkfunPlayerMovieFinishReasonPlaybackError,
    TalkfunPlayerMovieFinishReasonUserExited
};

//状态码
typedef enum{
    
    TalkfunCodeSuccess = 0,
    TalkfunCodeFailed  = -1,
    TalkfunCodeTimeout = -100,
    TalkfunCodeGetDataFail = -101,
    TalkfunCodeWrongPassword = -3,
    TalkfunCodeUnknownError = 1000
    
}TalkfunCode;

//播放状态
typedef enum {
    
    TalkfunPlayStatusStop    = 0,
    TalkfunPlayStatusPlaying = 1,
    TalkfunPlayStatusPause   = 2,
    TalkfunPlayStatusSeeking = 3,
    TalkfunPlayStatusError   = 4
    
}TalkfunPlayStatus;

//视频模式
typedef enum {
    
    TalkfunLiveModeVideo   = 0,
    TalkfunLiveModeDesktop = 2,
    TalkfunLiveModeRTC= 3
}TalkfunLiveMode;

//网络状态
typedef enum {
    
    TalkfunNetworkStatusGood    = 0,
    TalkfunNetworkStatusGeneral = 1,
    TalkfunNetworkStatusBad     = 2
    
}TalkfunNetworkStatus;

//日志输出控制
typedef enum {
    TalkfunLoggerLevelAll = 0,
    TalkfunLoggerLevelLog = 1,
    TalkfunLoggerLevelInfo = 2,
    TalkfunLoggerLevelDebug = 3,
    TalkfunLoggerLevelWarn = 4,
    TalkfunLoggerLevelError = 5,
    TalkfunLoggerLevelFatal = 6,
    TalkfunLoggerLevelNone = 10
}TalkfunLoggerLevel;


typedef enum {
    TalkfunLiveStatusWait  = 0, //直播未开始
    TalkfunLiveStatusStart = 1, //直播开始
    TalkfunLiveStatusStop  = 2, //直播结束
    
}TalkfunLiveStatus;

@end


//#import "TalkfunDownloadManager.h"
