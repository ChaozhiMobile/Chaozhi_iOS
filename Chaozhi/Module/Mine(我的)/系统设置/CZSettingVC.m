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
    
    
}

#pragma mark - methods

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
