//
//  UILabel+TalkfunLabel.h
//  TalkfunSDKDemo
//
//  Created by 孙兆能 on 2016/11/19.
//  Copyright © 2016年 talk-fun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (TalkfunLabel)

- (id)initRollLabelWithHornButtonFrame:(CGRect)hornButtonFrame;

- (id)initFlowerTipsLabelWithFrame:(CGRect)frame;

- (id)initFlowerNumberLabel;

- (id)initLabelWithFrame:(CGRect)frame text:(NSString *)text font:(UIFont *)font textColor:(UIColor *)textColor;

@end
