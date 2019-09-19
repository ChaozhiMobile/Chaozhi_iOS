//
//  TalkfunLongTextfieldView.m
//  TalkfunSDKDemo
//
//  Created by 孙兆能 on 2016/12/19.
//  Copyright © 2016年 talk-fun. All rights reserved.
//

#import "TalkfunLongTextfieldView.h"

@implementation TalkfunLongTextfieldView

+ (id)initView{
    TalkfunLongTextfieldView * longTextfieldView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil][0];
    return longTextfieldView;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
   
    self.tf.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.tf.layer.borderWidth = 1.0;
    self.tf.layer.cornerRadius = 15;
    self.tf.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 12, 30)];
    self.tf.leftViewMode = UITextFieldViewModeAlways;
    self.tf.rightView = self.sendBtn;
    self.tf.rightViewMode = UITextFieldViewModeAlways;
    self.tf.autocorrectionType = UITextAutocorrectionTypeNo;

    [self.tf setValue:[[UIColor blackColor] colorWithAlphaComponent:0.5] forKeyPath:@"_placeholderLabel.textColor"];
}

- (void)expressionBtnSelected:(BOOL)selected{
    self.expressionBtn.selected = selected;
//    if (selected) {
//        [self.expressionBtn setImage:[UIImage imageNamed:@"键盘"] forState:UIControlStateNormal];
//    }else{
        [self.expressionBtn setImage:[UIImage imageNamed:@"表情"] forState:UIControlStateNormal];
//    }
}

- (UIButton *)sendBtn{
    if (!_sendBtn) {
        _sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _sendBtn.frame = CGRectMake(0, 0, 50, 50);
        [_sendBtn setImage:[UIImage imageNamed:@"send"] forState:UIControlStateNormal];
    }
    return _sendBtn;
}

- (void)dealloc{
    
}

@end
