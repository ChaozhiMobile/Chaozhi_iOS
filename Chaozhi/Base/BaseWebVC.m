//
//  BaseWebVC.m
//  Chaozhi
//  Notes：
//
//  Created by Jason on 2018/5/7.
//  Copyright © 2018年 小灵狗出行. All rights reserved.
//

#import "BaseWebVC.h"
#import "WKDelegateController.h"
#import <IAPShare.h>
#import "DBManager.h"
#import "VideoItem.h"
#import "TalkfunItem.h"
#import "TalkfunViewController.h"
#import "TalkfunPlaybackViewController.h"
#import "XLGExternalTestTool.h"

@interface BaseWebVC ()<WKUIDelegate,WKNavigationDelegate,WKDelegate,UITextFieldDelegate>

@property (strong, nonatomic) UIProgressView *progressView;
@property (strong, nonatomic) WKUserContentController *userContentController;
@property (nonatomic, assign) BOOL h5TapBack;
@property (nonatomic, copy) NSString *showPullRefresh;

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
    
    [self initWebView];
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
- (void )initWebView {
    if (!_webView) {
        //配置环境
        WKWebViewConfiguration * configuration = [[WKWebViewConfiguration alloc]init];
        configuration.allowsInlineMediaPlayback = true;
        _userContentController =[[WKUserContentController alloc]init];
        configuration.userContentController = _userContentController;
        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, kNavBarH, WIDTH, HEIGHT-kNavBarH) configuration:configuration];
        _webView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        _webView.backgroundColor = [UIColor whiteColor];
        _webView.navigationDelegate = self;
        _webView.UIDelegate = self;
        _webView.scrollView.decelerationRate = UIScrollViewDecelerationRateNormal;
        _webView.scrollView.showsVerticalScrollIndicator = NO;
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
        [_userContentController addScriptMessageHandler:delegateController name:@"iapBuy"]; //课程内购
        [_userContentController addScriptMessageHandler:delegateController name:@"setPullRefresh"]; //下拉刷新
    }
    [self.view addSubview:_webView];
    
    if ([_homeUrl containsString:@"http"]) {
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_homeUrl] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:30]];
    } else {
         [self.webView loadHTMLString:_homeUrl baseURL:nil];
    }
    
    [self.view addSubview:self.progressView];
    [self.view insertSubview:self.webView belowSubview:self.progressView];
}

#pragma mark - 返回事件

// 返回按钮点击
- (void)backAction {
    
    NSLog(@"打开web页面个数：%lu",(unsigned long)self.webView.backForwardList.backList.count);
    
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
                [self.navigationController popToRootViewControllerAnimated:NO];
                self.tabBarController.selectedIndex = 0;
            }
            if ([to isEqualToString:@"login"]) {
                // 跳转到登录
                [Utils isLoginWithJump:YES];
            }
        }
        if ([dic[@"type"] isEqualToString:@"video"]) {
            NSDictionary *videoDic = dic[@"data"];
            VideoItem *item = [VideoItem mj_objectWithKeyValues:videoDic];
            if ([NSString isEmpty:item.product_id]) {
                item.product_id = @"0";
            }
            [self talkfunVideo:item];
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
    }
    
    if ([message.name isEqualToString:@"iapBuy"]) { //课程内购
        NSDictionary *dic = message.body;
        NSString *iapID = dic[@"iapID"];
        NSLog(@"课程内购ID：%@",iapID);
        
        if ([Utils isLoginWithJump:YES]) {
            [self iapBuy:iapID];
        }
    }
    
    if ([message.name isEqualToString:@"return"]) { //返回
        
    }
    
    if ([message.name isEqualToString:@"login"]) { //登录
        
    }
    
    if ([message.name isEqualToString:@"refresh"]) { //刷新
        [_webView reload];
    }
    
    if ([message.name isEqualToString:@"setPullRefresh"]) { //下拉刷新
        NSDictionary *dic = message.body;
        _showPullRefresh = dic[@"showPullRefresh"];
        if ([_showPullRefresh isEqualToString:@"1"]) { //显示
            __weak typeof(self) weakSelf = self;
            self.webView.scrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
                [weakSelf.webView reload];
            }];
        } else { //隐藏
            self.webView.scrollView.mj_header = nil;
        }
    }
}

