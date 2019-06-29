//
//  UIView+TalkfunActivityIndicator.h
//  CloudLive
//
//  Created by 孙兆能 on 16/8/24.
//  Copyright © 2016年 Talkfun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (TalkfunActivityIndicator)

- (void)alert:(NSString *)title message:(NSString *)message;
- (void)alertStyle:(UIAlertControllerStyle)preferredStyle title:(NSString *)title message:(NSString *)message action:(UIAlertAction *)action;

//开始动画
- (void)startAnimation;
//结束动画
- (void)stopAnimation;

//是否在动画
- (BOOL)isAnimating;

- (void)toast:(NSString *)string position:(CGPoint)position;
- (void)downloadToast:(NSString *)string position:(CGPoint)position;

- (void)InitWithImage:(UIImage *)image position:(CGPoint)position;


- (UIButton *)getToastBtn;

- (UIImageView*)getToastImageView;

- (void)untoast;
- (BOOL)isToast;

- (UIView *)networkUnusualView;
- (void)removeNetworkUnusualView;

@end

@interface UIView ()

@property (nonatomic, strong) UIAlertController * alertController;

@end
