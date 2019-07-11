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
    
    self.title = self.webTitle;
    
    [self initWebView];
}

// WebView
- (void )initWebView {
    if (!_webView) {
        //配置环境
        WKWebViewConfiguration * configuration = [[WKWebViewConfiguration alloc]init];
        configuration.allowsInlineMediaPlayback = true;
        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, kNavBarH, WIDTH, HEIGHT-kNavBarH) configuration:configuration];
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
    NSURL *baseURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] resourcePath]];
    
    //协议盖章
    NSString *cssPath = [[NSBundle mainBundle] pathForResource:@"protocol" ofType:@"css"];
    
    NSMutableString *htmlString =[[NSMutableString alloc]initWithString:@"<html>"];
    
    [htmlString appendString:@"<head>"];
    
    [htmlString appendString:@"<link rel =\"stylesheet\"  href = \" "];
    
    [htmlString appendString:cssPath];
    
    [htmlString appendString:@"\" type=\"text/css\" />"];
    
    [htmlString appendString:@"</head>"];
    
    [htmlString appendString:@"<body>"];
    
    [htmlString appendString:@"<div class=\"dialog-agreement\"> \n"];
    
    [htmlString appendString:[NSString stringWithFormat:@"<div class=\"dialog-agreement-content\">%@</div> \n",self.homeUrl]];
    
    [htmlString appendString:@"</div> \n"];
    
    [htmlString appendString:@"</body>"];
    
    [htmlString appendString:@"</html>"];
    
    [self.webView loadHTMLString:htmlString baseURL:baseURL];

}

// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    [JHHJView hideLoading]; //结束加载
//    [webView evaluateJavaScript:@"document.body.scrollWidth"completionHandler:^(id _Nullable result,NSError * _Nullable error){
//
//        CGFloat ratio =  CGRectGetWidth(webView.frame) /[result floatValue];
//        NSLog(@"scrollWidth高度：%.2f",[result floatValue]);
//
//        [webView evaluateJavaScript:@"document.body.scrollHeight"completionHandler:^(id _Nullable result,NSError * _Nullable error){
//
//            self.wbContentHeight = [result floatValue]*ratio;
//            [self addZhangImgView];
//
//        }];
//
//    }];
    
}

- (void)addZhangImgView {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(0, self.wbContentHeight-autoScaleW(100), autoScaleW(80), autoScaleW(80))];
        img.image = [UIImage imageNamed:@"protocol.png"];
        [self.webView.scrollView addSubview:img];
        [self.webView bringSubviewToFront:img];
    });
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
