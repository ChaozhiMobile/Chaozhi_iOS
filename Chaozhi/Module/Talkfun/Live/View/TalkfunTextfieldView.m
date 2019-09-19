//
//  TalkfunTextfieldView.m
//  TalkfunSDKDemo
//
//  Created by 孙兆能 on 2016/11/23.
//  Copyright © 2016年 talk-fun. All rights reserved.
//

#import "TalkfunTextfieldView.h"
#import "UIButton+TalkfunButton.h"
#import "UIImageView+TalkfunImageView.h"
#import "UILabel+TalkfunLabel.h"

@interface TalkfunTextfieldView ()

@property (nonatomic,assign) BOOL isLongTF;

@end

@implementation TalkfunTextfieldView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.myTextField.placeholder = @"请输入文字...";
    self.myTextField.rightViewMode = UITextFieldViewModeAlways;
    [self.myTextField setBorderStyle:UITextBorderStyleNone];
    self.myTextField.backgroundColor = NEWBLUECOLOR;
    self.myTextField.textColor = [UIColor whiteColor];
//    self.myTextField.layer.borderWidth = 0.5;
//    self.myTextField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.myTextField.font = [UIFont systemFontOfSize:14];
}

- (void)createChatTFView:(id)target action:(SEL)action{
    self.myTextField.delegate = target;
    self.myTextField.rightView = self.flowerButton;
    _myTextField.leftView = self.expressionButton;
    _myTextField.leftViewMode = UITextFieldViewModeAlways;
    [_myTextField addSubview:self.underlineView];
    [self.sendButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [self.flowerButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

- (void)createAskTFView:(id)target action:(SEL)action{
    self.myTextField.placeholder = @"我要提问...";
    _myTextField.delegate = target;
    _myTextField.rightView = self.askButton;
    _myTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 12, 30)];
    _myTextField.leftViewMode = UITextFieldViewModeAlways;
    [_myTextField addSubview:self.underlineView2];
    [self.askButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

- (void)createLongTFView:(id)target action:(SEL)action{
    
    self.isLongTF = YES;
    _myTextField.delegate = target;
    [_myTextField addSubview:self.underlineView];
    _myTextField.leftView = self.expressionButton;
    _myTextField.leftViewMode = UITextFieldViewModeAlways;
    _myTextField.rightView = self.flowerButton;
    UIImageView * flowerCornerImage = [[UIImageView alloc] initWithFrame:CGRectMake(25, -5, 10, 5)];
    flowerCornerImage.image = [UIImage imageNamed:@"corner_emo"];
    flowerCornerImage.tag = 444;
    [self.flowerButton addSubview:flowerCornerImage];
    flowerCornerImage.hidden = YES;
    [self.sendButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [self.flowerButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

- (void)showSendButton:(BOOL)show
{
    if (show) {
        self.myTextField.rightView = self.sendButton;
        self.underlineView.frame = CGRectMake(55, 42, CGRectGetWidth(self.frame)-130, 1);
    }else{
        self.myTextField.rightView = self.flowerButton;
        self.underlineView.frame = CGRectMake(55, 42, CGRectGetWidth(self.frame)-120, 1);
    }
}

- (void)askTFFrameChanged{
    _underlineView2.frame = CGRectMake(12, 42, self.frame.size.width - 92, 1);
}

- (void)flowerBubble:(BOOL)show number:(NSString *)number
{
    self.flowerNumLabel.text          = number;
    self.flowerBubbleImageView.hidden = !show;
}

- (void)flowerBubbleCornerImageViewShow:(BOOL)show
{
    //flowerbtn上的角隐藏
    UIView * subView = [self.flowerButton viewWithTag:444];
    if (subView && _isLongTF) {
        subView.hidden = !show;
    }
}

- (UIButton *)flowerButton
{
    if (!_flowerButton) {
        _flowerButton = [[UIButton alloc] initFlowerButton];
        [_flowerButton addSubview:self.flowerBubbleImageView];
    }
    return _flowerButton;
}
- (UIButton *)sendButton
{
    if (!_sendButton) {
        _sendButton = [[UIButton alloc] initSendButton];
    }
    return _sendButton;
}

- (UIImageView *)flowerBubbleImageView
{
    if (!_flowerBubbleImageView) {
        _flowerBubbleImageView = [[UIImageView alloc] initFlowerBubble];
        [_flowerBubbleImageView addSubview:self.flowerNumLabel];
        _flowerBubbleImageView.hidden = YES;
    }
    return _flowerBubbleImageView;
}

- (UILabel *)flowerNumLabel
{
    if (!_flowerNumLabel) {
        _flowerNumLabel = [[UILabel alloc] initFlowerNumberLabel];
    }
    return _flowerNumLabel;
}

- (UIButton *)expressionButton
{
    if (!_expressionButton) {
        _expressionButton = [[UIButton alloc] initExpressionButton];
    }
    return _expressionButton;
}

- (UIView *)underlineView
{
    if (!_underlineView) {
        _underlineView = [[UIView alloc] initWithFrame:CGRectMake(55, 42, CGRectGetWidth(self.frame) - 120, 1)];
        _underlineView.backgroundColor = LIGHTBLUECOLOR;
    }
    return _underlineView;
}

- (UIButton *)askButton
{
    if (!_askButton) {
        _askButton = [[UIButton alloc] initAskButton];
    }
    return _askButton;
}

- (UIView *)underlineView2
{
    if (!_underlineView2) {
        _underlineView2 = [[UIView alloc] initWithFrame:CGRectMake(12, 42, self.frame.size.width - 92, 1)];
        _underlineView2.backgroundColor = LIGHTBLUECOLOR;
    }
    return _underlineView2;
}

@end
