//
//  CZForgetPswVC.m
//  Chaozhi
//
//  Created by Jason_zyl on 2018/9/17.
//  Copyright © 2018年 Jason_zyl. All rights reserved.
//

#import "CZForgetPswVC.h"

@interface CZForgetPswVC ()

@end

@implementation CZForgetPswVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = kWhiteColor;
}

#pragma mark - methods

// 返回
- (void)backAction {
    [self.navigationController popViewControllerAnimated:NO];
}

// 获取验证码
- (IBAction)getCodeAction:(id)sender {
    
    if ([NSString isEmpty:self.phoneTF.text]) {
        [Utils showToast:@"请输入手机号"];
        return;
    }
    
    if (![Utils validateMobile:self.phoneTF.text]) {
        [Utils showToast:@"请输入正确的手机号"];
        return;
    }
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         self.phoneTF.text, @"phone",
                         @"reset", @"type",
                         nil];
    [[NetworkManager sharedManager] postJSON:URL_PhoneCaptcha parameters:dic imageDataArr:nil imageName:nil  completion:^(id responseData, RequestState status, NSError *error) {
        
        if (status == Request_Success) {
            [Utils showToast:@"验证码发送成功"];
        } else {
            [Utils showToast:@"验证码发送失败"];
        }
    }];
}

// 修改密码
- (IBAction)changePswAction:(id)sender {
   
    if ([NSString isEmpty:self.phoneTF.text]) {
        [Utils showToast:@"请输入注册手机号"];
        return;
    }
    
    if (![Utils validateMobile:self.phoneTF.text]) {
        [Utils showToast:@"请输入正确的手机号"];
        return;
    }
    
    if ([NSString isEmpty:self.codeTF.text]) {
        [Utils showToast:@"请输入验证码"];
        return;
    }
    
    if ([NSString isEmpty:self.pswNewTF.text]) {
        [Utils showToast:@"请输入新密码"];
        return;
    }
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         self.phoneTF.text, @"phone",
                         self.codeTF.text, @"captcha",
                         self.pswNewTF.text, @"password",
                         nil];
    [[NetworkManager sharedManager] postJSON:URL_Reset parameters:dic imageDataArr:nil imageName:nil  completion:^(id responseData, RequestState status, NSError *error) {
        
        if (status == Request_Success) {
            [Utils showToast:@"密码找回成功，请重新登录"];
            [self backAction];
        } else {
            [Utils showToast:@"密码找回失败"];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
