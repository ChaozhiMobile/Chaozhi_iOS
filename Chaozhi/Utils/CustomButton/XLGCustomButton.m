//
//  XLGCustomButton.m
//  SharenGo
//  Notes：
//
//  Created by zhanbing han on 2018/12/13.
//  Copyright © 2018年 小灵狗出行. All rights reserved.
//

#import "XLGCustomButton.h"

@implementation XLGBaseButton

@end

@implementation XLGCustomButton

-(void)awakeFromNib {
    [super awakeFromNib];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    CGRect titleF = self.titleLabel.frame;
    CGRect imageF = self.imageView.frame;
    titleF.origin.x = (self.width-titleF.size.width-imageF.size.width-3)/2.0;
    self.titleLabel.frame = titleF;
    imageF.origin.x = CGRectGetMaxX(titleF)+3;
    self.imageView.frame = imageF;
}

- (void)setImage:(UIImage *)image {
    [self setImage:image forState:UIControlStateNormal];
    [self setImage:image forState:UIControlStateHighlighted];
}

- (id)initShadowButton {
    self = [XLGCustomButton buttonWithType:UIButtonTypeCustom];
    if (self) {
        self.layer.shadowRadius = 5;
        self.layer.shadowColor = AppThemeColor.CGColor;
        self.layer.shadowOpacity = 0.4;
        self.layer.shadowOffset = CGSizeMake(2, 4);
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds = NO;
        self.clipsToBounds = NO;
    }
    return self;
}

@end

@implementation XLGMyButton

-(instancetype)initWithFrame:(CGRect)frame {
  self =  [super initWithFrame:frame];
    if (self) {
        self.layer.cornerRadius = self.height/2.0;
        self.layer.masksToBounds = YES;
        self.layer.borderWidth = 1;
    }
    return self;
}

-(void)setIsSelect:(BOOL)isSelect {
    if (_isSelect!=isSelect) {
        _isSelect = isSelect;
    }
    if (isSelect) {
        self.layer.borderColor = AppThemeColor.CGColor;
        [self setTitleColor:AppThemeColor forState:UIControlStateNormal];
        self.backgroundColor = kWhiteColor;
    }
    else {
        self.layer.borderColor = RGBValue(0xf4f4f4).CGColor;
        [self setTitleColor:kBlackColor forState:UIControlStateNormal];
        self.backgroundColor = kWhiteColor;
    }
}

@end

