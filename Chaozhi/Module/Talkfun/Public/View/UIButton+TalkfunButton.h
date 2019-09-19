//
//  UIButton+TalkfunButton.h
//  TalkfunSDKDemo
//
//  Created by 孙兆能 on 2016/11/19.
//  Copyright © 2016年 talk-fun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (TalkfunButton)

- (id)initButtonWithFrame:(CGRect)frame title:(NSString *)title backgroundColor:(UIColor *)backgroundColor fontSize:(CGFloat)fontSize target:(id)target action:(SEL)action;

- (id)initButtonWithFrame:(CGRect)frame title:(NSString *)title backgroundColor:(UIColor *)backgroundColor fontSize:(CGFloat)fontSize target:(id)target action:(SEL)action cornerRadius:(CGFloat)cornerRadius alpha:(CGFloat)alpha;

- (id)initHornButtonWithPPTFrame:(CGRect)PPTFrame;

- (id)initCloseButtonWithHornButtonFrame:(CGRect)hornButtonFrame;

- (id)initFlowerButton;

- (id)initSendButton;

- (id)initAskButton;

- (id)initExpressionButton;

- (id)initReturnButton;

- (id)initDownloadBtnWithFrame:(CGRect)frame target:(id)target action:(SEL)action;

@end
