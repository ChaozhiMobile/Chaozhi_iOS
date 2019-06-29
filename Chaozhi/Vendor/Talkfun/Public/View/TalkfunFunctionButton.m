//
//  TalkfunFunctionButton.m
//  TalkfunSDKDemo
//
//  Created by 孙兆能 on 2016/11/23.
//  Copyright © 2016年 talk-fun. All rights reserved.
//

#import "TalkfunFunctionButton.h"

@implementation TalkfunFunctionButton

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.imageView.frame = CGRectMake(0, 0, 20, 20);
    self.imageView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
}

@end
