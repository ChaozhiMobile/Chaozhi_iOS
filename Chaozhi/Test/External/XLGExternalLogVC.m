//
//  XLGExternalLogVC.m
//  Chaozhi
//  Notes：
//
//  Created by Jason on 2018/5/10.
//  Copyright © 2018年 小灵狗出行. All rights reserved.
//

#import "XLGExternalLogVC.h"
#import "LogShowView.h"

@interface XLGExternalLogVC ()
{
    UITextView *logShowTextView;
}
@end

@implementation XLGExternalLogVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"接口日志";
    LogShowView *tempLogShow = [LogShowView shareInstance];
    NSString *logInfoText = tempLogShow.textViews.text;
    
    logShowTextView = [[UITextView alloc]initWithFrame:CGRectMake(20, kNavBarH, WIDTH-25, HEIGHT-kNavBarH-20)];
    logShowTextView.editable = NO;
    logShowTextView.text = logInfoText;
    logShowTextView.backgroundColor = [UIColor clearColor];
    logShowTextView.font = [UIFont systemFontOfSize:18];
    [self.view addSubview:logShowTextView];
    
    UIButton *clickBtn = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH-50, kStatusBarH, 40, 40)];
    clickBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [clickBtn setTitle:@"清除" forState:UIControlStateNormal];
    [clickBtn setTitleColor:AppThemeColor forState:UIControlStateNormal];
    [clickBtn addTarget:self action:@selector(clearLogInfo) forControlEvents:UIControlEventTouchUpInside];
    self.navItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:clickBtn];
}

- (void)clearLogInfo{
    logShowTextView.text = @"";
    LogShowView *tempLogShow = [LogShowView shareInstance];
    tempLogShow.textViews.text = @"";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
