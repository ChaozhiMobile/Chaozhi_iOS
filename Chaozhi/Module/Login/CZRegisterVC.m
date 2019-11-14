//
//  CZRegisterVC.m
//  Chaozhi
//
//  Created by Jason_zyl on 2018/9/22.
//  Copyright © 2018年 Jason_hzb. All rights reserved.
//

#import "CZRegisterVC.h"
#import "JPUSHService.h"
#import "IMItem.h"
#import "GenerateTestUserSig.h"

@interface CZRegisterVC ()

@end

@implementation CZRegisterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = kWhiteColor;
    self.titleLab.text = [NSString stringWithFormat:@"注册%@账号",kAppName];
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
            
            // WKWebView UA初始化
            [Utils changeUserAgent];
            
            // 极光推送绑定别名
            [JPUSHService setAlias:self.phoneTF.text completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
            } seq:0];
            
            // 腾讯IM登录
            [self loginIM];
            
            // 跳转到首页
            [self.navigationController popToRootViewControllerAnimated:NO];
            self.tabBarController.selectedIndex = 0;
        } else {
            [Utils showToast:@"注册失败"];
        }
    }];
}

- (void)loginIM {
    NSDictionary *dic = [NSDictionary dictionary];
    [[NetworkManager sharedManager] postJSON:URL_IMLogin parameters:dic imageDataArr:nil imageName:nil completion:^(id responseData, RequestState status, NSError *error) {
        if (status == Request_Success) {
            IMItem *item = [IMItem mj_objectWithKeyValues:(NSDictionary *)responseData];
            TIMLoginParam *param = [[TIMLoginParam alloc] init];
            param.identifier = item.accid;
            param.userSig = item.token;
            [[NSUserDefaults standardUserDefaults] setObject:@(imKey()) forKey:Key_UserInfo_Appid];
            [[NSUserDefaults standardUserDefaults] setObject:param.identifier forKey:Key_UserInfo_User];
            [[NSUserDefaults standardUserDefaults] setObject:param.userSig forKey:Key_UserInfo_Sig];
            [[TIMManager sharedInstance] login:param succ:^{
                NSLog(@"腾讯IM登录成功");
            } fail:^(int code, NSString *msg) {
                NSLog(@"腾讯IM登录失败code：%d，msg：%@",code,msg);
            }];
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
