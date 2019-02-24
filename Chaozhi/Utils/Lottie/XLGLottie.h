//
//  XLGLottie.h
//  Chaozhi
//  Notes：json动画封装类
//
//  Created by Jason_hzb on 2018/6/7.
//  Copyright © 2018年 小灵狗出行. All rights reserved.
//

#import <Lottie/Lottie.h>

typedef NS_ENUM(NSInteger,LottieType){
    
    _LOTTIE_LOADING_, //加载动画
};

@interface XLGLottie : NSObject

@property (nonatomic, retain) LOTAnimationView *animation;

+ (instancetype)shared;

- (void)showWithType:(LottieType)type;

- (void)dismiss;

@end
