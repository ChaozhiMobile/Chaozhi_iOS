//
//  TalkfunSDKRtcPch.h
//  smallClassSDK
//
//  Created by 莫瑞权 on 2019/2/13.
//  Copyright © 2019年 莫瑞权. All rights reserved.
//

#import <Foundation/Foundation.h>
extern NSString * const TALKFUN_EVENT_RTC_ROOM_INIT;//讲师初始化完成
extern NSString * const TALKFUN_EVENT_RTC_APPLY;//有人申请

extern NSString * const TALKFUN_EVENT_RTC_CANCEL;//有人取消申请申请


extern NSString * const TALKFUN_EVENT_RTC_START;//直播开始
extern NSString * const TALKFUN_EVENT_RTC_STOP;//直播结束


//---------------------------

extern NSString * const TALKFUN_EVENT_RTC_OPEN;             //开启讲台模式
extern NSString * const TALKFUN_EVENT_RTC_CLOSE;            //关闭讲台模式

extern NSString * const TALKFUN_EVENT_RTC_USER_UP;           //允许上讲台
extern NSString * const TALKFUN_EVENT_RTC_KICK;                //踢下讲台
extern NSString * const TALKFUN_EVENT_RTC_DOWN;                //有人主动下讲台

extern NSString * const TALKFUN_EVENT_RTC_OPEN_VIDEO;          //打开摄像头
extern NSString * const TALKFUN_EVENT_RTC_CLOSE_VIDEO;         //关闭摄像头

extern NSString * const TALKFUN_EVENT_RTC_OPEN_AUDIO;            //打开麦克风
extern NSString * const TALKFUN_EVENT_RTC_CLOSE_AUDIO;            //关闭麦克风

extern NSString * const TALKFUN_EVENT_RTC_DRAW_ENABLE;           //打开画线权限
extern NSString * const TALKFUN_EVENT_RTC_DRAW_DISABLE;          //关闭画线权限

extern NSString * const TALKFUN_EVENT_RTC_AWARD ;                //奖励
extern NSString * const TALKFUN_EVENT_LIVE_DURATION ;         //直播时长
extern NSString * const TALKFUN_EVENT_RTC_OFFLINE ;                //用户掉线

extern NSString * const TALKFUN_EVENT_RTC_CONNECTIONINTERRUPTED ;          //频道连接断开
extern NSString * const TALKFUN_EVENT_RTC_RE_CNNECT ;                      //重新加入频道成功
typedef NS_ENUM(NSInteger,TalkfunApplyStatus) {
    // 未申请 NoApply
    TalkfunApplyStatusNoApply = 0,
    // 已经申请上讲台
    TalkfunApplyStatusApplying    = 1,
    // 讲台上
    TalkfunApplyStatusAllow = 2,
};
typedef NS_ENUM(NSInteger,TalkfunMediaPower) {
    //老师操作关闭设备
    TalkfunMediaPowerCloseForZHUBO     = 0,
    //老师操作打开设备
    TalkfunMediaPowerOpenForZHUBO      = 1,
    //学员操作关闭设备
    TalkfunMediaPowerCloseForUser     = 10,
    //学员操作打开设备
    TalkfunMediaPowerOpenForUser      = 11,
    
};


typedef NS_ENUM(NSInteger,TalkfunLiveModel) {
    //大班
    TalkfunLiveModelNormal     = 3,
    //小班
    TalkfunLiveModelLiveRtc    = 5,
    //混合
    TalkfunLiveModelLiveMix    = 6
    
};
typedef NS_ENUM(NSInteger,TalkfunRTCStatus) {
    //关闭
    TalkfunRTCStatusClose      = 0,
    //开启
    TalkfunRTCStatusOpen      = 1
    
};

typedef NS_ENUM(NSInteger, TalkfunRTCLiveState)
{
     TalkfunRTCLiveStateStop,          //结束状态
     TalkfunLiveRTCStateStart,         //开始状态

};
@interface TalkfunSDKRtcPch : NSObject
@end


