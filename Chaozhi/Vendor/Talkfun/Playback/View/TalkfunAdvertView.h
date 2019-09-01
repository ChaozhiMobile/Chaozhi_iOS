//
//  TalkfunAdvertView.h
//  TalkfunSDKDemo
//
//  Created by 莫瑞权 on 2019/8/17.
//  Copyright © 2019 Talkfun. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TalkfunAdvertView : UIView
@property (nonatomic,strong)UIView *videoView;//广告视频
@property (nonatomic,strong)UIButton *back;//返回键
@property (nonatomic,strong)UILabel *secondLabel;//秒

@property (nonatomic,strong)UILabel *firstSecondLabel;

@property (nonatomic,strong)UIButton *prompt;//路过片头
@property (nonatomic,strong)UIButton *fullScreen;//全屏

- (void)setSecond:(NSInteger)duration   playbackID:(NSString *) playbackID;
//开始播放
- (void)advertisingPlayStart:(TalkfunADConfig*)model   playbackID:(NSString *)playbackID;
//广告播放完成
- (void)advertisingPlaybackCompleted:(NSString*)playbackID;

@end

NS_ASSUME_NONNULL_END
