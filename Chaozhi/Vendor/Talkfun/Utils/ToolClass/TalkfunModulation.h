//
//  TalkfunModulation.h
//  TalkfunSDKDemo
//
//  Created by 莫瑞权 on 2019/3/14.
//  Copyright © 2019年 Talkfun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>


@interface TalkfunModulation : NSObject
@property (nonatomic,strong)UISlider* volumeViewSlider ;//系统音量调节

+ (instancetype)shared;
//当前音量
- (float)bfGetCurrentVolume;

//设置音量
- (void)bfSetVolume:(float)newVolume;
@end


