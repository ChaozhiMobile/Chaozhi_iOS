//
//  CZInfiniteVC.m
//  Chaozhi
//
//  Created by Jason_zyl on 2018/9/22.
//  Copyright © 2018年 Jason_hzb. All rights reserved.
//

#import "CZInfiniteVC.h"
#import <WebKit/WebKit.h>
#import "BaseWebVC.h"

@interface CZInfiniteVC ()
{
    NSString *_webUrl;
}
@end

@implementation CZInfiniteVC

- (void)viewDidLoad {

    _webUrl = [NSString stringWithFormat:@"%@%@",h5Url(),H5_Infinite];
    self.homeUrl = _webUrl;
    self.webTitle = @"无限";
    self.isPresent = NO;
    
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh) name:kLoginSuccNotification object:nil]; //登录成功通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh) name:kLogoutSuccNotification object:nil]; //退出成功通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh) name:kChangeServerSuccNotification object:nil]; //环境切换成功通知
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.webView == nil) {
        [self initWebView];
    }
    self.webView.frame = CGRectMake(0, kNavBarH, WIDTH, HEIGHT-kNavBarH-kTabBarH-kTabBarSafeH);
}

#pragma mark - 刷新H5
- (void)refresh {
    [self.webView removeFromSuperview];
    self.webView = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
