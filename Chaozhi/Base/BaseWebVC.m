//
//  BaseWebVC.m
//  Chaozhi
//  Notes：
//
//  Created by Jason on 2018/5/7.
//  Copyright © 2018年 小灵狗出行. All rights reserved.
//

#import "BaseWebVC.h"
#import <WebKit/WebKit.h>
#import "WKDelegateController.h"

@interface BaseWebVC ()<WKUIDelegate,WKNavigationDelegate,WKDelegate,UITextFieldDelegate>

@property (strong, nonatomic) WKWebView *webView;
@property (strong, nonatomic) UIProgressView *progressView;
@property (strong, nonatomic) WKUserContentController *userContentController;
/** 返回H5弹框 */
//@property (nonatomic,strong) NSDictionary *alertDic;
@property (nonatomic,assign) BOOL h5TapBack;
@end

@implementation BaseWebVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_webView evaluateJavaScript:@"window.activated && window.activated();" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        NSLog(@"js返回结果%@",result);
    }];
}

/** 传入控制器、url、标题 */
+ (void)showWithContro:(UIViewController *)contro withUrlStr:(NSString *)urlStr withTitle:(NSString *)title isPresent:(BOOL)isPresent {
    BaseWebVC *webVC = [[BaseWebVC alloc] init];
    if (![urlStr containsString:@"http"]) {
        urlStr = [NSString stringWithFormat:@"%@%@",h5Url(),urlStr];
    }
    webVC.homeUrl = urlStr;
    webVC.webTitle = title;
    webVC.isPresent = isPresent;
    
    if (isPresent==YES) {
        [contro presentViewController:webVC animated:YES completion:nil];
    } else {
        webVC.hidesBottomBarWhenPushed = YES;
        [contro.navigationController pushViewController:webVC animated:YES];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([NSString isEmpty:_webTitle]) {
        self.isShowWebTitle = YES;
    }
    
    self.title = _webTitle;
    
    [self.view addSubview:self.progressView];
    [self.view insertSubview:self.webView belowSubview:self.progressView];
    
    [self changeUserAgent];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_homeUrl] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:30]];
}

#pragma mark - 全局修改UserAgent，传token等参数给H5

- (void)changeUserAgent {
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:[NSString isEmpty:[UserInfo share].token]?@"":[UserInfo share].token forKey:@"token"];
    [dic setObject:[Utils getWifi]==YES?@"1":@"0" forKey:@"wifi"];
    NSString *extendStr = [dic jsonStringEncoded];
    
    if (@available(iOS 12.0, *)) {
        NSString *baseAgent = @"Mozilla/5.0 (iPhone; CPU iPhone OS 11_4 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15F79";
        NSString *userAgent = [NSString stringWithFormat:@"%@&&%@",baseAgent, extendStr];
        [self.webView setCustomUserAgent:userAgent];
    }
    
    if (IS_IOS_9) {
        [self.webView evaluateJavaScript:@"navigator.userAgent" completionHandler:^(id result, NSError *error) {
            NSString *oldUA = result;
            if (error) {
                oldUA = [[[UIWebView alloc] init] stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
            }
            NSLog(@"UserAgent：oldUA：%@",oldUA);
            if ([oldUA containsString:@"&&"]) {
                NSArray *array = [oldUA componentsSeparatedByString:@"&&"];
                oldUA = array[0];
            }
            NSString *newUA = [NSString stringWithFormat:@"%@&&%@", oldUA, extendStr];
            [[NSUserDefaults standardUserDefaults] registerDefaults:@{@"UserAgent":newUA, @"User-Agent":newUA}];
            if (@available(iOS 9.0, *)) {
                self.webView.customUserAgent = newUA;
            } else {
                // Fallback on earlier versions
            }
            NSLog(@"UserAgent：newUA：%@",newUA);
        }];
    } else {//适配iOS9以下系统，下面的方法不能少
        NSString *oldUA = [[[UIWebView alloc] init] stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
        NSLog(@"UserAgent：oldUA：%@",oldUA);
        if ([oldUA containsString:@"&&"]) {
            NSArray *array = [oldUA componentsSeparatedByString:@"&&"];
            oldUA = array[0];
        }
        NSString *newUA = [NSString stringWithFormat:@"%@&&%@", oldUA, extendStr];
        [[NSUserDefaults standardUserDefaults] registerDefaults:@{@"UserAgent":newUA}];
        [self.webView setValue:newUA forKey:@"applicationNameForUserAgent"];
        NSLog(@"UserAgent：newUA：%@",newUA);
    }
}

#pragma mark - 懒加载

// 进度条
- (UIProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, kNavBarH, WIDTH, 1)];
        _progressView.hidden = YES;
        _progressView.tintColor = AppThemeColor;
        _progressView.trackTintColor = [UIColor whiteColor];
    }
    return _progressView;
}

