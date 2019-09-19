//
//  TalkfunNewTextfieldView.m
//  TalkfunSDKDemo
//
//  Created by 孙兆能 on 2016/12/19.
//  Copyright © 2016年 talk-fun. All rights reserved.
//

#import "TalkfunNewTextfieldView.h"


@interface TalkfunNewTextfieldView ()
@property (strong, nonatomic) UIButton *number;

@end

@implementation TalkfunNewTextfieldView

+ (id)initView{
    TalkfunNewTextfieldView * tfView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil][0];
    tfView.backgroundColor = NEWBLUECOLOR;
    tfView.underlineView.backgroundColor = LIGHTBLUECOLOR;
    tfView.tf.textColor = [UIColor whiteColor];
    
   
    return tfView;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.underlineView.frame = CGRectMake(0, CGRectGetHeight(self.frame)-8, CGRectGetWidth(self.frame)-80-12, 1);
}

- (void)awakeFromNib{
    [super awakeFromNib];
    

    self.tf.rightViewMode = UITextFieldViewModeAlways;
    [self.tf setBorderStyle:UITextBorderStyleNone];
//    self.layer.borderColor = [UIColor lightGrayColor].CGColor;
//    self.layer.borderWidth = 0.5;
    self.tf.font = [UIFont systemFontOfSize:14];
}

- (void)createChatTFView:(id)target action:(SEL)action{
    self.tf.delegate = target;
    self.tf.rightView = self.rightView;
    self.tf.autocorrectionType = UITextAutocorrectionTypeNo;
    [_tf addSubview:self.underlineView];
    [self.sendButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [self.flowerButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

- (void)showSendButton:(BOOL)show
{
    if (show) {
        [self.flowerButton removeFromSuperview];
        [self.rightView addSubview:self.sendButton];
    }else{
        [self.sendButton removeFromSuperview];
        [self.rightView addSubview:self.flowerButton];
    }
}

- (void)expressionBtnSelected:(BOOL)selected{
    self.expressionButton.selected = selected;
//    if (selected) {
//        self.expressionImageView.image = [UIImage imageNamed:@"键盘"];
//    }else{
        self.expressionImageView.image = [UIImage imageNamed:@"表情"];
//    }
}

- (void)flower:(BOOL)flower  number:(NSInteger)number{
    UIImageView * flowerSendImage = self.flowerImageView;
    if (flower) {
        self.number.hidden = NO;
      [self.number setTitle:[NSString stringWithFormat:@"%li",number]  forState:UIControlStateNormal];
        flowerSendImage.image = [UIImage imageNamed:@"鲜花"];
        _hasFlower = YES;
    }else{
         self.number.hidden = YES;
        flowerSendImage.image = [UIImage imageNamed:@"灰色鲜花"];
        _hasFlower = NO;
    }
}

- (UIView *)underlineView
{
    if (!_underlineView) {
        _underlineView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.frame)-8, CGRectGetWidth(self.frame)-80-12, 1)];
        _underlineView.backgroundColor = [UIColor colorWithRed:222/255.0 green:222/255.0 blue:222/255.0 alpha:1];
    }
    return _underlineView;
}

- (UIView *)rightView{
    if (!_rightView) {
        _rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 80, CGRectGetHeight(self.frame))];
        [_rightView addSubview:self.expressionButton];
        [_rightView addSubview:self.flowerButton];
    }
    return _rightView;
}

- (UIButton *)flowerButton
{
    if (!_flowerButton) {
        UIImageView * sendImage      = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 30, 30)];
        sendImage.layer.cornerRadius = 5;
//        sendImage.tag = 555;
        sendImage.contentMode = UIViewContentModeScaleAspectFit;
        sendImage.image              = [UIImage imageNamed:@"灰色鲜花"];
        self.flowerImageView = sendImage;
        _hasFlower = NO;
        _flowerButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _flowerButton.frame = CGRectMake(0+40, 5, 40, 40);
        [_flowerButton addSubview:sendImage];
        
        UIButton *number = [UIButton buttonWithType:UIButtonTypeCustom];
        self.number = number;
        self.number.hidden = YES;
        [number setTitle:@"100" forState:UIControlStateNormal];
        number.frame =CGRectMake(26, 4, 14, 14);
        [number setTitleColor:[UIColor whiteColor]forState:UIControlStateNormal];
        number.titleLabel.font = [UIFont boldSystemFontOfSize:10];
        number.backgroundColor = [UIColor redColor];
        number.layer.cornerRadius = 7;
        [_flowerButton addSubview:number];
    }
    return _flowerButton;
}
- (UIButton *)sendButton
{
    if (!_sendButton) {
        _sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _sendButton.frame = CGRectMake(0+35, 10, 45, 30);
        
        UIImageView * sendImageView      = [[UIImageView alloc] initWithFrame:CGRectMake(3, 0, 40, 30)];
        sendImageView.layer.cornerRadius = 5;
        UILabel * sendLabel              = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
        sendLabel.text                   = @"发送";
        sendLabel.textAlignment          = NSTextAlignmentCenter;
        sendLabel.textColor              = [UIColor whiteColor];
        sendLabel.font                   = [UIFont systemFontOfSize:13];
        [sendImageView addSubview:sendLabel];
        
        sendImageView.backgroundColor    = [UIColor colorWithRed:0 green:178 / 255.0 blue:1 alpha:1];
        [_sendButton addSubview:sendImageView];
    }
    return _sendButton;
}

- (UIButton *)expressionButton
{
    if (!_expressionButton) {
        _expressionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _expressionButton.frame = CGRectMake(0, 5, 40, 40);
        
        self.expressionImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        self.expressionImageView.image = [UIImage imageNamed:@"表情"];
        [_expressionButton addSubview:self.expressionImageView];
    }
    return _expressionButton;
}

@end
