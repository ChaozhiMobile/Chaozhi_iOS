//
//  TalkfunModulation.m
//  TalkfunSDKDemo
//
//  Created by 莫瑞权 on 2019/3/14.
//  Copyright © 2019年 Talkfun. All rights reserved.
//

#import "TalkfunModulation.h"

@implementation TalkfunModulation

#pragma mark - 控制音量
- (void)bfSetVolume:(float)newVolume {
    // 通过控制系统声音 控制音量
    newVolume = newVolume > 1 ? 1 : newVolume;
    newVolume = newVolume < 0 ? 0 : newVolume;
    //ios7
    if (([[[UIDevice currentDevice] systemVersion] floatValue]) >= 7) {
        [self.volumeViewSlider setValue:newVolume animated:NO];
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        // 过期api写在这里不会有警告
        [[MPMusicPlayerController applicationMusicPlayer] setVolume:newVolume];
#pragma clang diagnostic pop
    }
}
- (UISlider*)volumeViewSlider
{
    if (_volumeViewSlider==nil) {
        MPVolumeView *volumeView = [[MPVolumeView alloc] init];
        for (UIView *view in [volumeView subviews]){
            if ([view.class.description isEqualToString:@"MPVolumeSlider"]){
                _volumeViewSlider = (UISlider*)view;
                break;
            }
        }
    }
    
    return _volumeViewSlider;
}
- (float)bfGetCurrentVolume {
    // 通过控制系统声音 控制音量
    if (([[[UIDevice currentDevice] systemVersion] floatValue]) >= 7) {
        if (_volumeViewSlider) {
            return _volumeViewSlider.value;
        }
        MPVolumeView *volumeView = [[MPVolumeView alloc] init];
        for (UIView *view in [volumeView subviews]){
            if ([view.class.description isEqualToString:@"MPVolumeSlider"]){
                _volumeViewSlider = (UISlider*)view;
                break;
            }
        }
        
        // 解决初始状态下获取不到系统音量
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        CGFloat systemVolume = audioSession.outputVolume;
        
        return systemVolume;
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        // 过期api写在这里不会有警告
        return [[MPMusicPlayerController applicationMusicPlayer] volume];
#pragma clang diagnostic pop
    }
}
+ (instancetype)shared
 {
    static TalkfunModulation *s_instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        s_instance = [[self alloc] init];
        
    });
    return s_instance;
}

@end