// WebView
- (WKWebView *)webView {
    if (!_webView) {
        
        //配置环境
        WKWebViewConfiguration * configuration = [[WKWebViewConfiguration alloc]init];
        configuration.allowsInlineMediaPlayback = true;
        _userContentController =[[WKUserContentController alloc]init];
        configuration.userContentController = _userContentController;
        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, kNavBarH, WIDTH, HEIGHT-kNavBarH-kTabBarSafeH) configuration:configuration];
        _webView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        _webView.backgroundColor = [UIColor whiteColor];
        _webView.navigationDelegate = self;
        _webView.UIDelegate = self;
        _webView.scrollView.decelerationRate = UIScrollViewDecelerationRateNormal;
        if (@available(iOS 11.0, *)) {
            self.webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        
        //KVO 进度及title、滑动距离
        [_webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
        [_webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:nil];
        [_webView.scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];

        //注册方法
        WKDelegateController *delegateController = [[WKDelegateController alloc]init];
        delegateController.delegate = self;
        [_userContentController addScriptMessageHandler:delegateController name:@"return"]; //返回
        [_userContentController addScriptMessageHandler:delegateController name:@"login"]; //登录
        [_userContentController addScriptMessageHandler:delegateController name:@"refresh"]; //刷新
        [_userContentController addScriptMessageHandler:delegateController name:@"open"]; //打开新页面
        [_userContentController addScriptMessageHandler:delegateController name:@"close"]; //关闭当前页面
        [_userContentController addScriptMessageHandler:delegateController name:@"tapBack"]; //返回弹窗提示
    }
    return _webView;
}

#pragma mark - 返回事件

// 返回按钮点击
- (void)backAction {
    
    NSLog(@"打开web页面个数：%lu",(unsigned long)self.webView.backForwardList.backList.count);
    
//    if (_alertDic) {
//        if ([_alertDic[@"type"] isEqualToString:@"alert"]) {
//            NSString *title = _alertDic[@"title"];
//            NSString *content = _alertDic[@"content"];
//            XLGAlertView *alert = [[XLGAlertView alloc] initWithTitle:title content:content leftButtonTitle:@"" rightButtonTitle:@"确定"];
//            alert.doneBlock = ^{
//                [self->_webView evaluateJavaScript:@"fn_tapBack();" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
//                    NSLog(@"js返回结果%@",result);
//                }];
//                self->_alertDic = nil;
//                [self.navigationController popViewControllerAnimated:YES];
//            };
//        }
//        if ([_alertDic[@"type"] isEqualToString:@"confirm"]) {
//            NSString *title = _alertDic[@"title"];
//            NSString *content = _alertDic[@"content"];
//            XLGAlertView *alert = [[XLGAlertView alloc] initWithTitle:title content:content leftButtonTitle:@"取消" rightButtonTitle:@"确定"];
//            alert.doneBlock = ^{
//                [self->_webView evaluateJavaScript:@"fn_tapBack();" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
//                    NSLog(@"js返回结果%@",result);
//                }];
//                self->_alertDic = nil;
//                [self.navigationController popViewControllerAnimated:YES];
//            };
//        }
//    }
    
    if (_h5TapBack == YES) {
        [_webView evaluateJavaScript:@"fn_tapBack();" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
            NSLog(@"js返回结果%@",result);
        }];
        _h5TapBack = NO;
    }
    else {
        // 判断网页是否可以后退
        NSInteger webCount = self.webView.backForwardList.backList.count;
        if (webCount<1 || ![self.webView canGoBack]) {
            if (self.isPresent==YES) {
                [self dismissViewControllerAnimated:YES completion:nil];
            } else {
                if ([self.webTitle isEqualToString:@"个人中心"]) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:kUserInfoChangeNotification object:nil];
                }
                [self.navigationController popViewControllerAnimated:YES];
            }
        } else {
            if (self.webView.canGoBack) {
                [self.webView goBack];
            }
        }
    }
}

