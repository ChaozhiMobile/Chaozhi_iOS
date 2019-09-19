//
//  TalkfunExpressionCloseButton.m
//  TalkfunSDKDemo
//
//  Created by Sunzn on 2017/1/11.
//  Copyright © 2017年 talk-fun. All rights reserved.
//

#import "TalkfunExpressionCloseButton.h"

@implementation TalkfunExpressionCloseButton

- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.imageView.frame = CGRectMake(0, 0, 33, 27);
    self.imageView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
}

@end
