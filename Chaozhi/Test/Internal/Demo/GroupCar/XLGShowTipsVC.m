//
//  XLGShowTipsVC.m
//  Chaozhi
//  Notes：
//
//  Created by MEyo on 2018/6/11.
//  Copyright © 2018年 小灵狗出行. All rights reserved.
//

#import "XLGShowTipsVC.h"

@interface XLGShowTipsVC ()

@property (nonatomic, strong) NSString *titleStr;
@property (nonatomic, strong) NSString *tipsStr;
@property (nonatomic, strong) UIImage *tipsImage;

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UILabel *tipsLabel;
@property (nonatomic, strong) UIImageView *tipsImageView;

@end

@implementation XLGShowTipsVC

- (instancetype)initWithTitle:(NSString *)title tips:(NSString *)tips tipsImage:(UIImage *)image {
    
    self = [super init];
    if (self) {
        self.titleStr = title;
        self.tipsStr = tips;
        self.tipsImage = image;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor colorWithHexString:@"0xF5F5F5"];
    
    [self.view addSubview:self.bgView];
    [self.bgView addSubview:self.tipsImageView];
    [self.bgView addSubview:self.tipsLabel];
    
    @weakify(self);
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        
        make.centerX.and.centerY.mas_equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(255, 290));
    }];
    
    [self.tipsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        
        make.centerX.mas_equalTo(self.bgView);
        make.top.mas_equalTo(self.bgView).offset(54);
        make.size.mas_equalTo(CGSizeMake(150, 150));
    }];
    
    [self.tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerX.mas_equalTo(self.bgView);
        make.top.mas_equalTo(self.tipsImageView.mas_bottom).offset(32);
    }];
    
    self.title = self.titleStr;
    self.tipsImageView.image = self.tipsImage;
    self.tipsLabel.attributedText = [self customLabelText:self.tipsStr];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSMutableAttributedString *)customLabelText:(NSString *)text {
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text attributes:@{NSKernAttributeName:@(3)}];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [text length])];
    
    return attributedString;
}

#pragma mark - Lazy Loading

- (UIView *)bgView {
    
    if (!_bgView) {
        _bgView = [UIView new];
        _bgView.layer.cornerRadius = 5;
        _bgView.backgroundColor = [UIColor colorWithHexString:@"0xFFFFFF"];
    }
    
    return _bgView;
}

- (UILabel *)tipsLabel {
    
    if (!_tipsLabel) {
        _tipsLabel = [[UILabel alloc] init];
        _tipsLabel.font = [UIFont systemFontOfSize:17];
        _tipsLabel.textColor = [UIColor colorWithHexString:@"0x565454"];
    }
    
    return _tipsLabel;
}

- (UIImageView *)tipsImageView {
    
    if (!_tipsImageView) {
        _tipsImageView = [[UIImageView alloc] init];
    }
    
    return _tipsImageView;
}

@end
