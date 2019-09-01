//
//  TalkfunSDKPlatform.h
//  TalkfunSDKDemo
//
//  Created by 莫瑞权 on 2018/9/28.
//  Copyright © 2018年 Talkfun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TalkfunWhiteboard.h"
#import "TalkfunSDKRtcPch.h"
@interface TalkfunSDKRtc : NSObject


//申请状态                              ApplyStatus
@property (nonatomic,assign) TalkfunApplyStatus        applyStatus;
//讲台状态
@property (nonatomic,assign) TalkfunRTCStatus        RTCStatus;

@property (nonatomic,strong) TalkfunWhiteboard *whiteboard;

//前后摄像头切换
- (void)switchCamera;

/**
 *   申请上讲台
 **/
- (void)apply:(void (^)(NSDictionary* result))callback;

/**
 *   取消上讲台申请
 **/
- (void)cancel:(void (^)(NSDictionary* result))callback;

/**
 *   主动下讲台
 **/
- (void)down:(void (^)(NSDictionary* result))callback;


/**:   打开摄像头, */
- (void)openVideo:(void (^)(NSDictionary* result))callback;
/**:   关闭摄像头*/
- (void)closeVideo:(void (^)(NSDictionary* result))callback;

/**   打开麦克风*/
- (void)openAudio:(void (^)(NSDictionary* result))callback;
/**   关闭麦克风*/
- (void)closeAudio:(void (^)(NSDictionary* result))callback;

@end


