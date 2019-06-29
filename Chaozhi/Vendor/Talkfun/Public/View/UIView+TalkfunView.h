//
//  UIView+TalkfunView.h
//  TalkfunSDKDemo
//
//  Created by 孙兆能 on 2016/11/19.
//  Copyright © 2016年 talk-fun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (TalkfunView)

- (id)initShadowViewWithFrame:(CGRect)frame;

- (id)initExpressionViewWithFrame:(CGRect)frame target:(id)target action:(SEL)action;

- (id)initBtnViewWithFrame:(CGRect)frame target:(id)target action:(SEL)action btnNames:(NSArray *)btnNames;

- (id)initSelectViewWithFrame:(CGRect)frame;

@end
