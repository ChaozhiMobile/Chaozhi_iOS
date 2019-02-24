//
//  XLGAlertView.m
//  SharenGo
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

- (id)initWithTitle:(NSString *)topTitle content:(NSString *)textStr leftButtonTitle:(NSString *)leftBtnTitle rightButtonTitle:(NSString *)rigthBtnTitle {
    CGRect frame = CGRectMake(0, 0, WIDTH, HEIGHT);
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.2];
        [[UIApplication sharedApplication].keyWindow addSubview:self];
        self.textStr = textStr;
        self.leftTitle = leftBtnTitle;
        self.rigthTitle = rigthBtnTitle;
        self.topTitle = topTitle;
//        [self initView]; //初始化视图
        [self setupView];//初始化视图（新）
    }
    return self;
}

- (id)initWithSucc:(BOOL)isSucc content:(NSString *)textStr leftButtonTitle:(NSString *)leftBtnTitle rightButtonTitle:(NSString *)rigthBtnTitle {
    CGRect frame = CGRectMake(0, 0, WIDTH, HEIGHT);
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.2];
        [[UIApplication sharedApplication].keyWindow addSubview:self];
        self.textStr = textStr;
        self.leftTitle = leftBtnTitle;
        self.rigthTitle = rigthBtnTitle;
        self.isSucc = isSucc;
//        [self initView]; //初始化视图
        [self setupViewWithImage];//初始化视图（新）
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
    titleLab.textColor = kBlack55Color;
    titleLab.font = [UIFont systemFontOfSize:autoScaleW(18)];
    titleLab.textAlignment = NSTextAlignmentCenter;
    [bgView addSubview:titleLab];
    
    CGFloat contentHeight = autoScaleH(5);
    CGFloat height = [self.textStr getTextHeightWithFont:[UIFont systemFontOfSize:autoScaleW(14)] width:autoScaleW(226)];
    _contentLab = [[UILabel alloc] initWithFrame:CGRectMake(autoScaleW(280)/2-autoScaleW(226)/2, titleLab.bottom+contentHeight, autoScaleW(226), height)];
    [_contentLab setTextAlignment:NSTextAlignmentCenter];
    
    _contentLab.numberOfLines = 0;
    _contentLab.text = self.textStr;
    _contentLab.font = [UIFont systemFontOfSize:autoScaleW(14)];
    _contentLab.textColor =  RGBValue(0xB4B4B4);;
    if (_leftTitle.length==0) {
        _contentLab.textColor =  ButtonColor;;
    }
    [bgView addSubview:_contentLab];
    contentHeight += height+5;
    
    CGFloat offY = CGRectGetMaxY(_contentLab.frame) + 20;
    
    UIView *rowLine = [[UIView alloc] initWithFrame:CGRectMake(0, offY, bgView.frame.size.width, autoScaleH(1))];
    rowLine.backgroundColor = kLineColor;
    [bgView addSubview:rowLine];
    
    UIView *colLine = [[UIView alloc] initWithFrame:CGRectMake(bgView.frame.size.width/2, offY, autoScaleW(1), autoScaleH(48))];
    colLine.backgroundColor = kLineColor;
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
    [doneBtn setTitleColor:kBlack55Color forState:UIControlStateNormal];
    if (self.leftTitle.length>0) {
        [doneBtn setTitleColor:ButtonColor forState:UIControlStateNormal];
    }
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

