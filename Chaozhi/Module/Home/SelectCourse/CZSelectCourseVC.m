//
//  CZSelectCourseVC.m
//  Chaozhi
//
//  Created by Jason_zyl on 2018/10/7.
//  Copyright © 2018年 Jason_hzb. All rights reserved.
//

#import "CZSelectCourseVC.h"
#import "CZSelectCourseCell.h"

@interface CZSelectCourseVC ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,retain) NSMutableArray *dataArr;
@property (nonatomic,retain) CourseCategoryItem *selectItem;

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
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavBarH, WIDTH, HEIGHT-kNavBarH) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = TableViewDefaultBGColor;
    self.tableView.separatorColor = RGBValue(0xE0E0E1);
    self.tableView.separatorInset = UIEdgeInsetsMake(0, autoScaleW(20), 0, autoScaleW(20));
    self.tableView.tableFooterView = [UIView new];
    [self.view addSubview:self.tableView];
}

#pragma mark - methods

- (void)backAction {
    NSString *selectCourseID = [CacheUtil getCacherWithKey:kSelectCourseIDKey];
    if ([NSString isEmpty:selectCourseID]) {
        [Utils showToast:@"请先选择您关注的课程"];
    } else {
        if (self.selectCourseBlock) {
            self.selectCourseBlock(self.selectItem);
        }
        [super backAction];
    }
}

#pragma mark - get data

// 分类列表
- (void)getData {
    NSDictionary *dic = [NSDictionary dictionary];
    [[NetworkManager sharedManager] postJSON:URL_CategoryList parameters:dic completion:^(id responseData, RequestState status, NSError *error) {
        
        if (status == Request_Success) {
            self.dataArr = [CourseCategoryItem mj_objectArrayWithKeyValuesArray:(NSArray *)responseData];
            NSString *selectCourseID = [CacheUtil getCacherWithKey:kSelectCourseIDKey];
            for (int i = 0; i<self.dataArr.count; i++) {
                CourseCategoryItem *model = self.dataArr[i];
                if ([model.ID isEqualToString:selectCourseID]) {
                    model.selectStatus = YES;
                } else {
                    model.selectStatus = NO;
                }
            }
            [self.tableView reloadData];
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
    
    CourseCategoryItem *model = _dataArr[indexPath.row];
    [cell setContentWithModel:model];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    self.selectItem = _dataArr[indexPath.row];
    [CacheUtil saveCacher:kSelectCourseIDKey withValue:self.selectItem.ID];
    
    //改变数据源
    for (int i = 0; i<_dataArr.count; i++) {
        CourseCategoryItem *model = _dataArr[i];
        if (i==indexPath.row) {
            model.selectStatus = YES;
        } else {
            model.selectStatus = NO;
        }
    }
    
    //刷新tableView
    [self.tableView reloadData];
    [self backAction];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
