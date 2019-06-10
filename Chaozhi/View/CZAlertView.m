//
//  CZAlertView.m
//  Chaozhi
//
//  Created by zhanbing han on 2019/6/10.
//  Copyright © 2019 Jason_hzb. All rights reserved.
//

#import "CZAlertView.h"

@interface CZAlertView()
{
    UILabel *titleLab;
    UILabel *_contentLab;
     UIView *bgView; //模糊弹框背景视图
    
}
@property (nonatomic,copy) NSString *topTitle;
@property (nonatomic,copy) NSString *version;
@property (nonatomic,retain) NSString *textStr;
@property (nonatomic,copy) NSString *leftTitle;
@property (nonatomic,copy) NSString *rigthTitle;
@end

@implementation CZAlertView
-(instancetype)init {
    self = [super init];
    if (self) {
        [self setupView];
    }
    return self;
}

- (id)initWithTitle:(NSString *)topTitle content:(NSString *)textStr leftButtonTitle:(NSString *)leftBtnTitle rightButtonTitle:(NSString *)rigthBtnTitle {
    CGRect frame = CGRectMake(0, 0, WIDTH , HEIGHT);
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.zPosition = 2000;
        self.tag = 9999;
        self.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.3];
        [[UIApplication sharedApplication].keyWindow addSubview:self];
        self.textStr = [NSString stringWithFormat:@"感谢您加入超职教育大家庭！\n我们依据相关的法律法规要求，特向您推送本提示。超职教育一直致力于为学员提供良好的服务和品质的教学。为了更好的确认服务的内容和双方的权利、义务，您需要阅读我们完整的《%@·协议》\n(点击链接)，谢谢配合。",textStr];
        self.leftTitle = leftBtnTitle;
        self.rigthTitle = rigthBtnTitle;
        self.topTitle = topTitle;
        [self setupView];//初始化视图（新）
    }
    return self;
}


- (void)setupView {
    bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, autoScaleW(280) , 0)];
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.layer.cornerRadius = 10;
    bgView.clipsToBounds = YES;
    [self addSubview:bgView];
    
    CGRect titleFrame = CGRectMake(0, 10, bgView.width, autoScaleW(30));
    UILabel *titleLab = [[UILabel alloc] initWithFrame:titleFrame];
    titleLab.text = self.topTitle;
    titleLab.textColor = kBlack55Color;
    titleLab.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];;
    titleLab.textAlignment = NSTextAlignmentCenter;
    [bgView addSubview:titleLab];
    
    CGFloat height = [self.textStr getTextHeightWithFont:[UIFont systemFontOfSize:autoScaleW(15)] width:bgView.width-45];
    _contentLab = [[UILabel alloc] initWithFrame:CGRectMake(20, titleLab.bottom+autoScaleW(10), bgView.width-40, height+10)];
    _contentLab.numberOfLines = 0;
    _contentLab.text = self.textStr;
    _contentLab.font = [UIFont systemFontOfSize:autoScaleW(14.5)];
    _contentLab.textColor =  kBlackColor;;
    [bgView addSubview:_contentLab];
    
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.lineSpacing = 3;
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    [attributes setObject:paragraphStyle forKey:NSParagraphStyleAttributeName];
    NSRange makeR = [self.textStr rangeOfString:@"(点击链接)"];
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc]initWithString:self.textStr attributes:attributes];
        [attributeStr addAttribute:NSForegroundColorAttributeName value:RGBValue(0x00991ff) range:makeR];
    _contentLab.attributedText = attributeStr;
    [_contentLab sizeToFit];
    _contentLab.width = bgView.width-40;
    height = bgView.height;
    _contentLab.textAlignment = NSTextAlignmentCenter;
    
    UIButton *sender = [[UIButton alloc]initWithFrame:CGRectMake(20, _contentLab.bottom-30, _contentLab.width/2.0, 30)];
    [sender addTarget:self action:@selector(urlclickAction:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:sender];
      
    
    CGFloat btnWidth = self.leftTitle.length==0?(bgView.frame.size.width - autoScaleW(18)*2):(bgView.frame.size.width - autoScaleW(18)*3)/2.0;
    CGFloat leftSpace = autoScaleW(18);
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(leftSpace, _contentLab.bottom+autoScaleW(28), btnWidth, autoScaleW(40))];
    cancelBtn.userInteractionEnabled = YES;
    [cancelBtn setTitle:self.leftTitle forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:autoScaleW(15)];
    [cancelBtn addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn setTitleColor:kBlackColor forState:UIControlStateNormal];
    cancelBtn.layer.borderColor = RGBValue(0xdedede).CGColor;
    cancelBtn.layer.borderWidth = 1;
    cancelBtn.layer.cornerRadius = cancelBtn.height/2.0;
    cancelBtn.layer.masksToBounds = YES;
    [bgView addSubview:cancelBtn];
    
    UIButton *doneBtn = [[UIButton alloc] initWithFrame:CGRectMake(cancelBtn.right+leftSpace, cancelBtn.top, btnWidth, cancelBtn.height)];
    [doneBtn setTitle:self.rigthTitle forState:UIControlStateNormal];
    doneBtn.titleLabel.font = [UIFont systemFontOfSize:autoScaleW(15)];
    [doneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    doneBtn.backgroundColor = AppThemeColor;
    doneBtn.cornerRadius = doneBtn.height/2.0;
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

#pragma mark - 确定点击
- (void)doneAction:(id)sender {
    [self dismissAlert];
    self.hidden = YES;
    if (self.doneBlock) {
        self.doneBlock();
    }
}

#pragma mark - 取消点击
- (void)cancelAction:(id)sender {
    if (self.cancelBlock) {
        self.cancelBlock();
    }
    [self dismissAlert];
}

#pragma mark - 取消点击
- (void)urlclickAction:(UIButton *)sender{
    if (self.urlClickBlock) {
        self.urlClickBlock();
    }
    [self dismissAlert];
}

#pragma mark - 页面消失
- (void)dismissAlert
{
    [UIView animateWithDuration:0.0 animations:^{
        self->bgView.alpha = 0;
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
