//
//  CZLoginVC.m
//  Chaozhi
//
//  Created by Jason_zyl on 2018/9/22.
//  Copyright © 2018年 Jason_hzb. All rights reserved.
//

#import "CZLoginVC.h"
#import "JPUSHService.h"
#import "NTESLoginManager.h"
#import "NTESService.h"

@interface CZLoginVC ()

@end

@implementation CZLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = kWhiteColor;
    
    self.phoneTF.text = [CacheUtil getCacherWithKey:@"loginPhone"];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(aboutAction)];
    [self.loginIconImgView addGestureRecognizer:tap];
}

#pragma mark - methods

// 返回
- (void)backAction {
    self.tabBarController.selectedIndex = 0;
    [self.navigationController popViewControllerAnimated:NO];
}

// 关于超职教育
- (void)aboutAction {
    [BaseWebVC showWithContro:self withUrlStr:H5_About withTitle:[NSString stringWithFormat:@"关于%@",AppName] isPresent:NO];
}

// 登录
- (IBAction)loginAction:(id)sender {
    
    if ([NSString isEmpty:self.phoneTF.text]) {
        [Utils showToast:@"请输入手机号"];
        return;
    }
    
    if (![Utils validateMobile:self.phoneTF.text]) {
        [Utils showToast:@"请输入正确的手机号"];
        return;
    }
    
    if ([NSString isEmpty:self.pswTF.text]) {
        [Utils showToast:@"请输入密码"];
        return;
    }
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         self.phoneTF.text, @"phone",
                         self.pswTF.text, @"password",
                         nil];
    [[NetworkManager sharedManager] postJSON:URL_Login parameters:dic imageDataArr:nil imageName:nil  completion:^(id responseData, RequestState status, NSError *error) {
        
        if (status == Request_Success) {
            [Utils showToast:@"登录成功"];
            
            NSString *token = responseData[@"token"];
            [CacheUtil saveCacher:@"token" withValue:token];
            [CacheUtil saveCacher:@"loginPhone" withValue:self.phoneTF.text];
            [Utils changeUserAgent]; //WKWebView UA初始化

            [[NSNotificationCenter defaultCenter] postNotificationName:kLoginSuccNotification object:nil];
            
            // 极光推送绑定别名
            [JPUSHService setTags:nil alias:self.phoneTF.text fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
                
            }];
            
            // 云信登录
            NSString *loginAccount = @"31cedba2cec711e9a235080027b68021";
            NSString *loginToken = @"f8ab7a382ebc0394b1187287ab23e7e3";
            [[[NIMSDK sharedSDK] loginManager] login:loginAccount token:loginToken completion:^(NSError * _Nullable error) {
                if (error == nil)
                {
                    NTESLoginData *sdkData = [[NTESLoginData alloc] init];
                    sdkData.account   = loginAccount;
                    sdkData.token     = loginToken;
                    [[NTESLoginManager sharedManager] setCurrentLoginData:sdkData];
                    
                    [[NTESServiceManager sharedManager] start];
                }
                else
                {
                    NSString *toast = [NSString stringWithFormat:@"登录失败 code: %zd",error.code];
                    [Utils showToast:toast];
                }
            }];
            
            // 跳转到首页
            self.tabBarController.selectedIndex = 0;
            [self.navigationController popToRootViewControllerAnimated:NO];
            
        } else {
            [Utils showToast:@"登录失败"];
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