#pragma mark - 欢拓原生视频
/**
 * 播放视频。类型1:录播; 2:回放; 3:直播 (后台回放和直播都是2，本地需要区分下)
 */
- (void)talkfunVideo:(VideoItem *)item {
    if (![NSString isEmpty:item.token]) { //公开课视频token是H5传过来的
        if ([item.type isEqualToString:@"1"]
            || [item.type isEqualToString:@"2"]) {
            TalkfunPlaybackViewController *vc = [[TalkfunPlaybackViewController alloc] init];
            vc.res = [[NSDictionary alloc] initWithObjectsAndKeys:@{@"access_token":item.token},@"data", nil];
            vc.playbackID = item.live_id;
            vc.videoItem = item;
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
        if ([item.type isEqualToString:@"3"]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                TalkfunViewController *myVC = [[TalkfunViewController alloc] init];
                myVC.res = [[NSDictionary alloc] initWithObjectsAndKeys:@{@"access_token":item.token},@"data",@"0",@"code", nil];
                myVC.videoItem = item;
                myVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:myVC animated:YES];
            });
        }
    } else {
        NSString *type = [item.type isEqualToString:@"1"]?@"1":@"2";
        NSDictionary *dic = @{@"type":type,@"live_id":item.live_id};
        [[NetworkManager sharedManager] postJSON:URL_LiveToken parameters:dic imageDataArr:nil imageName:nil completion:^(id responseData, RequestState status, NSError *error) {
            if (status == Request_Success) {
                TalkfunItem *talkfunItem = [TalkfunItem mj_objectWithKeyValues:(NSDictionary *)responseData];
                if ([item.type isEqualToString:@"1"]
                    || [item.type isEqualToString:@"2"]) {
                    TalkfunPlaybackViewController *vc = [[TalkfunPlaybackViewController alloc] init];
                    vc.res = [[NSDictionary alloc] initWithObjectsAndKeys:@{@"access_token":talkfunItem.access_token},@"data", nil];
                    vc.playbackID = item.live_id;
                    vc.videoItem = item;
                    vc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                }
                if ([item.type isEqualToString:@"3"]) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        TalkfunViewController *myVC = [[TalkfunViewController alloc] init];
                        myVC.res = [[NSDictionary alloc] initWithObjectsAndKeys:@{@"access_token":talkfunItem.access_token},@"data",@"0",@"code", nil];
                        myVC.videoItem = item;
                        myVC.hidesBottomBarWhenPushed = YES;
                        [self.navigationController pushViewController:myVC animated:YES];
                    });
                }
            }
        }];
    }
}

