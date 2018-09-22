//
//  XLGAlertView.m
//  Chaozhi
//  Notes：
//
//  Created by Jason_hzb on 2018/5/29.
//  Copyright © 2018年 小灵狗出行. All rights reserved.
//

#import "XLGAlertView.h"

@interface XLGAlertView ()
{
    UIView *bgView; //模糊弹框背景视图
}
@end

@implementation XLGAlertView

- (id)initWithContentText:(NSString *)textStr
          leftButtonTitle:(NSString *)leftTitle
         rightButtonTitle:(NSString *)rigthTitle
           TopButtonTitle:(NSString *)topTitle{
    
    CGRect frame = CGRectMake(0, 0, WIDTH, HEIGHT);
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.2];
        [[UIApplication sharedApplication].keyWindow addSubview:self];
        
        self.textStr = textStr;
        self.leftTitle = leftTitle;
        self.rigthTitle = rigthTitle;
        self.topTitle = topTitle;
        
        [self initView]; //初始化视图
    }
    return self;
}

#pragma mark - 初始化视图
- (void)initView {
    
    bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, autoScaleW(280) , 0)];
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.layer.cornerRadius = 10;
    bgView.clipsToBounds = YES;
    [self addSubview:bgView];
    
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, autoScaleH(18), autoScaleW(280), autoScaleW(40))];
    titleLab.text = self.topTitle;
    titleLab.textColor = RGBValue(0x818181);;
    titleLab.font = [UIFont systemFontOfSize:autoScaleW(18)];
    titleLab.textAlignment = NSTextAlignmentCenter;
    [bgView addSubview:titleLab];
    
    CGFloat contentHeight = autoScaleH(5);
    CGFloat height = [self.textStr getTextHeightWithFont:[UIFont systemFontOfSize:autoScaleW(14)] width:autoScaleW(226)];
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(autoScaleW(280)/2-autoScaleW(226)/2, titleLab.bottom+contentHeight, autoScaleW(226), height)];
    [lab setTextAlignment:NSTextAlignmentCenter];
    lab.numberOfLines = 0;
    lab.text = self.textStr;
    lab.font = [UIFont systemFontOfSize:autoScaleW(14)];
    lab.textColor = RGBValue(0xB4B4B4);
    [bgView addSubview:lab];
    contentHeight += height+5;
    
    
    CGFloat offY = CGRectGetMaxY(lab.frame) + 20;
    
    UIView *rowLine = [[UIView alloc] initWithFrame:CGRectMake(0, offY, bgView.frame.size.width, autoScaleH(1))];
    rowLine.backgroundColor = RGBValue(0x979797);
    rowLine.alpha = 0.0544;
    [bgView addSubview:rowLine];
    
    UIView *colLine = [[UIView alloc] initWithFrame:CGRectMake(bgView.frame.size.width/2, offY, autoScaleW(1), autoScaleH(48))];
    colLine.backgroundColor = RGBValue(0x979797);
    colLine.alpha = 0.0544;
    [bgView addSubview:colLine];
    
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, offY, bgView.frame.size.width/2, autoScaleH(48))];
    if ([self.leftTitle isEqualToString:@""]) {
        colLine.hidden = YES;
        [cancelBtn setFrame:CGRectMake(0, offY, 0, 0)];
    }
    cancelBtn.userInteractionEnabled = YES;
    cancelBtn.backgroundColor = RGBValue(0xF9F9F9);
    [cancelBtn setTitle:self.leftTitle forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:autoScaleW(16)];
    [cancelBtn setTitleColor:RGBValue(0x9F9F9F) forState:UIControlStateNormal];
    cancelBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [cancelBtn addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:cancelBtn];
    
    UIButton *doneBtn = [[UIButton alloc] initWithFrame:CGRectMake(bgView.frame.size.width/2, offY, bgView.frame.size.width/2, autoScaleH(48))];
    if ([self.leftTitle isEqualToString:@""]) {
        [doneBtn setFrame:CGRectMake(0, offY, bgView.frame.size.width, autoScaleH(48))];
    }
    [doneBtn setTitle:self.rigthTitle forState:UIControlStateNormal];
    doneBtn.titleLabel.font = [UIFont systemFontOfSize:autoScaleH(15)];
    [doneBtn setTitleColor:kBlueColor forState:UIControlStateNormal];
    doneBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [doneBtn addTarget:self action:@selector(doneAction:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:doneBtn];
    
    bgView.height = titleLab.bottom+contentHeight+15+autoScaleH(48);
    bgView.center = self.center;
    
    //默认显示动画
    bgView.alpha = 0;
    bgView.centerY = self.centerY+30;
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        self->bgView.centerY = weakSelf.centerY;
        self->bgView.alpha = 1;
    }];
    
    if ([self.topTitle containsString:@"本次会话"]) {
        titleLab.top = autoScaleH(30);
        cancelBtn.left = 10;
        cancelBtn.borderColor = kLineColor;
        cancelBtn.cornerRadius = 5;
        cancelBtn.width =(bgView.width-30)/3;
        
        doneBtn.left = cancelBtn.right+10;
        doneBtn.backgroundColor = kBlueColor;
        doneBtn.cornerRadius = 5;
        doneBtn.width = (bgView.width-30)/3*2;
        [doneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        doneBtn.height = cancelBtn.height;
        bgView.height = titleLab.bottom+contentHeight+15+autoScaleH(48);
        bgView.center = self.center;
    }
    
}

#pragma mark - 取消点击
- (void)cancelAction:(id)sender {
    if (self.cancelBlock) {
        self.cancelBlock();
    }
    
    if (!_dontDissmiss) {
        [self dismissAlert];
    }
}

-(void)setDontDissmiss:(BOOL)dontDissmiss{
    _dontDissmiss=dontDissmiss;
}

#pragma mark - 确定点击
- (void)doneAction:(id)sender {
    if (self.doneBlock) {
        self.doneBlock();
    }
    if (!_dontDissmiss) {
        [self dismissAlert];
    }
}

#pragma mark - 页面消失
- (void)dismissAlert
{
    [UIView animateWithDuration:0.3 animations:^{
        self->bgView.alpha = 0;
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        if (self.dismissBlock) {
            self.dismissBlock();
        }
    }];
}

#pragma mark - 设置弹框动画效果
-(void)setAnimationStyle:(AShowAnimationStyle)animationStyle{
    [bgView setShowAnimationWithStyle:animationStyle];
}

@end
