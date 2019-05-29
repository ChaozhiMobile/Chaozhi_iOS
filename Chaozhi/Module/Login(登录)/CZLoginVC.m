//
//  CZLoginVC.m
//  Chaozhi
//
//  Created by Jason_zyl on 2018/9/22.
//  Copyright © 2018年 Jason_hzb. All rights reserved.
//

#import "CZLoginVC.h"
#import "JPUSHService.h"

@interface CZLoginVC ()

@end

@implementation CZLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = kWhiteColor;
}

#pragma mark - methods

// 返回
- (void)backAction {
    self.tabBarController.selectedIndex = 0;
    [self.navigationController popViewControllerAnimated:NO];
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
            [Utils changeUserAgent]; //WKWebView UA初始化

            [[NSNotificationCenter defaultCenter] postNotificationName:kLoginSuccNotification object:nil];
            
            // 极光推送绑定别名
            [JPUSHService setTags:nil alias:self.phoneTF.text fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
                
            }];
            
//            // 跳转到首页
//            self.tabBarController.selectedIndex = 0;
//            [self.navigationController popToRootViewControllerAnimated:NO];
            
            //获取用户信息
            NSDictionary *dic = [NSDictionary dictionary];
            [[NetworkManager sharedManager] postJSON:URL_UserInfo parameters:dic imageDataArr:nil imageName:nil  completion:^(id responseData, RequestState status, NSError *error) {
                
                if (status == Request_Success) {
                    //缓存用户信息
                    NSDictionary *userDic = responseData;
                    [[UserInfo share] setUserInfo:[userDic mutableCopy]];
                    
                    [self setTabBarController]; //重置根控制器
                }
            }];
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
