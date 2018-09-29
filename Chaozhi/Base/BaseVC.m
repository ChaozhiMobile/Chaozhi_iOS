//
//  BaseVC.m
//  Chaozhi
//  Notes：
//
//  Created by Jason on 2018/5/7.
//  Copyright © 2018年 小灵狗出行. All rights reserved.
//

#import "BaseVC.h"
#import "MJRefresh.h"
#import "XLGExternalTestTool.h"

@interface BaseVC ()<UITextFieldDelegate,UITextViewDelegate,UITabBarDelegate>
{
    __block int timeout; //倒计时时间
    XLGExternalTestTool *testTool;
}

@property (nonatomic, assign)CGFloat viewBottom; //textField的底部
@property (nonatomic, assign)CGRect keyBoardFrames;

@end

@implementation BaseVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //隐藏系统导航条
    [self.navigationController setNavigationBarHidden:YES];
    [self.view addSubview:self.navBar];
    
    if (!self.isPanForbid) { //默认开启
        // 开启iOS自带侧滑返回手势
        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        }
    } else {
        // 禁用iOS自带侧滑返回手势
        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.navigationController.interactivePopGestureRecognizer.enabled = NO;
        }
    }
    
    XLGExternalTestTool *testTool = [XLGExternalTestTool shareInstance];
    UIWindow *myWindow= [[[UIApplication sharedApplication] delegate] window];
    if (![myWindow viewWithTag:10001]&&!KOnline) {
        [myWindow addSubview:testTool];
    }
    [myWindow bringSubviewToFront:testTool];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.view bringSubviewToFront:self.navBar];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    //显示系统导航条
    [self.navigationController setNavigationBarHidden:NO];
}

//- (void)viewDidLayoutSubviews {
//
//    UIView *view = self.view.subviews[0];
//    CGRect frame = view.frame;
//    frame.origin.y = kNavBarH;
//    view.frame = frame;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = PageColor;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationController.automaticallyAdjustsScrollViewInsets = NO;
    [self.navigationController setNavigationBarHidden:YES];

    if (@available(iOS 11.0, *)) {
        UIScrollView.appearance.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    _viewConstraintH.constant = MIN(autoScaleH(50), 60);
    _viewTopY.constant = 44;
    self.tableFrame = CGRectMake(0, kNavBarH, WIDTH, HEIGHT-kNavBarH);
    
    [self setNavBar];
    
    __weak id weakSelf = self;
    self.navigationController.interactivePopGestureRecognizer.delegate = weakSelf;
    
    //无网络通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netWorkDisappear) name:@"kNetDisAppear" object:nil];
    //有网络通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netWorkAppear) name:@"kNetAppear" object:nil];
}

//没有网络了
- (void)netWorkDisappear
{
    //    if (![self.navItem.title containsString:@"（未连接）"]) {
    //        self.navItem.title = [NSString stringWithFormat:@"%@（未连接）",self.navItem.title];
    //    }
}

//有网络了
- (void)netWorkAppear
{
    //    if ([self.navItem.title containsString:@"（未连接）"]) {
    //        self.navItem.title = [self.navItem.title stringByReplacingOccurrencesOfString:@"（未连接）" withString:@""];
    //    }
}

#pragma mark - 自定义导航条
- (void)setNavBar {
    
    self.navBar = [[BaseNavBar alloc] initWithFrame:CGRectMake(0, 0, WIDTH, kNavBarH)];
    self.navItem = [[UINavigationItem alloc] init];
    [self.navBar setItems:@[self.navItem]];
    
    if ([[self.navigationController viewControllers] count] != 1) { //根VC不加返回按钮
        UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 44)];
        [backBtn setImage:[UIImage imageNamed:@"Back"] forState:UIControlStateNormal];
        backBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];;
        self.navItem.leftBarButtonItem = backBarButtonItem;
    }
}

#pragma mark - Set方法
- (void)setTitle:(NSString *)title {
    self.navItem.title = title;
}

#pragma mark - 自定义方法
//返回
- (void)backAction {
    timeout = -1;
    [self.navigationController popViewControllerAnimated:YES];
}

//初始化页面
- (void)initView {
}

//获取数据
- (void)getData {
}