#pragma mark - OC调用JS

// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    
}

#pragma mark - JS调用OC

// WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    NSLog(@"name:%@\\\\n body:%@\\\\n frameInfo:%@\\\\n",message.name,message.body,message.frameInfo);
    
    if ([message.name isEqualToString:@"open"]) { //打开新页面
        NSDictionary *dic = message.body;
        if ([dic[@"type"] isEqualToString:@"web"]) {
            NSString *title = dic[@"title"];
            NSString *url = dic[@"url"];
            // 跳转新的H5页面
            [BaseWebVC showWithContro:self withUrlStr:url withTitle:[NSString isEmpty:title]?@"":title isPresent:NO];
        }
        if ([dic[@"type"] isEqualToString:@"app"]) {
            NSString *to = dic[@"to"];
            if ([to isEqualToString:@"home"]) {
                // 跳转到首页
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
            if ([to isEqualToString:@"login"]) {
                // 跳转到登录
                [Utils isLoginWithJump:YES];
            }
        }
    }
    
    if ([message.name isEqualToString:@"close"]) { //关闭当前页面
        if (self.isPresent==YES) {
            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    
    if ([message.name isEqualToString:@"tapBack"]) { //返回弹窗提示
        _h5TapBack = YES;
//        _alertDic = message.body;
    }
    
    if ([message.name isEqualToString:@"return"]) { //返回
        
    }
    
    if ([message.name isEqualToString:@"login"]) { //登录
        
    }
    
    if ([message.name isEqualToString:@"refresh"]) { //刷新
        [_webView reload];
    }
}

#pragma mark - WKNavigationDelegate

// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    [JHHJView showLoadingOnTheKeyWindowWithType:JHHJViewTypeSingleLine]; //开始加载
    
    NSString *url = webView.URL.absoluteString;
    NSLog(@"跳转网页地址：%@",url);
}

// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    [JHHJView hideLoading]; //结束加载
}

// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    [JHHJView hideLoading]; //结束加载
}

// 接收到服务器跳转请求之后调用
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation{
    
}

- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler{
    
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        
        NSURLCredential *card = [[NSURLCredential alloc]initWithTrust:challenge.protectionSpace.serverTrust];
        completionHandler(NSURLSessionAuthChallengeUseCredential,card);
    }
}

#pragma mark - WKUIDelegate

// 创建一个新的WebView
- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures {
    WKFrameInfo *frameInfo = navigationAction.targetFrame;
    if (![frameInfo isMainFrame]) {
        [webView loadRequest:navigationAction.request];
    }
    return nil;
}

// 输入框
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * __nullable result))completionHandler{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:prompt message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.text = defaultText;
        textField.delegate = self;
    }];
    [alertController addAction:([UIAlertAction actionWithTitle:@"完成" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(alertController.textFields[0].text?:@"");
    }])];
}

// 确认框
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(NO);
    }])];
    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(YES);
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
}

// 警告框
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    NSLog(@"%@",message);
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - WKWebView KVO

// 计算WKWebView进度条
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if (object == _webView) {
        
        if ([keyPath isEqualToString:@"estimatedProgress"]) {
            
            CGFloat newprogress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
            if (newprogress == 1) {
                self.progressView.hidden = YES;
                [self.progressView setProgress:0 animated:NO];
            } else {
                self.progressView.hidden = NO;
                [self.progressView setProgress:newprogress animated:YES];
            }
        }
        
        if ([keyPath isEqualToString:@"title"]) {
            if (self.isShowWebTitle==YES) {
                self.title = _webView.title;
            }
        }
    }
}

// 记得取消监听
- (void)dealloc {
    
    [_webView removeObserver:self forKeyPath:@"estimatedProgress"];
    [_webView removeObserver:self forKeyPath:@"title"];
    [_webView.scrollView removeObserver:self forKeyPath:@"contentOffset"];
    [_userContentController removeScriptMessageHandlerForName:@"open"];
    [_userContentController removeScriptMessageHandlerForName:@"close"];
    [_userContentController removeScriptMessageHandlerForName:@"tapBack"];
    [_userContentController removeScriptMessageHandlerForName:@"return"];
    [_userContentController removeScriptMessageHandlerForName:@"login"];
    [_userContentController removeScriptMessageHandlerForName:@"refresh"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
