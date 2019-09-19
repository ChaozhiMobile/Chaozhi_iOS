//
//  UILabel+TalkfunLabel.m
//  TalkfunSDKDemo
//
//  Created by 孙兆能 on 2016/11/19.
//  Copyright © 2016年 talk-fun. All rights reserved.
//

#import "UILabel+TalkfunLabel.h"

@implementation UILabel (TalkfunLabel)

- (id)initRollLabelWithHornButtonFrame:(CGRect)hornButtonFrame
{
    self = [super init];
    if (self) {
        self = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(hornButtonFrame), CGRectGetHeight(hornButtonFrame))];
        self.text = @"";
        self.font = [UIFont systemFontOfSize:12];
        self.textColor = [UIColor whiteColor];
    }
    return self;
}

- (id)initFlowerTipsLabelWithFrame:(CGRect)frame
{
    self = [[UILabel alloc] initWithFrame:frame];
    self.textAlignment = NSTextAlignmentCenter;
    self.layer.borderWidth = 1;
    self.layer.cornerRadius = 5;
    self.layer.borderColor = [UIColor colorWithRed:225 / 255.0 green:225 / 255.0 blue:225 / 255.0 alpha:1].CGColor;
    self.textColor = [UIColor blackColor];
    self.font = [UIFont systemFontOfSize:12];
    
    UIImageView * flowerCornerImage1 = [[UIImageView alloc] initWithFrame:CGRectMake(100, CGRectGetHeight(self.frame), 10, 5)];
    flowerCornerImage1.image         = [UIImage imageNamed:@"corner_emo"];
    [self addSubview:flowerCornerImage1];
    
    self.hidden      = YES;
    return self;
}

- (id)initFlowerNumberLabel
{
    self = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 12, 12)];
    self.textAlignment = NSTextAlignmentCenter;
    self.textColor     = [UIColor whiteColor];
    self.font          = [UIFont systemFontOfSize:9];
    self.text          = @"3";
    return self;
}

- (id)initLabelWithFrame:(CGRect)frame text:(NSString *)text font:(UIFont *)font textColor:(UIColor *)textColor
{
    self = [[UILabel alloc] initWithFrame:frame];
    self.text = text;
    self.font = font;
    self.textColor = textColor;
    
    return self;
}

@end
