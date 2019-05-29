//
//  CZSettingVC.m
//  Chaozhi
//
//  Created by Jason_zyl on 2018/10/6.
//  Copyright © 2018年 Jason_hzb. All rights reserved.
//

#import "CZSettingVC.h"
#import "JPUSHService.h"

@interface CZSettingVC ()

@end

@implementation CZSettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"系统设置";
    
    self.switchBtn.on = [Utils getWifi]==1?YES:NO;
    self.versionLab.text = AppVersion;
    
    UITapGestureRecognizer *aboutTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(aboutAction)];
    [self.aboutView addGestureRecognizer:aboutTap];
    
    UITapGestureRecognizer *changePswTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changePswAction)];
    [self.changePswView addGestureRecognizer:changePswTap];
    
    UITapGestureRecognizer *privacyTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(privacyAction)];
    [self.privacyView addGestureRecognizer:privacyTap];
    
    _versionLab.text = [NSString stringWithFormat:@"V%@",AppVersion];
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:_callPhoneBtn.titleLabel.text];;
    [str addAttribute:NSForegroundColorAttributeName value:AppThemeColor range:NSMakeRange(5, _callPhoneBtn.titleLabel.text.length-5)];
    _callPhoneBtn.titleLabel.attributedText = str;
}

#pragma mark - methods

- (IBAction)wifiAction:(id)sender {
    UISwitch *switchBtn = (UISwitch *)sender;
    if (switchBtn.isOn) {
        [Utils setWifi:1];
    } else {
        [Utils setWifi:0];
    }
}

//关于超职教育
- (void)aboutAction {
    [BaseWebVC showWithContro:self withUrlStr:H5_About withTitle:@"关于超职教育" isPresent:NO];
}

//修改密码
- (void)changePswAction {
    UIViewController *vc = [Utils getViewController:@"Main" WithVCName:@"CZForgetPswVC"];
    [self.navigationController pushViewController:vc animated:YES];
}

//隐私协议
- (void)privacyAction {
    [BaseWebVC showWithContro:self withUrlStr:H5_Privacy withTitle:@"超职教育隐私保护指引" isPresent:NO];
}

//拨打客服电话
- (IBAction)callPhoneAction:(UIButton *)sender {
    NSMutableString* str=[[NSMutableString alloc] initWithFormat:@"tel:%@",@"400-6777-098"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

//退出登录
- (IBAction)logoutAction:(id)sender {
    
    [Utils logout:NO]; //不跳登录页面
    // 极光推送清除别名
    [JPUSHService setTags:nil alias:@"" fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
        
    }];
    [self cleanCacheAndCookie];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kLogoutSuccNotification object:nil];
    
//    [self.navigationController popViewControllerAnimated:NO];
//    self.tabBarController.selectedIndex = 0;
    
    [self setTabBarController]; //重置根控制器
    
    [Utils changeUserAgent]; //WKWebView UA初始化
}

/**清除缓存和cookie*/
- (void)cleanCacheAndCookie{
    //清除cookies
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies]){
        [storage deleteCookie:cookie];
    }
    //清除UIWebView的缓存
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    NSURLCache * cache = [NSURLCache sharedURLCache];
    [cache removeAllCachedResponses];
    [cache setDiskCapacity:0];
    [cache setMemoryCapacity:0];
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
