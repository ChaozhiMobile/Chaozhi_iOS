//
//  TalkfunGuidenceButton.m
//  TalkfunSDKDemo
//
//  Created by Sunzn on 2017/2/10.
//  Copyright © 2017年 talk-fun. All rights reserved.
//

#import "TalkfunGuidenceButton.h"

@implementation TalkfunGuidenceButton

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.imageView.frame = CGRectMake(0, 0, 15, 15);
    self.imageView.center = CGPointMake(40, CGRectGetHeight(self.frame)/2);
    
    self.titleLabel.center = CGPointMake(CGRectGetWidth(self.frame)/2+10, CGRectGetHeight(self.frame)/2);
}

@end
