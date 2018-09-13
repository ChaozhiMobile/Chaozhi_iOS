//
//  XLGLottie.m
//  Chaozhi
//  Notes：
//
//  Created by Jason_hzb on 2018/6/7.
//  Copyright © 2018年 小灵狗出行. All rights reserved.
//

#import "XLGLottie.h"

@implementation XLGLottie

+ (instancetype)shared {
    
    static XLGLottie *instance;
    static dispatch_once_t t;
    
    dispatch_once(&t, ^{
        instance = [[XLGLottie alloc]init];
    });
    return instance;
}

- (void)showWithType:(LottieType)type {
    
    if (type == _LOTTIE_LOADING_) {
        self.animation = [LOTAnimationView animationNamed:@"loading"];//实例化对象
        self.animation.frame =CGRectMake(0, 0, 60, 60);//动画范围
        self.animation.center = [UIApplication sharedApplication].keyWindow.center;
        self.animation.animationSpeed =1;//动画速度
        self.animation.loopAnimation =YES;//是否循环动画
    }
    
    self.animation.cacheEnable = NO;
    self.animation.contentMode =UIViewContentModeScaleToFill;
    [self.animation play];//开始动画
    [[UIApplication sharedApplication].keyWindow addSubview:self.animation];
}

- (void)dismiss {
    
    [self.animation stop];
    [self.animation removeFromSuperview];
}

@end
