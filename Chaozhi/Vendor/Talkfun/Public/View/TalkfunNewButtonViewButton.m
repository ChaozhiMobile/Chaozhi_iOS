//
//  TalkfunNewButtonViewButton.m
//  TalkfunSDKDemo
//
//  Created by 孙兆能 on 2016/12/17.
//  Copyright © 2016年 talk-fun. All rights reserved.
//

#import "TalkfunNewButtonViewButton.h"

@implementation TalkfunNewButtonViewButton

- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat width = CGRectGetWidth(self.frame);
    self.imageView.frame = CGRectMake(0, 0, 30-(ScreenSize.width<=320&&width<83?5:0), 30-(ScreenSize.width<=320&&width<83?5:0));
    self.imageView.center = CGPointMake(20+4-(ScreenSize.width<=320&&width<83?10:0), CGRectGetHeight(self.frame)/2);
    self.titleLabel.frame = CGRectMake(0, 0, 50, 20);
    self.titleLabel.center = CGPointMake(CGRectGetWidth(self.frame)/2.0+18+4-(ScreenSize.width<=320&&width<83?2:0), CGRectGetHeight(self.frame)/2.0);
}

@end
