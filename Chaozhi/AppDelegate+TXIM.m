//
//  AppDelegate+TXIM.m
//  Chaozhi
//
//  Created by zhanbing han on 2019/10/14.
//  Copyright © 2019 Jason_hzb. All rights reserved.
//

#import "AppDelegate+TXIM.h"
#import <TUIKit.h>


@implementation AppDelegate (TXIM)

- (void)onUserStatus:(NSNotification *)notification
{
    TUIUserStatus status = [notification.object integerValue];
    switch (status) {
        case TUser_Status_ForceOffline:
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"下线通知" message:@"您的帐号于另一台手机上登录。" delegate:self cancelButtonTitle:@"退出" otherButtonTitles:@"重新登录", nil];
            [alertView show];
        }
            break;
        case TUser_Status_ReConnFailed:
        {
            NSLog(@"连网失败");
        }
            break;
        case TUser_Status_SigExpired:
        {
            NSLog(@"userSig过期");
        }
            break;
        default:
            break;
    }
}


/**
 *强制下线后的响应函数委托
 */
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 0){
//        UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
//        LoginController *login = [board instantiateViewControllerWithIdentifier:@"LoginController"];
//        self.window.rootViewController = login;
    }else if(buttonIndex == 1){
        /****此处未提供reLogin接口，而是直接使用保存在本地的数据登录，仅适用于Demo体验版本****/
        NSNumber *appId = [[NSUserDefaults standardUserDefaults] objectForKey:Key_UserInfo_Appid];
        NSString *identifier = [[NSUserDefaults standardUserDefaults] objectForKey:Key_UserInfo_User];
        NSString *userSig = [[NSUserDefaults standardUserDefaults] objectForKey:Key_UserInfo_Sig];
//        if([appId integerValue] == SDKAPPID && identifier.length != 0 && userSig.length != 0){
//            __weak typeof(self) ws = self;
//            TIMLoginParam *param = [[TIMLoginParam alloc] init];
//            param.identifier = identifier;
//            param.userSig = userSig;
//            [[TIMManager sharedInstance] login:param succ:^{
//                if (ws.deviceToken) {
//                    TIMTokenParam *param = [[TIMTokenParam alloc] init];
//                    /* 用户自己到苹果注册开发者证书，在开发者帐号中下载并生成证书(p12 文件)，将生成的 p12 文件传到腾讯证书管理控制台，控制台会自动生成一个证书 ID，将证书 ID 传入一下 busiId 参数中。*/
//                    //企业证书 ID
//                    param.busiId = sdkBusiId;
//                    [param setToken:ws.deviceToken];
//                    [[TIMManager sharedInstance] setToken:param succ:^{
//                        NSLog(@"-----> 上传 token 成功 ");
//                    } fail:^(int code, NSString *msg) {
//                        NSLog(@"-----> 上传 token 失败 ");
//                    }];
//                }
//                ws.window.rootViewController = [self getMainController];
//            } fail:^(int code, NSString *msg) {
//                [[NSUserDefaults standardUserDefaults] setObject:@(0) forKey:Key_UserInfo_Appid];
//                [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:Key_UserInfo_User];
//                [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:Key_UserInfo_Pwd];
//                [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:Key_UserInfo_Sig];
//                ws.window.rootViewController = [self getLoginController];
//            }];
        }
        else{
//            _window.rootViewController = [self getLoginController];
        }
//    }
}

@end
