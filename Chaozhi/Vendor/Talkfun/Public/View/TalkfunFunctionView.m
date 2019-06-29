//
//  TalkfunFunctionView.m
//  TalkfunSDKDemo
//
//  Created by 孙兆能 on 2016/11/23.
//  Copyright © 2016年 talk-fun. All rights reserved.
//

#import "TalkfunFunctionView.h"

@implementation TalkfunFunctionView

- (void)awakeFromNib
{
    [super awakeFromNib];
//    self.hideCameraButton.hidden = YES;
//    self.exchangeButton.hidden = YES;
//    self.networkSelectButton.hidden = YES;
}

- (void)buttonsAddTarget:(id)target action:(SEL)action
{
    [self.fullScreenButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [self.hideCameraButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [self.exchangeButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [self.networkSelectButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

- (void)liveStart:(BOOL)start
{
    self.hideCameraButton.hidden = !start;
    self.exchangeButton.hidden = !start;
    self.networkSelectButton.hidden = !start;
    if (!start) {
        self.hideCameraButton.selected = NO;
        [self.hideCameraButton setImage:[UIImage imageNamed:@"icon_operation_08"] forState:UIControlStateNormal];
    }
}

@end