- (void)setupView {
    bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, autoScaleW(280) , 0)];
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.layer.cornerRadius = 10;
    bgView.clipsToBounds = YES;
    [self addSubview:bgView];
    
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(10, autoScaleH(18), bgView.width-20, autoScaleW(20))];
    titleLab.text = self.topTitle;
    titleLab.textColor = kBlack55Color;
    titleLab.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];;
    titleLab.textAlignment = NSTextAlignmentCenter;
    [bgView addSubview:titleLab];
    
    CGFloat height = [self.textStr getTextHeightWithFont:[UIFont systemFontOfSize:autoScaleW(15)] width:bgView.width-10];
    _contentLab = [[UILabel alloc] initWithFrame:CGRectMake(5, titleLab.bottom+autoScaleW(20), bgView.width-10, height+5)];
    _contentLab.numberOfLines = 0;
    _contentLab.textAlignment = NSTextAlignmentCenter;
    _contentLab.text = self.textStr;
    _contentLab.font = [UIFont systemFontOfSize:autoScaleW(14.5)];
    _contentLab.textColor =  RGBValue(0x00CF1F);;
    [bgView addSubview:_contentLab];
    
    CGFloat btnWidth = self.leftTitle.length==0?(bgView.frame.size.width - autoScaleW(18)*2):(bgView.frame.size.width - autoScaleW(18)*3)/2.0;
    CGFloat leftSpace = autoScaleW(18);
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(leftSpace, _contentLab.bottom+autoScaleW(28), btnWidth, autoScaleW(40))];
    cancelBtn.userInteractionEnabled = YES;
    [cancelBtn setTitle:self.leftTitle forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:autoScaleW(15)];
    [cancelBtn addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn setTitleColor:RGBValue(0xB5B5B5) forState:UIControlStateNormal];
    cancelBtn.layer.borderColor = RGBValue(0xDEDEDE).CGColor;
    cancelBtn.layer.borderWidth = 1;
    cancelBtn.layer.cornerRadius = 5;
    cancelBtn.layer.masksToBounds = YES;
    [bgView addSubview:cancelBtn];
    
    UIButton *doneBtn = [[UIButton alloc] initWithFrame:CGRectMake(cancelBtn.right+leftSpace, cancelBtn.top, btnWidth, cancelBtn.height)];
    [doneBtn setTitle:self.rigthTitle forState:UIControlStateNormal];
    doneBtn.titleLabel.font = [UIFont systemFontOfSize:autoScaleW(15)];
    [doneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    doneBtn.backgroundColor = ButtonColor;
    doneBtn.cornerRadius = 5;
    [doneBtn addTarget:self action:@selector(doneAction:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:doneBtn];
    
    if (self.leftTitle.length==0) {
        cancelBtn.width = 0;
        doneBtn.left = cancelBtn.left;
    }
    bgView.height = doneBtn.bottom+autoScaleW(16);
    bgView.center = self.center;
    
    //默认显示动画
    bgView.alpha = 0;
    bgView.centerY = self.centerY+30;
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        self->bgView.centerY = weakSelf.centerY;
        self->bgView.alpha = 1;
    }];
}

- (void)setupViewWithImage {
    bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, autoScaleW(280) , 0)];
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.layer.cornerRadius = 10;
    bgView.clipsToBounds = YES;
    [self addSubview:bgView];
    
    UIImageView *succImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, autoScaleH(30), autoScaleW(50), autoScaleW(50))];
    [bgView addSubview:succImgView];
    succImgView.centerX = bgView.width/2.0;
    
    CGFloat height = [self.textStr getTextHeightWithFont:[UIFont systemFontOfSize:autoScaleW(15)] width:bgView.width-10];
    _contentLab = [[UILabel alloc] initWithFrame:CGRectMake(5, succImgView.bottom+autoScaleW(20), bgView.width-10, height+5)];
    _contentLab.numberOfLines = 0;
    _contentLab.textAlignment = NSTextAlignmentCenter;
    _contentLab.text = self.textStr;
    _contentLab.font = [UIFont systemFontOfSize:autoScaleW(14.5)];
    _contentLab.textColor =  RGBValue(0x00CF1F);;
    [bgView addSubview:_contentLab];
    
    CGFloat btnWidth = self.leftTitle.length==0?(bgView.frame.size.width - autoScaleW(18)*2):(bgView.frame.size.width - autoScaleW(18)*3)/2.0;
    CGFloat leftSpace = autoScaleW(18);
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(leftSpace, _contentLab.bottom+autoScaleW(28), btnWidth, autoScaleW(40))];
    cancelBtn.userInteractionEnabled = YES;
    [cancelBtn setTitle:self.leftTitle forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:autoScaleW(15)];
    [cancelBtn addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn setTitleColor:RGBValue(0xB5B5B5) forState:UIControlStateNormal];
    cancelBtn.layer.borderColor = RGBValue(0xDEDEDE).CGColor;
    cancelBtn.layer.borderWidth = 1;
    cancelBtn.layer.cornerRadius = 5;
    cancelBtn.layer.masksToBounds = YES;
    [bgView addSubview:cancelBtn];
    
    UIButton *doneBtn = [[UIButton alloc] initWithFrame:CGRectMake(cancelBtn.right+leftSpace, cancelBtn.top, btnWidth, cancelBtn.height)];
    [doneBtn setTitle:self.rigthTitle forState:UIControlStateNormal];
    doneBtn.titleLabel.font = [UIFont systemFontOfSize:autoScaleW(15)];
    [doneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    doneBtn.backgroundColor = ButtonColor;
    doneBtn.cornerRadius = 5;
    [doneBtn addTarget:self action:@selector(doneAction:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:doneBtn];
    if (self.isSucc) {
        succImgView.image = [UIImage imageNamed:@"app_popup_icon_success"];
        _contentLab.textColor = ButtonColor;
    }
    else {
        _contentLab.textColor = RGBValue(0xE72828);
        succImgView.image = [UIImage imageNamed:@"app_popup_icon_fail"];
    }
    if (self.leftTitle.length==0) {
        cancelBtn.width = 0;
        doneBtn.left = cancelBtn.left;
    }
    bgView.height = doneBtn.bottom+autoScaleW(16);
    bgView.center = self.center;
    
    //默认显示动画
    bgView.alpha = 0;
    bgView.centerY = self.centerY+30;
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        self->bgView.centerY = weakSelf.centerY;
        self->bgView.alpha = 1;
    }];
}

@end
