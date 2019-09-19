//
//  UITextField+HTtext.m
//  MTDemo
//
//  Created by air on 15/8/10.
//  Copyright (c) 2015年 Talkfun. All rights reserved.
//

#import "UITextField+HTtext.h"

@implementation UITextField (HTtext)
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
