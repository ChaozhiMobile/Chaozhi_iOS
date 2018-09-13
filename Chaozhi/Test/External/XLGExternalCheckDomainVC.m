//
//  XLGExternalCheckDomainVC.m
//  Chaozhi
//  Notes：
//
//  Created by zhanbing han on 2018/6/1.
//  Copyright © 2018年 小灵狗出行. All rights reserved.
//

#import "XLGExternalCheckDomainVC.h"
#import "LDNetDiagnoService.h"

@interface XLGExternalCheckDomainVC ()<LDNetDiagnoServiceDelegate,UITextFieldDelegate>
{
    UITextField *_dormainBtn;
    LDNetDiagnoService *_netDiagnoService;
    NSArray *domainArray;
}

@property (nonatomic , retain) UIActivityIndicatorView *indicatorView;
@property (nonatomic , retain)UITextView *txtView_log;
@property (nonatomic , assign)BOOL isRunning;
@property (nonatomic , copy)NSString * logInfo;
@property (nonatomic , retain) UIButton *startCheckBtn;;

@end

@implementation XLGExternalCheckDomainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"域名检测";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _indicatorView = [[UIActivityIndicatorView alloc]
                      initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _indicatorView.frame = CGRectMake(0, 0, 30, 30);
    _indicatorView.hidden = NO;
    _indicatorView.hidesWhenStopped = YES;
    [_indicatorView stopAnimating];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:_indicatorView];
    self.navItem.rightBarButtonItem = rightItem;
    
    _dormainBtn = [[UITextField alloc] initWithFrame:CGRectMake(10.0f, kNavBarH+20, WIDTH-110, 40)];
    _dormainBtn.text = @"api.evcoming.com";
    _dormainBtn.autocorrectionType = UITextAutocorrectionTypeNo; // 关闭键盘联想
    _dormainBtn.spellCheckingType = UITextSpellCheckingTypeNo;// 禁用拼写检
    _dormainBtn.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.3];
    _dormainBtn.cornerRadius = 8;
    _dormainBtn.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 5, 0)];
    _dormainBtn.leftViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:_dormainBtn];
    
    _startCheckBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _startCheckBtn.frame = CGRectMake(_dormainBtn.right+10, kNavBarH+20, 80.0f, 40);
    [_startCheckBtn setBackgroundColor:AppThemeColor];
    _startCheckBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    _startCheckBtn.cornerRadius = 5;
    [_startCheckBtn setTitle:@"开始诊断" forState:UIControlStateNormal];
    [_startCheckBtn addTarget:self action:@selector(startNetDiagnosis) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_startCheckBtn];
    
    _txtView_log = [[UITextView alloc] initWithFrame:CGRectZero];
    _txtView_log.layer.borderWidth = 0.5f;
    _txtView_log.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _txtView_log.backgroundColor = [UIColor whiteColor];
    _txtView_log.font = [UIFont systemFontOfSize:15.0f];
    _txtView_log.textAlignment = NSTextAlignmentLeft;
    _txtView_log.scrollEnabled = YES;
    _txtView_log.editable = NO;
    _txtView_log.frame =
    CGRectMake(0.0f, _dormainBtn.bottom+20, self.view.frame.size.width, self.view.frame.size.height - (_dormainBtn.bottom+20));
    [self.view addSubview:_txtView_log];
    
    _netDiagnoService = [[LDNetDiagnoService alloc] initWithAppCode:@"test"
                                                            appName:@"网络诊断应用"
                                                         appVersion:@"1.0.0"
                                                             userID:@"huipang@corp.netease.com"
                                                           deviceID:nil
                                                            dormain:_dormainBtn.text
                                                        carrierName:nil
                                                     ISOCountryCode:nil
                                                  MobileCountryCode:nil
                                                      MobileNetCode:nil];
    _netDiagnoService.delegate = self;
    _isRunning = NO;
}

- (void)startNetDiagnosis {
    [_dormainBtn resignFirstResponder];
    _netDiagnoService.dormain = _dormainBtn.text;
    if (!_isRunning) {
        [_indicatorView startAnimating];
        [_startCheckBtn setTitle:@"停止诊断" forState:UIControlStateNormal];
        [_startCheckBtn setUserInteractionEnabled:FALSE];
        [self performSelector:@selector(delayMethod) withObject:nil afterDelay:3.0f];
        _txtView_log.text = @"";
        _logInfo = @"";
        _isRunning = !_isRunning;
        [_netDiagnoService startNetDiagnosis];
    } else {
        [_indicatorView stopAnimating];
        _isRunning = !_isRunning;
        [_startCheckBtn setTitle:@"开始诊断" forState:UIControlStateNormal];
        [_startCheckBtn setUserInteractionEnabled:FALSE];
        [self performSelector:@selector(delayMethod) withObject:nil afterDelay:3.0f];
        [_netDiagnoService stopNetDialogsis];
    }
}

- (void)delayMethod {
    [_startCheckBtn setBackgroundColor:AppThemeColor];
    [_startCheckBtn setUserInteractionEnabled:TRUE];
}

#pragma mark NetDiagnosisDelegate
- (void)netDiagnosisDidStarted {
    NSLog(@"开始诊断～～～");
}

- (void)netDiagnosisStepInfo:(NSString *)stepInfo {
    NSLog(@"%@", stepInfo);
    __weak typeof(self) weakSelf = self;
    _logInfo = [_logInfo stringByAppendingString:stepInfo];
    dispatch_async(dispatch_get_main_queue(), ^{
        weakSelf.txtView_log.text = weakSelf.logInfo;
        [weakSelf.txtView_log scrollRangeToVisible:NSMakeRange(weakSelf.txtView_log.text.length, 1)];
    });
}

- (void)netDiagnosisDidEnd:(NSString *)allLogInfo {
    __weak typeof(self) weakSelf = self;
    //可以保存到文件，也可以通过邮件发送回来
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf.indicatorView stopAnimating];
        [weakSelf.startCheckBtn setTitle:@"开始诊断" forState:UIControlStateNormal];
        weakSelf.isRunning = NO;
    });
}

- (void)emailLogInfo {
    [_netDiagnoService printLogInfo];
}

#pragma mark - textFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning
{
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
