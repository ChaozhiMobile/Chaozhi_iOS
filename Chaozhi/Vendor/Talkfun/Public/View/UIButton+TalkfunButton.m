//
//  UIButton+TalkfunButton.m
//  TalkfunSDKDemo
//
//  Created by 孙兆能 on 2016/11/19.
//  Copyright © 2016年 talk-fun. All rights reserved.
//

#import "UIButton+TalkfunButton.h"

@implementation UIButton (TalkfunButton)

- (id)initButtonWithFrame:(CGRect)frame title:(NSString *)title backgroundColor:(UIColor *)backgroundColor fontSize:(CGFloat)fontSize target:(id)target action:(SEL)action
{
    return [self initButtonWithFrame:frame title:title backgroundColor:backgroundColor fontSize:fontSize target:target action:action cornerRadius:0 alpha:1];
}

- (id)initButtonWithFrame:(CGRect)frame title:(NSString *)title backgroundColor:(UIColor *)backgroundColor fontSize:(CGFloat)fontSize target:(id)target action:(SEL)action cornerRadius:(CGFloat)cornerRadius alpha:(CGFloat)alpha
{
    self = [UIButton buttonWithType:UIButtonTypeCustom];
    self.frame = frame;
    [self setTitle:title forState:UIControlStateNormal];
    self.backgroundColor = [UIColor blackColor];
    self.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    self.layer.cornerRadius = cornerRadius;
    self.alpha = alpha;
    self.clipsToBounds = YES;
    [self addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return self;
}

- (id)initHornButtonWithPPTFrame:(CGRect)PPTFrame
{
    self = [super init];
    if (self) {
        self = [UIButton buttonWithType:UIButtonTypeCustom];
        
        self.frame = CGRectMake(0, CGRectGetMaxY(PPTFrame) - 25, CGRectGetWidth(PPTFrame), 25);
        self.backgroundColor = [UIColor colorWithRed:50 / 255.0 green:50 / 255.0 blue:50 / 255.0 alpha:1];
        self.alpha = 0.9;
        
        //喇叭
        UIView * hornView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, CGRectGetHeight(self.frame))];
        hornView.backgroundColor = [UIColor colorWithRed:50 / 255.0 green:50 / 255.0 blue:50 / 255.0 alpha:1];
        
        UIImageView * hornImage = [[UIImageView alloc] initWithFrame:CGRectMake(hornView.frame.size.width / 2 - 7, hornView.frame.size.height / 2 - 5, 15, 13)];
        hornImage.image = [UIImage imageNamed:@"ico_scroller"];
        hornImage.backgroundColor = [UIColor colorWithRed:50 / 255.0 green:50 / 255.0 blue:50 / 255.0 alpha:1];
        [hornView addSubview:hornImage];
        
        [self addSubview:hornView];
    }
    return self;
}

- (id)initCloseButtonWithHornButtonFrame:(CGRect)hornButtonFrame
{
    //删除按钮
    self = [UIButton buttonWithType:UIButtonTypeCustom];
    self.frame = CGRectMake(hornButtonFrame.size.width - 50, 0, 50, CGRectGetHeight(hornButtonFrame));
    self.backgroundColor = [UIColor colorWithRed:50 / 255.0 green:50 / 255.0 blue:50 / 255.0 alpha:1];
    
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width / 2 - 6, self.frame.size.height / 2 - 6, 12, 12)];
    imageView.image         = [UIImage imageNamed:@"close_button"];
    [self addSubview:imageView];
    
    return self;
}

- (id)initFlowerButton
{
    self = [UIButton buttonWithType:UIButtonTypeCustom];
    self.frame = CGRectMake(0, 0, 60, 40);
    
    UIImageView * sendImage      = [[UIImageView alloc] initWithFrame:CGRectMake(15, 5, 30, 30)];
    sendImage.layer.cornerRadius = 5;
    sendImage.image              = [UIImage imageNamed:@"giveFlower"];
    
    [self addSubview:sendImage];
    
    return self;
}

- (id)initSendButton
{
    self = [UIButton buttonWithType:UIButtonTypeCustom];
    self.frame = CGRectMake(0, 0, 70, 30);
    
    UIImageView * sendImageView      = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
    sendImageView.layer.cornerRadius = 5;
    UILabel * sendLabel              = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
    sendLabel.text                   = @"发送";
    sendLabel.textAlignment          = NSTextAlignmentCenter;
    sendLabel.textColor              = [UIColor whiteColor];
    sendLabel.font                   = [UIFont systemFontOfSize:13];
    [sendImageView addSubview:sendLabel];
    
    sendImageView.backgroundColor    = [UIColor colorWithRed:0 green:178 / 255.0 blue:1 alpha:1];
    [self addSubview:sendImageView];
    
    
    return self;
}

- (id)initAskButton
{
    self = [UIButton buttonWithType:UIButtonTypeCustom];
    self.frame = CGRectMake(0, 0, 70, 40);
    self.tag = 11;
    
    UIImageView * askImage      = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 60, 30)];
    askImage.backgroundColor    = [UIColor colorWithRed:0 green:178 / 255.0 blue:1 alpha:1];
    askImage.layer.cornerRadius = 5;
    
    UILabel * askLabel     = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
    askLabel.text          = @"提问";
    askLabel.textAlignment = NSTextAlignmentCenter;
    askLabel.textColor     = [UIColor whiteColor];
    askLabel.font          = [UIFont systemFontOfSize:13];
    [askImage addSubview:askLabel];
    [self addSubview:askImage];
    
    return self;
}

- (id)initExpressionButton
{
    self = [UIButton buttonWithType:UIButtonTypeCustom];
    self.frame   = CGRectMake(100, 50, 60, 40);
    
    UIImageView *expressionImage       = [[UIImageView alloc] initWithFrame:CGRectMake(15, 5, 30, 30)];
    expressionImage.image = [UIImage imageNamed:@"expression"];
    [self addSubview:expressionImage];
    
    return self;
}

- (id)initReturnButton
{
    self = [UIButton buttonWithType:UIButtonTypeCustom];
    self.frame              = CGRectMake(0, 0, 50, 50);
    self.titleLabel.font    = [UIFont systemFontOfSize:15];
    self.layer.cornerRadius = 20;
    self.alpha              = 0.9;
    self.clipsToBounds      = YES;
    return self;
}

- (id)initDownloadBtnWithFrame:(CGRect)frame target:(id)target action:(SEL)action
{
    self = [UIButton buttonWithType:UIButtonTypeCustom];
    self.frame = frame;
    [self addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    UIImageView * imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"下载-默认"]];
    imageView.frame = CGRectMake(24, CGRectGetHeight(frame)/2.0 - 10, 17, 20);
    [self addSubview:imageView];
    return self;
}

@end
