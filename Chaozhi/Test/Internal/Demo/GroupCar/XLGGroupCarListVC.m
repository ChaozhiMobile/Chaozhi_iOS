//
//  XLGGroupCarListVC.m
//  Chaozhi
//  Notes：
//
//  Created by Jason_hzb on 2018/6/11.
//  Copyright © 2018年 小灵狗出行. All rights reserved.
//

#import "XLGGroupCarListVC.h"
#import "XLGGroupCarListCell.h"
#import "MJRefresh.h"
#import "XLGShowTipsVC.h"

@interface XLGGroupCarListVC () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *carListArr;

@property (nonatomic, strong) NSArray *currentBackCarListArr; //最新一次拉取的数据，判断下拉加载

@property (nonatomic, assign) NSInteger pageIndex;

@end

@implementation XLGGroupCarListVC

@synthesize tableView = _tableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"集团用车";
    
    self.navItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"无车提示" style:UIBarButtonItemStylePlain target:self action:@selector(showTips)];
    
    [self.view addSubview:self.tableView];
    
    @weakify(self);
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.and.right.and.bottom.equalTo(self.view);
        make.top.equalTo(self.view).offset(kNavBarH);
    }];
    
    self.pageIndex = 1;
    
    [self.tableView.mj_header beginRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showTips {
    
    XLGShowTipsVC *vc = [[XLGShowTipsVC alloc] initWithTitle:@"集团用车"
                                                        tips:@"您尚未加入任何集团"
                                                   tipsImage:[UIImage imageNamed:@"group_tips"]];
    
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Method

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

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 3; //self.carListArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    XLGGroupCarListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[XLGGroupCarListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    if (indexPath.section == 0) {
        cell.model = @"1";
    }
    else {
        cell.model = @"2";
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 6;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    //    StationCarItem *carItem = self.carArr[indexPath.section];
    //    self.carBlock(carItem);
    
    //    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Lazy Loading

- (UITableView *)tableView {

    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.rowHeight = 100;

        //动画下拉刷新
        [self tableViewGifHeaderWithRefreshingBlock:^{
            [self getData];
        }];
        
        //动画加载更多
        [self tableViewGifFooterWithRefreshingBlock:^{
            [self loadMoreData];
        }];
    }

    return _tableView;
}

- (NSMutableArray *)carListArr {
    
    if (!_carListArr) {
        _carListArr = [[NSMutableArray alloc] init];
    }
    return _carListArr;
}

- (NSArray *)currentBackCarListArr {
    
    if (!_currentBackCarListArr) {
        _currentBackCarListArr = [[NSMutableArray alloc] init];
    }
    
    return _currentBackCarListArr;
}

@end
