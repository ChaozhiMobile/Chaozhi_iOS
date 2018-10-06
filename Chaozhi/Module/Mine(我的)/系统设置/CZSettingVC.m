//
//  CZSettingVC.m
//  Chaozhi
//
//  Created by Jason_zyl on 2018/10/6.
//  Copyright © 2018年 Jason_hzb. All rights reserved.
//

#import "CZSettingVC.h"

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
    [BaseWebVC showWithContro:self withUrlStr:@"https://www.baidu.com/" withTitle:@"关于超职教育" isPresent:NO];
}

//修改密码
- (void)changePswAction {
    UIViewController *vc = [Utils getViewController:@"Main" WithVCName:@"CZForgetPswVC"];
    [self.navigationController pushViewController:vc animated:YES];
}

//退出登录
- (IBAction)logoutAction:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:kLogoutSuccNotification object:nil];
    self.tabBarController.selectedIndex = 0;
    [self.navigationController popViewControllerAnimated:NO];
    [Utils logout:NO]; //不跳登录页面
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
