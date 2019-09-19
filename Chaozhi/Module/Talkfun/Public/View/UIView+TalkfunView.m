//
//  UIView+TalkfunView.m
//  TalkfunSDKDemo
//
//  Created by 孙兆能 on 2016/11/19.
//  Copyright © 2016年 talk-fun. All rights reserved.
//

#import "UIView+TalkfunView.h"

@implementation UIView (TalkfunView)

//#pragma message "Ignoring designated initializer warnings"
#pragma clang diagnostic ignored "-Wobjc-designated-initializers"
- (id)initShadowViewWithFrame:(CGRect)frame
{
    self = [[UIView alloc] initWithFrame:frame];
    self.backgroundColor                = [UIColor whiteColor];
    self.layer.shadowColor              = [UIColor blackColor].CGColor;
    self.layer.shadowOffset             = CGSizeMake(0, 0);
    self.layer.shadowOpacity            = 0.5;
    self.layer.shadowRadius             = 5;
    
    return self;
}

- (id)initExpressionViewWithFrame:(CGRect)frame target:(id)target action:(SEL)action
{
    //TODO:表情View
    NSArray * expressionsArray = ExpressionsArray();
    self = [[UIView alloc] initWithFrame:frame];
    
    self.layer.borderColor = [UIColor colorWithRed:200 / 255.0 green:200 / 255.0 blue:200 / 255.0 alpha:0.5].CGColor;
    self.layer.borderWidth = 1;
    self.clipsToBounds     = NO;
    
    self.backgroundColor   = [UIColor whiteColor];
    self.hidden            = YES;
    
    //创建表情以及设置表情的点击事件
    for (int i = 0; i < expressionsArray.count; i ++) {
        UIButton * btn  = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:expressionsArray[i]] forState:UIControlStateNormal];
        btn.frame       = CGRectMake(i % 5 * 36, i / 5 * 36, 36, 36);
        [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        btn.tag         = 22 + i;
        [self addSubview:btn];
    }
    
    UIImageView * cornerImage = [[UIImageView alloc] initWithFrame:CGRectMake(24, 36 * (expressionsArray.count / 5), 10, 5)];
    cornerImage.image = [UIImage imageNamed:@"corner_emo"];
    
    [self addSubview:cornerImage];
    
    return self;
}

- (id)initBtnViewWithFrame:(CGRect)frame target:(id)target action:(SEL)action btnNames:(NSArray *)btnNames;
{
    
    self                     = [[UIView alloc] initWithFrame:frame];
    self.backgroundColor     = [UIColor whiteColor];
    self.layer.shadowColor   = [UIColor blackColor].CGColor;
    self.layer.shadowOffset  = CGSizeMake(0, 0);
    self.layer.shadowOpacity = 0.5;
    self.layer.shadowRadius  = 5;
    
//    NSArray * btnNames = @[@"聊天",
//                           @"提问",
//                           @"公告",
//                           @"私聊"];
    
//    UIButton *temp;
    for (int i = 0; i < btnNames.count; i ++) {
        UIButton * btn      = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame           = CGRectMake(i * 60, 0, 60, 35);
//        temp = btn;
        [btn setTitle:btnNames[i] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn setTitleColor:[UIColor colorWithRed:150 / 255.0 green:150 / 255.0 blue:150 / 255.0 alpha:1] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithRed:0 green:178 / 255.0 blue:1 alpha:1] forState:UIControlStateSelected];
        btn.tag             = 100 + i;
        [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        
//        if (i == 0) {
//            btn.selected = YES;
//        }
//        if (i == 3) {
//            btn.hidden = YES;
//        }
        UIImageView * rcircleImage = [[UIImageView alloc] initWithFrame:CGRectMake(btn.frame.size.width - 7 - CGRectGetWidth(btn.frame)/60*3, 7, 6, 6)];
        rcircleImage.image         = [UIImage imageNamed:@"rcircle"];
        rcircleImage.tag           = 200 + i;
        rcircleImage.hidden        = YES;
        [btn addSubview:rcircleImage];
        [self addSubview:btn];
    }
    
    return self;
}

- (void)chatMessageCome{
    UIButton * btn             = (UIButton *)[self viewWithTag:100];
    UIImageView * rcircleImage = (UIImageView *)[btn viewWithTag:200];
    if (btn.selected == NO) {
        rcircleImage.hidden = NO;
    }
}

- (void)askMessageCome{
    UIButton * btn             = (UIButton *)[self viewWithTag:101];
    UIImageView * rcircleImage = (UIImageView *)[btn viewWithTag:201];
    if (btn.selected == NO) {
        rcircleImage.hidden = NO;
    }
}

- (void)noticeMessageCome{
    UIButton * btn             = (UIButton *)[self viewWithTag:102];
    UIImageView * rcircleImage = (UIImageView *)[btn viewWithTag:202];
    if (btn.selected == NO) {
        rcircleImage.hidden = NO;
    }
}

- (id)initSelectViewWithFrame:(CGRect)frame
{
    self = [[UIView alloc] initWithFrame:frame];
    self.backgroundColor = [UIColor colorWithRed:0 green:178 / 255.0 blue:1 alpha:1];
    return self;
}

//- (void)dealloc{
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
//}

@end
