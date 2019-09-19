//
//  TalkfunGuidanceView.m
//  TalkfunSDKDemo
//
//  Created by Sunzn on 2017/2/10.
//  Copyright © 2017年 talk-fun. All rights reserved.
//

#import "TalkfunGuidanceView.h"

@implementation TalkfunGuidanceView

static NSString * noDisplay = @"GuidanceNoDisplay";
- (id)initView{
    BOOL guidanceNoDisplay = [[UserDefault objectForKey:noDisplay] boolValue];
    if (guidanceNoDisplay) {
        return nil;
    }
    TalkfunGuidanceView * gv = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil][0];
    return gv;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    if (IsIPAD) {
        self.useButtonCenterY.constant = 200;
        self.backgroundImageView.image = [UIImage imageNamed:@"平板竖屏 - 引导1"];
    }
}

- (IBAction)beginToUseButton:(UIButton *)sender {
    if (self.noMoreDisplayButton.selected) {
        [UserDefault setObject:@(YES) forKey:noDisplay];
    }
    [self removeFromSuperview];
}
- (IBAction)noMoreDisplayButtonClicked:(TalkfunGuidenceButton *)sender {
    sender.selected = !sender.selected;
    [self.noMoreDisplayButton setImage:[UIImage imageNamed:sender.selected?@"组 103":@"组 102"] forState:UIControlStateNormal];
}

@end
