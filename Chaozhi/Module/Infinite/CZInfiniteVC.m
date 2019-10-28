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
    [self refresh];
    if (self.webView == nil) {
        [self initWebView];
    }
}

#pragma mark - 刷新H5
- (void)refresh {
    if (@available(iOS 9.0, *)) {
        NSSet *websiteDataTypes = [WKWebsiteDataStore allWebsiteDataTypes];
        NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
        [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{
        }];
    } else {
        NSString *libraryPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory,NSUserDomainMask,YES) objectAtIndex:0];
        NSString *cookiesFolderPath = [libraryPath stringByAppendingString:@"/Cookies"];
        NSError *errors;
        [[NSFileManager defaultManager] removeItemAtPath:cookiesFolderPath error:&errors];
    }
    [self.webView removeFromSuperview];
    self.webView = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
