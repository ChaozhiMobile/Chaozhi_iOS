//
//  UIImageView+TalkfunImageView.m
//  TalkfunSDKDemo
//
//  Created by 孙兆能 on 2016/11/21.
//  Copyright © 2016年 talk-fun. All rights reserved.
//

#import "UIImageView+TalkfunImageView.h"

@implementation UIImageView (TalkfunImageView)

- (id)initFlowerBubble
{
    self = [[UIImageView alloc] initWithFrame:CGRectMake(37, 3, 12, 12)];
    self.image = [UIImage imageNamed:@"rcircle"];
    return self;
}

- (id)initReturnImageView
{
    self = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    self.image = [UIImage imageNamed:@"goback"];
    return self;
}

@end
