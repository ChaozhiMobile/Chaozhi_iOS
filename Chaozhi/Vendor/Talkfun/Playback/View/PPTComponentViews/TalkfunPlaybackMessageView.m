//
//  TalkfunPlaybackMessageView.m
//  TalkfunSDKDemo
//
//  Created by 孙兆能 on 2016/11/29.
//  Copyright © 2016年 talk-fun. All rights reserved.
//

#import "TalkfunPlaybackMessageView.h"

@implementation TalkfunPlaybackMessageView

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.lessonTitleLabel.text = nil;
    self.viewsNum.text = nil;
}

- (void)liveInfo:(id)obj
{
    self.lessonTitleLabel.text = obj[@"title"];
    self.viewsNum.text = [NSString stringWithFormat:@"%@次",obj[@"views"]];
}

@end
