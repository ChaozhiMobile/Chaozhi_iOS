//
//  XLGChangeServerVC.m
//  SharenGo
//  Notes：
//
//  Created by Jason_hzb on 2018/7/5.
//  Copyright © 2018年 小灵狗出行. All rights reserved.
//

#import "XLGChangeServerVC.h"
#import "XLGChangeServerCell.h"
#import "XLGChangeServerModel.h"
#import "JPUSHService.h"

@interface XLGChangeServerVC ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSMutableArray *_dataArray;
}
@end

@implementation XLGChangeServerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"环境切换";
    
    [self createUI];
}

- (void)backAction {
//    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:NO completion:nil];
}

-(void)createUI {
    
    //初始化tableView
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavBarH+10, WIDTH, HEIGHT-kNavBarH-10) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = TableViewDefaultBGColor;
    _tableView.separatorColor = kSeparatorColor;
    _tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
    _tableView.tableFooterView = [UIView new];
    [self.view addSubview:_tableView];
    
    //初始化model
    _dataArray = [NSMutableArray array];
    NSArray *titleArr = @[[NSString stringWithFormat:@"测试地址：%@",BASE_URL_D],
                          [NSString stringWithFormat:@"正式地址：%@",BASE_URL],
                          ];
    for (int i = 0; i<titleArr.count; i++) {
        XLGChangeServerModel *model = [[XLGChangeServerModel alloc] init];
        model.selectStatus = [Utils getServer]==i?YES:NO;
        model.title = titleArr[i];
        [_dataArray addObject:model];
    }
}

#pragma mark - UITableViewDelegate、UITableViewDataSource代理
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return autoScaleW(50);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIndentifier = @"ChangeServerCell";
    XLGChangeServerCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if (cell == nil) {
        cell = [[XLGChangeServerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    XLGChangeServerModel *model = _dataArray[indexPath.row];
    [cell setContentWithModel:model];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [Utils setServer:indexPath.row]; 
    
    //改变数据源
    for (int i = 0; i<_dataArray.count; i++) {
        XLGChangeServerModel *model = _dataArray[i];
        if (i==indexPath.row) {
            model.selectStatus = YES;
        } else {
            model.selectStatus = NO;
        }
    }
    
    //刷新tableView
    [_tableView reloadData];
    
    [Utils logout:NO]; //不跳登录页面
    // 极光推送清除别名
    [JPUSHService setTags:nil alias:@"" fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
        
    }];
    [self cleanCacheAndCookie];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kChangeServerSuccNotification object:nil];
    [self.navigationController popViewControllerAnimated:NO];
    self.tabBarController.selectedIndex = 0;
    
    [Utils changeUserAgent]; //WKWebView UA初始化
}

/**清除缓存和cookie*/
- (void)cleanCacheAndCookie{
    //清除cookies
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies]){
        [storage deleteCookie:cookie];
    }
    //清除UIWebView的缓存
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    NSURLCache * cache = [NSURLCache sharedURLCache];
    [cache removeAllCachedResponses];
    [cache setDiskCapacity:0];
    [cache setMemoryCapacity:0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
