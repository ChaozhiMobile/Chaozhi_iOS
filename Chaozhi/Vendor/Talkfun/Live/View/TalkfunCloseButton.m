//
//  TalkfunCloseButton.m
//  TalkfunSDKDemo
//
//  Created by Sunzn on 2016/12/26.
//  Copyright © 2016年 talk-fun. All rights reserved.
//

#import "TalkfunCloseButton.h"

@implementation TalkfunCloseButton

- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.imageView.frame = CGRectMake(0, 0, 12, 12);
    self.imageView.center = CGPointMake(self.frame.size.width*2/3, self.frame.size.height/2);
}

@end
