//
//  TalkfunHornView.m
//  TalkfunSDKDemo
//
//  Created by 孙兆能 on 2016/11/23.
//  Copyright © 2016年 talk-fun. All rights reserved.
//

#import "TalkfunHornView.h"

@implementation TalkfunHornView

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.rollLabel.text = nil;
    [self.hornButton addTarget:self action:@selector(hornBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.closeButton addTarget:self action:@selector(closeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)roomInit:(id)obj
{
    id roll = obj[@"roomInfo"][@"announce"][@"roll"];
    if (![roll isKindOfClass:[NSDictionary class]]) {
        self.hidden = YES;
        return ;
    }
    if (obj[@"roomInfo"][@"announce"][@"roll"]) {
        NSString * content = obj[@"roomInfo"][@"announce"][@"roll"][@"content"];
        CGRect rect = [content boundingRectWithSize:CGSizeMake(9999, 25) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil];
        if (rect.size.width > self.frame.size.width) {
            self.rollLabel.frame = CGRectMake(0, 0, rect.size.width, CGRectGetHeight(self.frame));
        }
        self.rollLabel.text = content;
        self.link = obj[@"roomInfo"][@"announce"][@"roll"][@"link"];
    }
    else
    {
//        self.hidden = YES;
    }
    //announce加载动画
    [self rollLabelAddAnimation];
}

//喇叭链接
- (void)hornBtnClicked:(UIButton *)btn
{
    UIApplication * application = [UIApplication sharedApplication];
    if ([application canOpenURL:[NSURL URLWithString:self.link]]) {
        [application openURL:[NSURL URLWithString:self.link]];
        [self.rollLabel.layer removeAllAnimations];
        self.hidden = YES;
    }
    else
    {
        [self rollLabelAddAnimation];
    }
}

- (void)closeBtnClicked:(UIButton *)btn
{
    [self.rollLabel.layer removeAllAnimations];
    self.hidden = YES;
}

//MARK:rollLabel加动画
- (void)rollLabelAddAnimation
{
    //先去除rollLabel的全部动画
    [self.rollLabel.layer removeAllAnimations];
    
    CGRect frame = self.rollLabel.frame;
    frame.origin.x = self.frame.size.width;
    self.rollLabel.frame = frame;
    
    float interval = self.rollLabel.frame.size.width / 35;
    [UIView beginAnimations:@"talkfunAnimation" context:NULL];
    [UIView setAnimationDuration:interval];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationRepeatAutoreverses:NO];
    [UIView setAnimationRepeatCount:9999999];
    
    frame = self.rollLabel.frame;
    frame.origin.x = - self.rollLabel.frame.size.width;
    self.rollLabel.frame = frame;
    [UIView commitAnimations];
}

- (void)announceRoll:(id)obj
{
    if (obj && [obj isKindOfClass:[NSDictionary class]]) {
        WeakSelf
        PERFORM_IN_MAIN_QUEUE(
                              if ([obj[@"duration"] integerValue] == 0) {
                                  weakSelf.hidden = YES;
                                  return ;
                              }
                              NSString * content = obj[@"content"];
                              weakSelf.link = obj[@"link"];
                              CGRect rect = [content boundingRectWithSize:CGSizeMake(9999, 25) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil];
                              if (rect.size.width > weakSelf.frame.size.width) {
                                  weakSelf.rollLabel.frame = CGRectMake(0, 0, rect.size.width, CGRectGetHeight(weakSelf.frame));
                              }
                              weakSelf.rollLabel.text = content;
                              
                              [weakSelf rollLabelAddAnimation];
                              weakSelf.hidden = NO;)
    }else
    {
        self.hidden = YES;
    }
}

@end
