//
//  XLGInternalTestVC.m
//  Chaozhi
//  Notes：
//
//  Created by Jason on 2018/5/7.
//  Copyright © 2018年 小灵狗出行. All rights reserved.
//

#import "XLGInternalTestVC.h"
#import "XLGInternalDemoVC.h"
#import <MJRefresh.h>
#import <Lottie/Lottie.h>

#define cellHeight 40.0f

@interface XLGInternalTestVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) NSArray *titleArr;

@end

@implementation XLGInternalTestVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"内部测试";
    
    //self.isPanForbid = YES; //禁用iOS自带侧滑返回手势
    
    UIButton *clickBtn = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH-50, kStatusBarH, 40, 40)];
    clickBtn.hidden = YES;
    clickBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [clickBtn setTitle:@"Demo" forState:UIControlStateNormal];
    [clickBtn setTitleColor:AppThemeColor forState:UIControlStateNormal];
    [clickBtn addTarget:self action:@selector(demoAction) forControlEvents:UIControlEventTouchUpInside];
    self.navItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:clickBtn];
    
    [self initTab];
}

#pragma mark - init view

- (void)initTab {
    
    self.tableView = [[UITableView alloc] initWithFrame:self.tableFrame style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    //动画下拉刷新
    [self tableViewGifHeaderWithRefreshingBlock:^{
        [self getData];
    }];
    [self.tableView.mj_header beginRefreshing];

//    //动画加载更多
//    [self tableViewGifFooterWithRefreshingBlock:^{
//        [self loadMoreData];
//    }];
    
//    //默认下拉刷新
//    [self tableViewNormalHeaderWithRefreshingBlock:^{
//        [self getData];
//    }];
//    [self.tableView.mj_header beginRefreshing];
    
    //默认加载更多
    [self tableViewNormalFooterWithRefreshingBlock:^{
        [self loadMoreData];
    }];
}

#pragma mark - lazy loading...

- (NSArray *)titleArr {
    if(_titleArr==nil) {
        _titleArr = @[@"仿安卓Toast提示",
                      @"登录网络请求",
                      @"获取用户token",
                      @"参数生成签名",
                      @"json加载动画",
                      @"打印类属性列表",
                      ];
    }
    return _titleArr;
}

#pragma mark - methods

- (void)backAction {
//    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:NO completion:nil];
}

//没有网络了
- (void)netWorkDisappear
{
    [super netWorkDisappear];
    
    [self.tableView reloadData];
    [self.tableView.mj_header endRefreshing];
}

//有网络了
- (void)netWorkAppear
{
    [super netWorkAppear];
    
    [self getData];
}

//获取数据
- (void)getData {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView.mj_header endRefreshing];
    });
    [self.tableView reloadData];
}

//加载更多数据
- (void)loadMoreData {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView.mj_footer endRefreshing];
    });
    [self.tableView reloadData];
}

//跳转到demo列表
- (void)demoAction {
    XLGInternalDemoVC *vc = [[XLGInternalDemoVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UITableViewDelegate、UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titleArr.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if ([Utils getNetStatus]) {
        return nil;
    }
    else
    {
        UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 40)];
        header.backgroundColor = RGBValue(0xFFBCBE);
        UILabel *headerLab = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, WIDTH -40, 40)];
        headerLab.text = @"当前网络不可用，请设置您的网络";
        headerLab.font = [UIFont systemFontOfSize:16 ];
        headerLab.textColor = RGBValue(0x030303);
        UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 30, 30)];
        iconView.image = [UIImage imageNamed:@"NetNotice.png"];
        [header addSubview:iconView];
        [header addSubview:headerLab];
        return header;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if ([Utils getNetStatus]) {
        return CGFLOAT_MIN;
    }
    return cellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *ID = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    cell.textLabel.text = self.titleArr[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES]; //取消选择状态
    
    NSString *title = self.titleArr[indexPath.row];
    
#pragma mark - 仿安卓Toast提示
    if ([title isEqualToString:@"仿安卓Toast提示"]) {
        if (![Utils getNetStatus]) {
            [Utils showToast:@"网络不给力，请重试！"];
        } else {
            [Utils showToast:@"当前网络环境很给力！"];
        }
    }
    
#pragma mark - 打印类属性列表
    if ([title isEqualToString:@"打印类属性列表"]) {
        
        id tfClass = objc_getClass("UISearchBar");
        unsigned int outCount, i;
        objc_property_t *properties = class_copyPropertyList(tfClass, &outCount);
        for (i = 0; i < outCount; i++) {
            objc_property_t property = properties[i];
            fprintf(stdout, "UISearchBar属性列表：%s %s\n", property_getName(property), property_getAttributes(property));
        }
    }
    
#pragma mark - 登录网络请求
    if ([title isEqualToString:@"登录网络请求"]) {
        
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                             @"15068850958", @"phone",
                             @"112233", @"password",
                             nil];
        [[NetworkManager sharedManager] postJSON:URL_Login parameters:dic imageDataArr:nil imageName:nil  completion:^(id responseData, RequestState status, NSError *error) {
            
            NSLog(@"%d",status);
            
            if (status == Request_Success) {
                [Utils showToast:@"登录成功"];
            } else {
                [Utils showToast:@"登录失败"];
            }
        }];
    }
    
#pragma mark - 参数生成签名
    if ([title isEqualToString:@"参数生成签名"]) {
        
    }
    
#pragma mark - 获取用户token
    if ([title isEqualToString:@"获取用户token"]) {
        
        [Utils showToast:[UserInfo share].token];
    }
    
#pragma mark - jason动画
    if ([title isEqualToString:@"json加载动画"]) {
        
        [[XLGLottie shared] showWithType:_LOTTIE_LOADING_];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[XLGLottie shared] dismiss];
        });
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
//    self.navBar.hidden = YES; //隐藏导航条
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
