//
//  CZNotNetAvailableVC.m
//  Chaozhi
//
//  Created by Jason_zyl on 2018/10/29.
//  Copyright © 2018年 Jason_hzb. All rights reserved.
//

#import "CZNotNetAvailableVC.h"
#import "NetworkUtil.h"

@interface CZNotNetAvailableVC ()

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIButton *freshBtn;

@end

@implementation CZNotNetAvailableVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.bgView];
    [self.bgView addSubview:self.imageView];
    [self.bgView addSubview:self.label];
    [self.bgView addSubview:self.freshBtn];
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.centerY.mas_equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(autoScaleW(237), autoScaleW(300)));
    }];
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.bgView);
        make.centerX.mas_equalTo(self.bgView);
        make.size.mas_equalTo(CGSizeMake(autoScaleW(150), autoScaleW(150)));
    }];
    
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.bgView);
        make.top.mas_equalTo(self.imageView.mas_bottom).offset(autoScaleW(20));
    }];
    
    [self.freshBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.bgView);
        make.top.mas_equalTo(self.label.mas_bottom).offset(autoScaleW(11));
        make.size.mas_equalTo(CGSizeMake(autoScaleW(70), autoScaleW(26)));
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)fresh {
    
    [Utils showToast:@"正在连接中"];
    if ([NetworkUtil currentNetworkStatus] != NotReachable) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NetAppearNotify" object:nil];
    }
}

#pragma mark - Lazy Loading

- (UIButton *)freshBtn {
    
    if (!_freshBtn) {
        _freshBtn = [UIButton new];
        [_freshBtn setTitle:@"刷新" forState:UIControlStateNormal];
        [_freshBtn setTitleColor: RGB(180, 180, 180) forState:UIControlStateNormal];
        _freshBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        _freshBtn.layer.cornerRadius = 5;
        _freshBtn.layer.borderColor = RGB(180, 180, 180).CGColor;
        _freshBtn.layer.borderWidth = 1;
        [_freshBtn addTarget:self action:@selector(fresh) forControlEvents:UIControlEventTouchUpInside];
    }
    return _freshBtn;
}

- (UIView *)bgView {
    
    if (!_bgView) {
        _bgView = [UIView new];
    }
    return _bgView;
}

- (UIImageView *)imageView {
    
    if (!_imageView) {
        _imageView = [UIImageView new];
        _imageView.image = [UIImage imageNamed:@"icon_nowifi"];
    }
    return _imageView;
}

- (UILabel *)label {
    
    if (!_label) {
        _label = [UILabel new];
        _label.text = @"哎呀！您和地球失联了 \n 尝试一下刷新";
        _label.numberOfLines = 0;
        _label.textAlignment = NSTextAlignmentCenter;
        _label.font = [UIFont systemFontOfSize:12];
        _label.textColor = RGB(86, 84, 84);
    }
    return _label;
}

@end
