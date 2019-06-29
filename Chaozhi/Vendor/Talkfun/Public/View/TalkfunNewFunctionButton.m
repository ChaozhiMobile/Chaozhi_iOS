//
//  TalkfunNewFunctionButton.m
//  TalkfunSDKDemo
//
//  Created by 孙兆能 on 2016/12/15.
//  Copyright © 2016年 talk-fun. All rights reserved.
//

#import "TalkfunNewFunctionButton.h"

@implementation TalkfunNewFunctionButton

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.imageView.frame = CGRectMake(0, 0, 30, 30);
    self.imageView.center = CGPointMake(CGRectGetWidth(self.frame)/2, CGRectGetHeight(self.frame)/2);
}

@end
