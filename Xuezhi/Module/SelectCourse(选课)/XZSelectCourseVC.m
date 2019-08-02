//
//  XZSelectCourseVC.m
//  Xuezhi
//
//  Created by Jason_zyl on 2019/7/28.
//  Copyright © 2019 Jason_hzb. All rights reserved.
//

#import "XZSelectCourseVC.h"
#import "XZSelectCourseTabCell.h"
#import "CourseItem.h"

#define LineMaxCount 5

@interface XZSelectCourseVC ()

@property (nonatomic, retain) NSMutableArray <CourseItem *>*titleArr;

@end

@implementation XZSelectCourseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"选课";
    
    [self getCategoryList];
}

#pragma mark - 课程分类
- (void)getCategoryList {
    __weak typeof(self) weakSelf = self;
    NSDictionary *dic = [NSDictionary dictionary];
    [[NetworkManager sharedManager] postJSON:URL_CategoryList parameters:dic completion:^(id responseData, RequestState status, NSError *error) {
        if (status == Request_Success) {
            weakSelf.titleArr = [CourseItem mj_objectArrayWithKeyValuesArray:(NSArray *)responseData];
            [weakSelf initView];
        }
    }];
}

#pragma mark - init view

- (void)initView {
    CGFloat viewW = WIDTH/(MIN(_titleArr.count, LineMaxCount));
    CGFloat viewLeft = 0;
    for (NSInteger index = 0; index<_titleArr.count; index++) {
        CourseItem *item = _titleArr[index];
        UIButton *sender = [[UIButton alloc] initWithFrame:CGRectMake(viewLeft, 0, viewW, autoScaleW(50))];
        viewLeft = sender.right;
        sender.titleLabel.font = [UIFont systemFontOfSize:14];
        [sender setTitle:item.name forState:UIControlStateNormal];
        [sender setTitleColor:kBlackColor forState:UIControlStateNormal];
        [sender setTitleColor:AppThemeColor forState:UIControlStateSelected];
        [sender addTarget:self action:@selector(titleClickAction:) forControlEvents:UIControlEventTouchUpInside];
        sender.tag = 1000+index;
        [_titleBgScrollView addSubview:sender];
    }
    _titleBgScrollView.contentSize = CGSizeMake(viewLeft, 0);
    _titleLineView = [[UIView alloc]initWithFrame:CGRectMake(0, 47, viewW, 3)];
    _titleLineView.backgroundColor = AppThemeColor;
    [_titleBgScrollView addSubview:_titleLineView];
    _mainTabView.tableFooterView = [[UIView alloc]init];
}

#pragma mark - methods

/** 标题点击 */
- (IBAction)titleClickAction:(UIButton *)sender {
    sender.selected = YES;
    [sender setTitleColor:AppThemeColor forState:UIControlStateSelected];
    for (NSInteger tag = 0; tag<_titleArr.count; tag++) {
        UIButton *btn = [self.view viewWithTag:tag+1000];
        if (![btn isEqual:sender]) {
            btn.selected = NO;
        }
        [btn setTitleColor:AppThemeColor forState:UIControlStateSelected];
    }
    [UIView animateWithDuration:0.3 animations:^{
        self.titleLineView.centerX = sender.centerX;
    }];
}

#pragma mark - UITableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XZSelectCourseTabCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XZSelectCourseTabCell"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
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
