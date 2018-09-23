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
    [self dismissViewControllerAnimated:YES completion:nil];
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
