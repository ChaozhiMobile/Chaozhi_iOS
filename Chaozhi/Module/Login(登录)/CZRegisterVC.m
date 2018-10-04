//
//  CZRegisterVC.m
//  Chaozhi
//
//  Created by Jason_zyl on 2018/9/22.
//  Copyright © 2018年 Jason_hzb. All rights reserved.
//

#import "CZRegisterVC.h"

@interface CZRegisterVC ()

@end

@implementation CZRegisterVC

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
                         @"reg", @"type",
                         nil];
    [[NetworkManager sharedManager] postJSON:URL_PhoneCaptcha parameters:dic imageDataArr:nil imageName:nil  completion:^(id responseData, RequestState status, NSError *error) {
        
        if (status == Request_Success) {
            [Utils showToast:@"验证码发送成功"];
        } else {
            [Utils showToast:@"验证码发送失败"];
        }
    }];
}

// 注册
- (IBAction)registerAction:(id)sender {
    
    if ([NSString isEmpty:self.phoneTF.text]) {
        [Utils showToast:@"请输入手机号"];
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
    
    if ([NSString isEmpty:self.pswTF.text]) {
        [Utils showToast:@"请设置登录密码"];
        return;
    }
    
    if ([NSString isEmpty:self.rePswTF.text]) {
        [Utils showToast:@"请再次输入登录密码"];
        return;
    }
    
    if ([NSString isEmpty:self.nameTF.text]) {
        [Utils showToast:@"请输入您的姓名"];
        return;
    }
    
    if (![self.pswTF.text isEqualToString:self.rePswTF.text]) {
        [Utils showToast:@"输入的密码不一致"];
        return;
    }
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         self.phoneTF.text, @"phone",
                         self.codeTF.text, @"captcha",
                         self.pswTF.text, @"password",
                         self.nameTF.text, @"name",
                         nil];
    [[NetworkManager sharedManager] postJSON:URL_Reg parameters:dic imageDataArr:nil imageName:nil  completion:^(id responseData, RequestState status, NSError *error) {
        
        if (status == Request_Success) {
            [Utils showToast:@"注册成功"];

            NSString *token = responseData[@"token"];
            [CacheUtil saveCacher:@"token" withValue:token];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kLoginSuccNotification object:nil];
            
            // 跳转到首页
            [self.navigationController popToRootViewControllerAnimated:YES];
        } else {
            [Utils showToast:@"注册失败"];
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
