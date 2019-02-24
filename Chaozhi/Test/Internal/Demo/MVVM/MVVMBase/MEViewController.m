//
//  MEViewController.m
//  Health
//
//  Created by mingyue on 17/4/26.
//  Copyright © 2017年 huds. All rights reserved.
//

#import "MEViewController.h"
#import "ReactiveObjC.h"

@interface MEViewController ()

@end

@implementation MEViewController

// 常用方法绑定到基类，方便调用
+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    
    MEViewController *viewController = [super allocWithZone:zone];
    
    @weakify(viewController);

    [[viewController rac_signalForSelector:@selector(viewDidLoad)] subscribeNext:^(id x) {
        
        @strongify(viewController)
        [viewController me_addSubviews];
        [viewController me_bindViewModel];
    }];
    
    [[viewController rac_signalForSelector:@selector(viewWillAppear:)] subscribeNext:^(id x) {
        
        @strongify(viewController)
        [viewController me_layoutNavigation];
        [viewController me_getNewData];
    }];
    
    return viewController;
}

//使用ViewModel初始化VC
- (instancetype)initWithViewModel:(id<MEViewControllerProtocol>)viewModel {
    
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.view.backgroundColor = [UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1.00];
}

//修改状态栏字体
//Info.plist - View controller-based status bar appearance
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - RAC
/**
 *  添加控件
 */
- (void)me_addSubviews {
}

/**
 *  用来绑定V(VC)与VM
 */
- (void)me_bindViewModel {
}

/**
 *  设置navation
 */
- (void)me_layoutNavigation {
}

/**
 *  初次获取数据
 */
- (void)me_getNewData {
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
