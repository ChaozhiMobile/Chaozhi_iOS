//
//  CZProtocalWebVC.m
//  Chaozhi
//
//  Created by Jason_zyl on 2019/6/10.
//  Copyright © 2019 Jason_hzb. All rights reserved.
//

#import "CZProtocalWebVC.h"

@interface CZProtocalWebVC ()<WKNavigationDelegate>

@property (retain, nonatomic) WKWebView *webView;

/** 网页实际高度 */
@property (nonatomic,assign) CGFloat wbContentHeight;

@end

@implementation CZProtocalWebVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = kWhiteColor;
    
    self.title = self.webTitle;
    
    [self initWebView];
}

// WebView
- (void )initWebView {
    if (!_webView) {
        //配置环境
        WKWebViewConfiguration * configuration = [[WKWebViewConfiguration alloc]init];
        configuration.allowsInlineMediaPlayback = true;
        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(autoScaleW(8), kNavBarH, WIDTH-autoScaleW(16), HEIGHT-kNavBarH) configuration:configuration];
        _webView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        _webView.backgroundColor = [UIColor whiteColor];
        _webView.navigationDelegate = self;

        _webView.scrollView.decelerationRate = UIScrollViewDecelerationRateNormal;
        _webView.scrollView.showsVerticalScrollIndicator = NO;
        if (@available(iOS 11.0, *)) {
            self.webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    [self.view addSubview:_webView];
    
    [JHHJView showLoadingOnTheKeyWindowWithType:JHHJViewTypeSingleLine]; //开始加载
    
    //协议盖章
    NSString *cssPath = [[NSBundle mainBundle] pathForResource:@"ChaozhiProtocol" ofType:@"css"];
    if ([AppChannel isEqualToString:@"2"]) { //学智
        cssPath = [[NSBundle mainBundle] pathForResource:@"XuezhiProtocol" ofType:@"css"];
    }
    NSMutableString *htmlString =[[NSMutableString alloc]initWithString:@"<html> \n"];
    [htmlString appendString:@"<head> \n"];
    [htmlString appendString:@"<link rel=\"stylesheet\" type=\"text/css\" href=\" "];
    [htmlString appendString:cssPath];
    [htmlString appendString:@"\"/> \n"];
    [htmlString appendString:@"</head> \n"];
    [htmlString appendString:@"<body> \n"];
    [htmlString appendString:@"<div class=\"dialog-agreement\"> \n"];
    [htmlString appendString:[NSString stringWithFormat:@"<div class=\"dialog-agreement-content\">%@</div> \n",self.homeUrl]];
    [htmlString appendString:@"</div> \n"];
    [htmlString appendString:@"</body> \n"];
    [htmlString appendString:@"</html>"];
    
    NSURL *baseURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] resourcePath]];
    [self.webView loadHTMLString:htmlString baseURL:baseURL];
}

// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    [JHHJView hideLoading]; //结束加载
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
