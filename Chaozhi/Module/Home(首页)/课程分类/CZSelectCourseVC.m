//
//  CZSelectCourseVC.m
//  Chaozhi
//
//  Created by Jason_zyl on 2018/10/7.
//  Copyright © 2018年 Jason_hzb. All rights reserved.
//

#import "CZSelectCourseVC.h"
#import "CZSelectCourseCell.h"
#import "CourseItem.h"

@interface CZSelectCourseVC ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSMutableArray *_dataArr;
}
@end

@implementation CZSelectCourseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"关注课程";
    
    [self createUI];
    
    [self getData];
}

-(void)createUI {
    
    //初始化tableView
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavBarH, WIDTH, HEIGHT-kNavBarH) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = TableViewDefaultBGColor;
    _tableView.separatorColor = RGBValue(0xE0E0E1);
    _tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
    _tableView.tableFooterView = [UIView new];
    [self.view addSubview:_tableView];
    
//    //初始化model
//    _dataArray = [NSMutableArray array];
//    NSArray *titleArr = @[@"测试地址test-aci-api.chaozhiedu.com",
//                          @"正式地址aci-api.chaozhiedu.com",
//                          ];
//    for (int i = 0; i<titleArr.count; i++) {
//        CourseItem *model = [[CourseItem alloc] init];
//        model.selectStatus = [Utils getServer]==i?YES:NO;
//        model.name = titleArr[i];
//        [_dataArray addObject:model];
//    }
}

#pragma mark - get data

// 分类列表
- (void)getData {
    NSDictionary *dic = [NSDictionary dictionary];
    [[NetworkManager sharedManager] postJSON:URL_CategoryList parameters:dic imageDataArr:nil imageName:nil  completion:^(id responseData, RequestState status, NSError *error) {
        
        if (status == Request_Success) {
//            _dataArr = [CourseItem mj_objectArrayWithKeyValuesArray:(NSArray *)responseData];
        }
    }];
}

#pragma mark - UITableViewDelegate、UITableViewDataSource代理
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return autoScaleW(50);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArr.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIndentifier = @"ChangeServerCell";
    CZSelectCourseCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if (cell == nil) {
        cell = [[CZSelectCourseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    CourseItem *model = _dataArr[indexPath.row];
    [cell setContentWithModel:model];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [Utils setServer:indexPath.row];
    
    //改变数据源
    for (int i = 0; i<_dataArr.count; i++) {
        CourseItem *model = _dataArr[i];
        if (i==indexPath.row) {
            model.selectStatus = YES;
        } else {
            model.selectStatus = NO;
        }
    }
    
    //刷新tableView
    [_tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
