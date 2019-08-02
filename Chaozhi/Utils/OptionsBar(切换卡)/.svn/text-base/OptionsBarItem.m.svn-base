//
//  OptionsBarItem.m
//  SuperMarket
//
//  Created by hanzhanbing on 16/7/15.
//  Copyright © 2016年 柯南. All rights reserved.
//

#import "OptionsBarItem.h"

@interface OptionsBarItem()
@property (nonatomic,weak)UILabel *titleLabel;
@property (nonatomic,weak)UIImageView *lineImageView;
@end

@implementation OptionsBarItem

-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if(self){
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectZero];
        self.titleLabel=label;
        label.textColor=[UIColor blackColor];
        label.textAlignment=NSTextAlignmentCenter;
        label.font=[UIFont systemFontOfSize:15];
        [self addSubview:label];
        
        UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectZero];
        self.lineImageView=imageView;
        [self addSubview:imageView];
    }
    return self;
}

/**
 *  自适应label的尺寸
 *
 *  @param size <#size description#>
 *
 *  @return <#return value description#>
 */
-(CGSize)sizeThatFits:(CGSize)size{
    CGSize result=[self.titleLabel sizeThatFits:size];
    result.width+=30;
    return result;
}

/**
 *  设置title并且设置titleLabel的显示内容
 *
 *  @param title 标题
 */
-(void)setTitle:(NSString *)title{
    _title=title;
    _titleLabel.text=_title;
}

-(void)setTextColor:(UIColor *)textColor {
    _textColor = textColor;
    _titleLabel.textColor = _textColor;
}

-(void)setTextFont:(UIFont *)textFont {
    _textFont = textFont;
    _titleLabel.font = textFont;
}

/**
 *  设置是否添加分割线
 *
 *  @param showSeprateLine 是否添加
 */
-(void)setShowSeprateLine:(BOOL)showSeprateLine{
    if(_showSeprateLine!=showSeprateLine){
        _showSeprateLine=showSeprateLine;
    }
    if(showSeprateLine){
        self.lineImageView.image=[UIImage imageNamed:@"sline_"];
        self.lineImageView.hidden=NO;
    }else{
        self.lineImageView.hidden=YES;
    }
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [self.titleLabel setFrame:self.bounds];
    CGSize size=self.bounds.size;
    CGRect frame = _lineImageView.frame;
    frame.origin.x = size.width - frame.size.width;
    frame.origin.y = 10;
    frame.size.height = size.height - 20;
    frame.size.width=1;
    _lineImageView.frame = frame;
}

@end
