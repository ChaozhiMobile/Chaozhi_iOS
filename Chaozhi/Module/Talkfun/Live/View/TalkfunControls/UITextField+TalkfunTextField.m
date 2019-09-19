//
//  UITextField+TalkfunTextField.m
//  TalkfunSDKDemo
//
//  Created by 孙兆能 on 2016/11/19.
//  Copyright © 2016年 talk-fun. All rights reserved.
//

#import "UITextField+TalkfunTextField.h"

@implementation UITextField (TalkfunTextField)

- (id)initChatTFWithFrame:(CGRect)frame
{
    self = [self initWithTitle:@"请输入文字..." image:nil];
    self.font = [UIFont systemFontOfSize:14];
    self.frame = frame;
   
    return self;
}

- (id)initAskTFWithFrame:(CGRect)frame
{
    self = [self initWithTitle:@"请输入文字..." image:nil];
    self.font = [UIFont systemFontOfSize:14];
    self.frame = frame;
    self.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 30)];
    self.leftViewMode = UITextFieldViewModeAlways;
    
    return self;
}

- (id)initLongTFWithFrame:(CGRect)frame
{
    self = [[UITextField alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(frame) - 50, ScreenSize.width, 50)];
    self.backgroundColor = [UIColor whiteColor];
    self.layer.borderWidth = 0.5;
    self.placeholder = @"请输入文字...";
    self.font = [UIFont systemFontOfSize:14];
    self.layer.borderColor = [UIColor lightGrayColor].CGColor;
    return self;
}

-(id)initWithTitle:(NSString *)title image:(UIImage *)image{
    self = [super init];
    if (self) {
        
        self.placeholder = title;
        UIImageView * img = [[UIImageView alloc]initWithImage:image];
        self.rightView = img;
        self.rightViewMode = UITextFieldViewModeAlways;
        [self setBorderStyle:UITextBorderStyleNone];
        self.layer.borderWidth = 0.5;
        self.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.userInteractionEnabled = YES;
    }
    return self;
}

@end
