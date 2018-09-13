//
//  XLGLoginTestVC.m
//  Chaozhi
//  Notes：
//
//  Created by Jason on 2018/5/14.
//  Copyright © 2018年 小灵狗出行. All rights reserved.
//

#import "XLGLoginTestVC.h"
#import "XLGLoginTestView.h"
#import "XLGLoginTestViewModel.h"

@interface XLGLoginTestVC ()

@property (nonatomic, strong) XLGLoginTestView *loginView;
@property (nonatomic, strong) XLGLoginTestViewModel *viewModel;
    
@end

@implementation XLGLoginTestVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"登录";
    
    self.viewModel = [[XLGLoginTestViewModel alloc] init];
}

- (void)me_addSubviews {
    
    self.loginView = [[XLGLoginTestView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.loginView];
}
    
- (void)me_bindViewModel {
    
    RAC(self.viewModel, username) = self.loginView.usernameTextField.rac_textSignal;
    RAC(self.viewModel, password) = self.loginView.passwordTextField.rac_textSignal;
    RAC(self.loginView.loginButton, enabled) = [self.viewModel buttonIsValid];
    
    @weakify(self);
    // 监听 Button 点击事件
    [[self.loginView.loginButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self)
        
        [self.view endEditing:YES];
        [self.viewModel login];
    }];
    
    [self.viewModel.successObject subscribeNext:^(id x) {
        [Utils showToast:@"登陆成功"];
    }];
    
    [self.viewModel.failureObject subscribeNext:^(NSString *failMessage) {

    }];
    
    [self.viewModel.errorObject subscribeNext:^(id x) {

    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self.view endEditing:YES];
}

@end
