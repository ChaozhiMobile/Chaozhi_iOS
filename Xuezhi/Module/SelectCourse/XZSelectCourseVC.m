//
//  XZSelectCourseVC.m
//  Xuezhi
//
//  Created by Jason_zyl on 2019/7/28.
//  Copyright © 2019 Jason_hzb. All rights reserved.
//

#import "XZSelectCourseVC.h"
#import "XZSelectCourseTabCell.h"
#import "CourseCategoryItem.h"
#import "CourseItem.h"

#define LineMaxCount 5
#define PageSize @"10"

@interface XZSelectCourseVC ()

@property (nonatomic, retain) NSMutableArray <CourseCategoryItem *>*titleArr;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, retain) CourseCategoryItem *categoryItem;
@property (nonatomic, retain) NSMutableArray *dataArr;

@end

@implementation XZSelectCourseVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSString *selectIndexStr = [CacheUtil getCacherWithKey:kCourseCategoryKey];
    if (![NSString isEmpty:selectIndexStr]) {
        [self getCategoryList]; //获取课程分类
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"选课";
    
    self.dataArr = [NSMutableArray array];
    
    NSString *selectIndexStr = [CacheUtil getCacherWithKey:kCourseCategoryKey];
    if ([NSString isEmpty:selectIndexStr]) {
        [self getCategoryList]; //获取课程分类
    }
}

#pragma mark - 课程分类
- (void)getCategoryList {
    NSDictionary *dic = [NSDictionary dictionary];
    [[NetworkManager sharedManager] postJSON:URL_CategoryList parameters:dic completion:^(id responseData, RequestState status, NSError *error) {
        if (status == Request_Success) {
            self.titleArr = [CourseCategoryItem mj_objectArrayWithKeyValuesArray:(NSArray *)responseData];
//            [self.titleArr addObjectsFromArray:self.titleArr];
            if (self.titleArr.count>0) {
                self.categoryItem = self.titleArr[0];
                [self initView];
                NSString *selectIndexStr = [CacheUtil getCacherWithKey:kCourseCategoryKey];
                if (![NSString isEmpty:selectIndexStr]) {
                    UIButton *btn = [self.titleBgScrollView viewWithTag:1000+[selectIndexStr integerValue]];
                    [self titleClickAction:btn];
                    [CacheUtil saveCacher:kCourseCategoryKey withValue:@""];
                } else {
                    UIButton *btn = [self.titleBgScrollView viewWithTag:1000];
                    [self titleClickAction:btn];
                }
            }
        }
    }];
}

#pragma mark - init view

- (void)initView {
    
    [_titleBgScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)]; //移除所有子视图
    
    CGFloat viewW = WIDTH/(MIN(_titleArr.count, LineMaxCount));
    CGFloat viewLeft = 0;
    for (NSInteger index = 0; index<_titleArr.count; index++) {
        CourseCategoryItem *item = _titleArr[index];
        viewW = [item.name getTextWidthWithFont:[UIFont systemFontOfSize:15] height:50]+40;
        UIButton *sender = [[UIButton alloc] initWithFrame:CGRectMake(viewLeft, 0, viewW, 50)];
        sender.titleLabel.font = [UIFont systemFontOfSize:15];
        [sender setTitle:item.name forState:UIControlStateNormal];
        [sender setTitleColor:kBlackColor forState:UIControlStateNormal];
        [sender setTitleColor:AppThemeColor forState:UIControlStateSelected];
        [sender addTarget:self action:@selector(titleClickAction:) forControlEvents:UIControlEventTouchUpInside];
        sender.tag = 1000+index;
        [_titleBgScrollView addSubview:sender];
        
        _titleLineView = [[UIView alloc]initWithFrame:CGRectMake(0, 47, 0, 3)];
        _titleLineView.backgroundColor = AppThemeColor;
        [_titleBgScrollView addSubview:_titleLineView];
        
        viewLeft = sender.right;
    }
    _titleBgScrollView.contentSize = CGSizeMake(viewLeft, 0);
    
    _mainTabView.tableFooterView = [[UIView alloc] init];
    _mainTabView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //下拉刷新要做的操作
        self.currentPage = 1;
        [self loadData];
    }];
}

#pragma mark - methods

/** 标题点击 */
- (IBAction)titleClickAction:(UIButton *)sender {
    
    NSInteger index = sender.tag-1000;
    self.categoryItem = self.titleArr[index];
    _currentPage = 1;
    [self loadData];
    
    sender.selected = YES;
    for (NSInteger tag = 0; tag<_titleArr.count; tag++) {
        UIButton *btn = [self.view viewWithTag:tag+1000];
        if (![btn isEqual:sender]) {
            btn.selected = NO;
        }
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        self.titleLineView.width = sender.width;
        self.titleLineView.centerX = sender.centerX;
        CGFloat right = sender.right;
        if (right<WIDTH) {
            self.titleBgScrollView.contentOffset = CGPointMake(0, 0);
        }
        if (right>WIDTH) {
            if (index<self.titleArr.count-1) {
                self.titleBgScrollView.contentOffset = CGPointMake(right-WIDTH+35, 0);
            } else {
                self.titleBgScrollView.contentOffset = CGPointMake(right-WIDTH, 0);
            }
        }
    }];
}

#pragma mark - 课程列表

/** 获取课程列表数据 */
- (void)loadData {
    
    if (_currentPage == 1) {
        [_dataArr removeAllObjects];
    }
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         [NSString stringWithFormat:@"%ld", _currentPage], @"p",
                         PageSize, @"offset",
                         _categoryItem.ID, @"category_id",
                         nil];
    [[NetworkManager sharedManager] postJSON:URL_ProductList parameters:dic completion:^(id responseData, RequestState status, NSError *error) {

        [self.mainTabView.mj_header endRefreshing];
        [self.mainTabView.mj_footer endRefreshing];

        if (status == Request_Success) {

            NSArray *array = [CourseItem mj_objectArrayWithKeyValuesArray:responseData[@"rows"]];
            [self.dataArr addObjectsFromArray:array];

            NSString *total = responseData[@"total"];
            if (self.dataArr.count == [total integerValue]) {
                self.mainTabView.mj_footer = nil;
            } else {
                self.mainTabView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                    //上拉加载需要做的操作
                    [self loadMoreData];
                }];
            }

            [self.mainTabView reloadData];
        }
    }];
}

/** 加载更多数据 */
- (void)loadMoreData {
    _currentPage++;
    [self loadData];
}

#pragma mark - UITableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XZSelectCourseTabCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XZSelectCourseTabCell"];
    cell.item = _dataArr[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    CourseItem *item = _dataArr[indexPath.row];
    [BaseWebVC showWithContro:self withUrlStr:[NSString stringWithFormat:@"%@%@",H5_StoreProduct,item.ID] withTitle:@"" isPresent:NO];
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
