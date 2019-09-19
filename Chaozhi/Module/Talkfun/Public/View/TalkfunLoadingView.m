//
//  TalkfunLoadingView.m
//  TalkfunSDKDemo
//
//  Created by Sunzn on 2017/4/21.
//  Copyright © 2017年 Talkfun. All rights reserved.
//

#import "TalkfunLoadingView.h"
#import "UIImageView+WebCache.h"

@implementation TalkfunLoadingView

+ (id)initView{
    id view = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil][0];
    return view;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    self.tipsBtn.layer.borderWidth = 0.5;
    self.tipsBtn.userInteractionEnabled = NO;
    self.tipsBtn.layer.borderColor = UIColorFromRGBHex(0x687fcd).CGColor;
    self.logoImageView.layer.cornerRadius = CGRectGetWidth(self.logoImageView.frame)/2.;
    self.logoImageView.layer.shadowColor = [UIColor grayColor].CGColor;
    self.logoImageView.layer.shadowOffset = CGSizeMake(0, 0);
    self.logoImageView.layer.shadowOpacity = 0.5;
    self.logoImageView.backgroundColor =[UIColor colorWithRed:231 / 255.0 green:231 / 255.0 blue:231/ 255.0 alpha:1];
//    self.logoImageView.alpha = 0.5;/
    
    // 设置边框 大小
//    self.logoImageView.layer.borderWidth = 1;
//    self.logoImageView.layer.borderColor = [UIColor colorWithRed:47 / 255.0 green:188 / 255.0 blue:240255/ 255.0 alpha:1].CGColor;

//    self.logoImageView.layer.borderWidth = 1;
    
}

- (void)configLogo:(NSString *)logoUrl courseName:(NSString *)name{
    // 6.回到主线程更新UI
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.logoImageView sd_setImageWithURL:[NSURL URLWithString:logoUrl] ];
//        placeholderImage:[UIImage imageNamed:@"欢拓云播"] options:0
        
//        [self.logoImageView sd_setImageWithURL:[NSURL URLWithString:logoUrl] placeholderImage:nil options:0];
 
        self.courseNameLabel.text = name?name:nil;
    });


}

@end