#pragma mark - 课程内购
- (void)iapBuy:(NSString *)ipaID {
    
    // https://cloud.tencent.com/developer/article/1423496
    // https://www.jianshu.com/p/d804b7dca7e7
    // http://www.cocoachina.com/cms/wap.php?action=article&id=25288
    
    [JHHJView showLoadingOnTheKeyWindowWithType:JHHJViewTypeSingleLine]; //开始加载
    
    NSSet *dataSet = [[NSSet alloc] initWithObjects:ipaID, nil];
    [IAPShare sharedHelper].iap = [[IAPHelper alloc] initWithProductIdentifiers:dataSet];
    
    if (KOnline || [Utils getServer] == 1) {
        [IAPShare sharedHelper].iap.production = YES; // 生产环境
    } else {
        [IAPShare sharedHelper].iap.production = NO; // 开发环境
    }
    
    // 请求商品信息
    [[IAPShare sharedHelper].iap requestProductsWithCompletion:^(SKProductsRequest* request,SKProductsResponse* response)
     {
         [JHHJView hideLoading];
         
         if(response.products.count > 0 ) {
             SKProduct *product = response.products[0];
             
             NSLog(@"%@",[product localizedTitle]);
             
             [JHHJView showLoadingOnTheKeyWindowWithType:JHHJViewTypeSingleLine]; //开始加载
             [[IAPShare sharedHelper].iap buyProduct:product
                                        onCompletion:^(SKPaymentTransaction* trans){
                                            [JHHJView hideLoading];
                                            if(trans.error) {
                                                
                                            }
                                            else if(trans.transactionState == SKPaymentTransactionStatePurchased) {
                                                // 到这里购买就成功了，但是因为存在越狱手机下载某些破解内购软件的情况，需要跟苹果服务器的确认是否购买成功
                                                // IAPHelper提供了这个方法，验证这步可以写在前端，也可以写在服务器端，这个自己看情况决定吧...
                                                
                                                //   ！！ 这里有一种情况需要注意。程序走到这里的时候，已经是支付成功的状态。
                                                // 此时用户的钱已经被苹果扣掉了，接下来需要做的是验证购买信息。
                                                // 但是如果在 '购买成功'——'验证订单' 中间出现问题，断网、App崩溃等问题的话，会出现扣了钱但是充值失败的情况
                                                // 所以在这里可以将下文中的验证信息存在本地，验证成功再后删除。验证失败的话，可以在每次App启动时将信息取出来重新验证
                                                
                                                // 购买验证
                                                NSData *receipt = [NSData dataWithContentsOfURL:[[NSBundle mainBundle] appStoreReceiptURL]];
                                                NSString *receiptStr = [receipt base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
                                                [CacheUtil saveCacher:kIapCheck withValue:receiptStr];
                                                NSLog(@"购买凭证：%@",receiptStr);
                                                [self iapPayCheck:receiptStr];
                                                //网上的攻略有的比较老，在验证时使用的是trans.transactionReceipt，需要注意trans.transactionReceipt在ios9以后被弃用
//                                                [[IAPShare sharedHelper].iap checkReceipt:receipt onCompletion:^(NSString *response, NSError *error) {}];
                                                
                                            }
                                            else if(trans.transactionState == SKPaymentTransactionStateFailed) {
                                                if (trans.error.code == SKErrorPaymentCancelled) {
                                                }else if (trans.error.code == SKErrorClientInvalid) {
                                                }else if (trans.error.code == SKErrorPaymentInvalid) {
                                                }else if (trans.error.code == SKErrorPaymentNotAllowed) {
                                                }else if (trans.error.code == SKErrorStoreProductNotAvailable) {
                                                }else{
                                                }
                                            }
                                        }];
         } else {
             //  ..未获取到商品
             [Utils showToast:@"商品不存在"];
         }
     }];
}

#pragma mark - 内购凭证服务器校验
- (void)iapPayCheck:(NSString *)receipt {
    __weak typeof(self) weakSelf = self;
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         receipt, @"receipt",
                         nil];
    [[NetworkManager sharedManager] postJSON:URL_IapPayCheck parameters:dic imageDataArr:nil imageName:nil  completion:^(id responseData, RequestState status, NSError *error) {
        
        if (status == Request_Success) {
            [weakSelf.webView evaluateJavaScript:@"fn_iapBuy();" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
                NSLog(@"js返回结果%@",result);
            }];
            [CacheUtil saveCacher:kIapCheck withValue:@""];
        }
    }];
}

#pragma mark - WKNavigationDelegate

// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    [JHHJView showLoadingOnTheKeyWindowWithType:JHHJViewTypeSingleLine]; //开始加载
    
    NSString *url = webView.URL.absoluteString;
    NSLog(@"跳转网页地址：%@",url);
    
    if (!KOnline) {
        XLGExternalTestTool *tool = [XLGExternalTestTool shareInstance];
        tool.logTextViews.text = [NSString stringWithFormat:@"跳转网页地址：%@ \n\n\n%@",webView.URL.absoluteString,tool.logTextViews.text];
    }
}

// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    [JHHJView hideLoading]; //结束加载
    if ([_showPullRefresh isEqualToString:@"1"]) { //显示
        if ([self.webView.scrollView.mj_header isRefreshing]) {
            [self.webView.scrollView.mj_header endRefreshing];
        }
    }
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
    [_userContentController removeScriptMessageHandlerForName:@"iapBuy"];
    [_userContentController removeScriptMessageHandlerForName:@"return"];
    [_userContentController removeScriptMessageHandlerForName:@"login"];
    [_userContentController removeScriptMessageHandlerForName:@"refresh"];
    [_userContentController removeScriptMessageHandlerForName:@"setPullRefresh"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
