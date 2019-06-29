//
//  stopCopyTextView.m
//  TalkfunSDKDemo
//
//  Created by moruiwei on 17/3/23.
//  Copyright © 2017年 Talkfun. All rights reserved.
//

#import "stopCopyTextView.h"

@implementation stopCopyTextView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

//- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
//{
//    if (action == @selector(paste:))
//        return NO;
//    return [super canPerformAction:action withSender:sender];
//}

#pragma mark - 禁用所有长按文本框操作
-(BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    [UIMenuController sharedMenuController].menuVisible = NO;  //donot display the menu
    [self resignFirstResponder];                      //do not allow the user to selected anything
    return NO;
}
@end
