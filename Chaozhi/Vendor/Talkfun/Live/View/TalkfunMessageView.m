//
//  TalkfunMessageView.m
//  TalkfunSDKDemo
//
//  Created by 孙兆能 on 2016/11/23.
//  Copyright © 2016年 talk-fun. All rights reserved.
//

#import "TalkfunMessageView.h"

@implementation TalkfunMessageView

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.liveStatusLabel.text = nil;
    self.zhuboNameLabel.text = nil;
    self.renshuLabel.text = nil;
    self.zhuboNameLabelWidth.constant = 1;
    self.headImageView.layer.cornerRadius = self.headImageView.frame.size.width / 2;
    self.headImageView.clipsToBounds = YES;
    
    [self addObserver:self forKeyPath:@"renshuLabel.text" options:NSKeyValueObservingOptionNew context:nil];
    [self addObserver:self forKeyPath:@"zhuboNameLabel.text" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)roomInit:(id)obj
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"notice" object:nil userInfo:@{@"mess":obj[@"roomInfo"][@"announce"][@"notice"]}];
    //进入房间前老师发过的广播
    NSArray * arr = obj[@"roomInfo"][@"initEvent"];
    for (int i = 0; i < arr.count; i ++) {
        
        NSDictionary * tempDict = arr[i][@"args"];
        if ([tempDict[@"__auto"] isEqualToNumber:@(0)]) {
            continue;
        }
        NSString * mess    = tempDict[@"message"];
        NSString * message = [NSString stringWithFormat:@"公共广播: %@",mess];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"broadcastInfo" object:nil userInfo:@{@"broadcast":message,@"mess":mess}];
    }
    
    self.zhuboNameLabel.text  = obj[@"roomInfo"][@"zhubo"][@"nickname"];
    
    WeakSelf
    //异步获取图片
    dispatch_async(dispatch_queue_create("zhuboImage", DISPATCH_QUEUE_CONCURRENT), ^{
        NSData * data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:obj[@"roomInfo"][@"zhubo"][@"p_150"]]];
        if (data) {
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.headImageView.image = [UIImage imageWithData:data];
            });
        }
    });
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"renshuLabel.text"]) {
        CGRect renshuRect = [self.renshuLabel.text boundingRectWithSize:CGSizeMake(self.frame.size.width, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];
        self.renshuLabelWidth.constant = renshuRect.size.width;
    }
    else if ([keyPath isEqualToString:@"zhuboNameLabel.text"])
    {
        CGRect zhuboRect = [self.zhuboNameLabel.text boundingRectWithSize:CGSizeMake(self.frame.size.width, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];
        self.zhuboNameLabelWidth.constant = zhuboRect.size.width;
    }
}

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"renshuLabel.text"];
    [self removeObserver:self forKeyPath:@"zhuboNameLabel.text"];
}

@end
