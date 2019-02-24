//
//  XLGLogVC.m
//  SharenGo
//  Notes：
//
//  Created by Jason on 2018/5/10.
//  Copyright © 2018年 小灵狗出行. All rights reserved.
//

#import "XLGLogVC.h"
#import "XLGExternalTestTool.h"

@interface XLGLogVC ()
{
    UITextView *logShowTextView;
}
@end

@implementation XLGLogVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"接口日志";
    
    UIButton *clickBtn = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH-50, kStatusBarH, 40, 40)];
    clickBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [clickBtn setTitle:@"清除" forState:UIControlStateNormal];
    [clickBtn setTitleColor:AppThemeColor forState:UIControlStateNormal];
    [clickBtn addTarget:self action:@selector(clearLogInfo) forControlEvents:UIControlEventTouchUpInside];
    self.navItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:clickBtn];
    
    XLGExternalTestTool *tempLogShow = [XLGExternalTestTool shareInstance];
    NSString *logInfoText = tempLogShow.logTextViews.text;
    
    logShowTextView = [[UITextView alloc]initWithFrame:CGRectMake(20, kNavBarH, WIDTH-25, HEIGHT-kNavBarH)];
    logShowTextView.editable = NO;
    logShowTextView.text = logInfoText;
    logShowTextView.backgroundColor = [UIColor clearColor];
    logShowTextView.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:logShowTextView];
}

- (void)backAction {
//    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)clearLogInfo{
    logShowTextView.text = @"";
    XLGExternalTestTool *tempLogShow = [XLGExternalTestTool shareInstance];
    tempLogShow.logTextViews.text = @"";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
