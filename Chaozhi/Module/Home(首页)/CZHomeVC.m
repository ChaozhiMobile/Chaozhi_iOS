//
//  CZHomeVC.m
//  Chaozhi
//
//  Created by Jason_zyl on 2018/9/22.
//  Copyright © 2018年 Jason_hzb. All rights reserved.
//

#import "CZHomeVC.h"
#import "CZSelectCourseVC.h"
#import <SDCycleScrollView.h>
#import "HomeInfoItem.h"

@implementation DayNewTabCell
@end

@interface CZHomeVC ()<UITableViewDataSource,UITableViewDelegate>
{
    
}
@property (nonatomic , retain) HomeInfoItem *homeItem;
@property (nonatomic , retain) HomeCategoryItem *categoryItems;;
@property (weak, nonatomic) IBOutlet UIScrollView *bgScrollView;
@property (weak, nonatomic) IBOutlet SDCycleScrollView *bannerView;
@property (weak, nonatomic) IBOutlet UIImageView *courseImgView1;
@property (weak, nonatomic) IBOutlet UILabel *courseTeaNameLB1;
@property (weak, nonatomic) IBOutlet UIImageView *courseImgView2;
@property (weak, nonatomic) IBOutlet UILabel *courseTeaNameLB2;
@property (weak, nonatomic) IBOutlet UIImageView *publicCourseImgView;
@property (weak, nonatomic) IBOutlet UILabel *publicTitleLB;
@property (weak, nonatomic) IBOutlet UILabel *publicTeaLB;
@property (weak, nonatomic) IBOutlet UIImageView *activityImgView;
@property (weak, nonatomic) IBOutlet UILabel *activityTitleLB;
@property (weak, nonatomic) IBOutlet UILabel *activityContentLB;
@property (weak, nonatomic) IBOutlet UIImageView *goldTeaImgView1;
@property (weak, nonatomic) IBOutlet UILabel *goldTeaNameLB1;
@property (weak, nonatomic) IBOutlet UILabel *goldTeaTypeLB1;
@property (weak, nonatomic) IBOutlet UIImageView *goldTeaImgView2;
@property (weak, nonatomic) IBOutlet UILabel *goldTeaNameLB2;
@property (weak, nonatomic) IBOutlet UILabel *goldTeaTypeLB2;
@property (weak, nonatomic) IBOutlet UITableView *newsTabView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lastViewHConstraints;
@property (weak, nonatomic) IBOutlet UIButton *showMorePublicCourseAction;

- (IBAction)showMoreCourseAction:(UIButton *)sender;
- (IBAction)showPublicCourseAction:(id)sender;
- (IBAction)showActivityDetailAction:(id)sender;

@end