#pragma mark - 动画下拉刷新/上拉加载更多
- (NSMutableArray *)refreshImages {
    NSMutableArray *images = [NSMutableArray array];
    for (NSInteger i = 0; i<=34; i++) {
        NSString *nameStr = @"";
        if (i<10) {
            nameStr = [NSString stringWithFormat:@"ic_refresh_image_00%ld",i];
        } else {
            nameStr = [NSString stringWithFormat:@"ic_refresh_image_0%ld",i];
        }
        UIImage *image = [UIImage imageNamed:nameStr]; //图片文件根据项目替换
        [images addObject:image];
    }
    return images;
}

- (void)tableViewGifHeaderWithRefreshingBlock:(void(^)(void)) block {
    
    //设置即将刷新状态的动画图片
    NSMutableArray *headerImages = [self refreshImages];
    
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        //下拉刷新要做的操作
        block();
    }];
    
    // 设置文字
    [header setTitle:@"正在刷新~" forState:MJRefreshStateIdle];
    [header setTitle:@"松开立即刷新" forState:MJRefreshStatePulling];
    [header setTitle:@"正在刷新~" forState:MJRefreshStateRefreshing];
    
    //是否显示刷新状态和刷新时间
//    header.stateLabel.hidden = YES;
    header.lastUpdatedTimeLabel.hidden = YES;
    
    [header setImages:@[headerImages[0]] duration:0.5 forState:MJRefreshStateIdle];
    [header setImages:headerImages duration:0.5 forState:MJRefreshStatePulling];
    [header setImages:headerImages duration:0.5 forState:MJRefreshStateRefreshing];
    self.tableView.mj_header = header;
}

- (void)tableViewGifFooterWithRefreshingBlock:(void(^)(void)) block {
    
    NSMutableArray *footerImages = [self refreshImages];
    
    MJRefreshAutoGifFooter *footer = [MJRefreshAutoGifFooter footerWithRefreshingBlock:^{
        //上拉加载需要做的操作
        block();
    }];
    
    // 设置文字
    [footer setTitle:@"上拉加载更多" forState:MJRefreshStateIdle];
    [footer setTitle:@"正在加载~" forState:MJRefreshStateRefreshing];
    [footer setTitle:@"全部加载完毕" forState:MJRefreshStateNoMoreData];
    
    //是否显示刷新状态和刷新时间
//    footer.stateLabel.hidden = YES;
//    footer.refreshingTitleHidden = YES;
    
    [footer setImages:@[footerImages[0]] duration:1 forState:MJRefreshStateIdle];
    [footer setImages:footerImages duration:1 forState:MJRefreshStateRefreshing];
    self.tableView.mj_footer = footer;
}

#pragma mark - 默认下拉刷新/上拉加载更多
- (void)tableViewNormalHeaderWithRefreshingBlock:(void(^)(void)) block {
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //下拉刷新要做的操作
        block();
    }];
    
    // 设置文字
    [header setTitle:@"正在刷新~" forState:MJRefreshStateIdle];
    [header setTitle:@"松开立即刷新" forState:MJRefreshStatePulling];
    [header setTitle:@"正在刷新~" forState:MJRefreshStateRefreshing];
    
    self.tableView.mj_header = header;
}

- (void)tableViewNormalFooterWithRefreshingBlock:(void(^)(void)) block {
    
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        //上拉加载需要做的操作
        block();
    }];
    
    // 设置文字
    [footer setTitle:@"上拉加载更多" forState:MJRefreshStateIdle];
    [footer setTitle:@"正在加载~" forState:MJRefreshStateRefreshing];
    [footer setTitle:@"全部加载完毕" forState:MJRefreshStateNoMoreData];
    
    self.tableView.mj_footer = footer;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

- (void)startTimeCount:(UIButton *)l_timeButton {
    timeout = 60;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(self->timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [l_timeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
                l_timeButton.userInteractionEnabled = YES;
                l_timeButton.enabled = YES;
            });
        }else{
            int seconds = self->timeout;
            
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [l_timeButton setTitle:[NSString stringWithFormat:@"%@秒后重发",strTime] forState:UIControlStateNormal];
                l_timeButton.userInteractionEnabled = NO;
                
            });
            self->timeout--;
        }
    });
    dispatch_resume(_timer);
}

//解决跳转到相册页面 出现透明导航栏
- (void)navigationController:(UINavigationController *)navigationController
      willShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated {
    if ([navigationController isKindOfClass:[UIImagePickerController class]]) {
        viewController.navigationController.navigationBar.translucent = NO;
        viewController.edgesForExtendedLayout = UIRectEdgeNone;
    }
}

- (void)dealloc {
    NSLog(@"释放控制器");
    [[NSNotificationCenter defaultCenter] removeObserver:self]; //移除通知
    timeout = -1;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