@implementation CZHomeVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _homeItem = [[HomeInfoItem alloc]init];
    _categoryItems = [[HomeCategoryItem alloc]init];
    NSString *selectCourseID = [CacheUtil getCacherWithKey:kSelectCourseIDKey];
    if ([NSString isEmpty:selectCourseID]&&(![NSString isEmpty:[UserInfo share].token])) {
        CZSelectCourseVC *vc = [[CZSelectCourseVC alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.selectCourseBlock = ^(CourseItem *item) {
            NSLog(@"选择课程ID: %@",item.ID);
            [self refreshCourseUI];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
    _lastViewHConstraints.constant = 5*100+40;
    
    [self getData];
}

#pragma mark - get data

- (void)getData {
    
    [self getBannerActivityData];
    [self refreshCourseUI];
}

// 获取banner、活动数据
- (void) getBannerActivityData {
    NSDictionary *dic = [NSDictionary dictionary];
    __weak typeof(self) weakSelf = self;
    [[NetworkManager sharedManager] postJSON:URL_AppHome parameters:dic completion:^(id responseData, RequestState status, NSError *error) {
        weakSelf.homeItem = [HomeInfoItem yy_modelWithJSON:responseData];
        [weakSelf refreshBannerUI];
        [weakSelf refreshActivityUI];
    }];
}


// 根据课程ID刷新数据
- (void)refreshCourseUI {
    NSString *selectCourseID = [CacheUtil getCacherWithKey:kSelectCourseIDKey];
    if (![NSString isEmpty:selectCourseID]) {
        __weak typeof(self) weakSelf = self;
        [[NetworkManager sharedManager] postJSON:URL_Category parameters:@{@"category_id":selectCourseID} completion:^(id responseData, RequestState status, NSError *error) {
            weakSelf.categoryItems = [HomeCategoryItem yy_modelWithJSON:responseData];
            [weakSelf refreshTeacherUI];
            [weakSelf refreshVedioUI];
            [weakSelf refreshFeaCourseUI];
        }];
    }
}

#pragma mark - methods

//课程分类
- (IBAction)selectCourseAction:(id)sender {
    CZSelectCourseVC *vc = [[CZSelectCourseVC alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.selectCourseBlock = ^(CourseItem *item) {

        [self refreshCourseUI];
    };
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)refreshBannerUI{
    NSMutableArray *bannerImgUrlArr = [NSMutableArray array];
    for (NSInteger i = 0; i < _homeItem.banner_list.count; i ++) {
        HomeBannerItem *item = _homeItem.banner_list[i];
        NSString *imgUrl = [NSString stringWithFormat:@"http:%@",item.img];
        //        NSString *imgUrl = [NSString stringWithFormat:@"%@%@",domainUrl(),item.img];
        [bannerImgUrlArr addObject:imgUrl];
    }
    _bannerView.imageURLStringsGroup = bannerImgUrlArr;
}

- (void)refreshActivityUI{
    HomeActivityItem *activityItem = [_homeItem.activity_list firstObject];
    _activityTitleLB.text = activityItem.title;
    [_activityImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http:%@",activityItem.img]]];
    _activityContentLB.text = activityItem.content;
}

- (void)refreshTeacherUI{
    HomeTeacherItem *teacherItem1,*teacherItem2;
    for (NSInteger i = 0; i < MIN(2, _categoryItems.teacher_list.count); i ++) {
        switch (i) {
            case 0:
                teacherItem1 = [_categoryItems.teacher_list firstObject];
                [_goldTeaImgView1 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http:%@",teacherItem1.photo]]];
                _goldTeaNameLB1.text = teacherItem1.name;
                _goldTeaTypeLB1.text = teacherItem1.info;
                break;
            case 1:
                teacherItem2 = _categoryItems.teacher_list[1];
                [_goldTeaImgView2 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http:%@",teacherItem2.photo]]];
                _goldTeaNameLB2.text = teacherItem2.name;
                _goldTeaTypeLB2.text = teacherItem2.info;
                break;
            default:
                break;
        }
    }
}

- (void)refreshVedioUI{
    HomeTryVideoItem *tryVideoItem = [_categoryItems.try_video_list firstObject];
    if (tryVideoItem) {
        [_publicCourseImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",tryVideoItem.img]]];
        _publicTeaLB.text = [NSString stringWithFormat:@"主讲讲师：%@",tryVideoItem.teacher];
        _publicTitleLB.text = tryVideoItem.title;
    }
}

- (void)refreshFeaCourseUI{
    HomeFeatureProductItem *feaCourseItem1,*feaCourseItem2;
    for (NSInteger i = 0; i < MIN(2, _categoryItems.feature_product_list.count); i ++) {
        switch (i) {
            case 0:
                feaCourseItem1 = [_categoryItems.feature_product_list firstObject];
                [_courseImgView1 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http:%@",feaCourseItem1.img]]];
                _courseTeaNameLB1.text = feaCourseItem1.name;
                break;
            case 1:
                feaCourseItem2 = _categoryItems.feature_product_list[1];
                [_courseImgView2 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http:%@",feaCourseItem2.img]]];
                _courseTeaNameLB2.text = feaCourseItem2.name;

                break;
            default:
                break;
        }
    }
}

- (IBAction)showMoreCourseAction:(UIButton *)sender {
    
}

- (IBAction)showPublicCourseAction:(id)sender {

}

- (IBAction)showActivityDetailAction:(id)sender {
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DayNewTabCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DayNewTabCellID"];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (void)didReceiveMemoryWarning {
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
