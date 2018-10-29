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

#define TEACHERNUM 2.5

@implementation DayNewTabCell
@end

@interface CZHomeVC ()<UITableViewDataSource,UITableViewDelegate>
{
    
}
@property (nonatomic , assign) NSInteger page;
@property (nonatomic , retain) HomeInfoItem *homeItem;
@property (nonatomic , retain) HomeCategoryItem *categoryItems;;
@property (nonatomic , retain) HomeNewsListItem *newsItems;;
@property (nonatomic , retain) NSMutableArray <HomeNewsItem *> *newsDatsSource;
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
@property (weak, nonatomic) IBOutlet UIButton *showMorePublicCourseAction;

@property (weak, nonatomic) IBOutlet UIScrollView *teacherScroView;
- (IBAction)showMoreCourseAction:(UIButton *)sender;
- (IBAction)showPublicCourseAction:(id)sender;
- (IBAction)showActivityDetailAction:(id)sender;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *courseViewHConstraint;//默认210
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *publicViewHConstraint;//默认170

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *activityViewHContraints;//默认140
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *teacherViewHContraints;//默认220
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lastViewHConstraints;

@end

@implementation CZHomeVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navBar.hidden = YES;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    
    return UIStatusBarStyleDefault;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _homeItem = [[HomeInfoItem alloc]init];
    _categoryItems = [[HomeCategoryItem alloc]init];
    _newsItems = [[HomeNewsListItem alloc]init];
    _newsDatsSource = [NSMutableArray array];
    _page = 1;
    NSString *selectCourseID = [CacheUtil getCacherWithKey:kSelectCourseIDKey];
    __weak typeof(self) weakSelf = self;
    if ([NSString isEmpty:selectCourseID]) {
        CZSelectCourseVC *vc = [[CZSelectCourseVC alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.selectCourseBlock = ^(CourseItem *item) {
            NSLog(@"选择课程ID: %@",item.ID);
            weakSelf.page = 1;
            weakSelf.bgScrollView.contentOffset = CGPointMake(0, 0);
            [self requestCourseData];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
    _lastViewHConstraints.constant = 40;
    [self getData];
    _bgScrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.page = 1;
        [weakSelf getData];
    }];
    _bgScrollView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf getData];
    }];
}

-(void)getData{
    [self getBannerActivityData];
    [self requestCourseData];
}

#pragma mark - get data
// 获取banner、活动数据
- (void) getBannerActivityData {
    NSDictionary *dic = [NSDictionary dictionary];
    __weak typeof(self) weakSelf = self;
    [[NetworkManager sharedManager] postJSON:URL_AppHome parameters:dic completion:^(id responseData, RequestState status, NSError *error) {
        weakSelf.homeItem = [HomeInfoItem yy_modelWithJSON:responseData];
        [weakSelf refreshBannerUI];
        [weakSelf refreshActivityUI];
        if ([weakSelf.bgScrollView.mj_header isRefreshing]) {
            [weakSelf.bgScrollView.mj_header endRefreshing];
        }
        if ([weakSelf.bgScrollView.mj_footer isRefreshing]) {
            [weakSelf.bgScrollView.mj_footer endRefreshing];
        }
    }];
}

// 根据课程ID刷新数据
- (void)requestCourseData {
    NSString *selectCourseID = [CacheUtil getCacherWithKey:kSelectCourseIDKey];
    if (![NSString isEmpty:selectCourseID]) {
        __weak typeof(self) weakSelf = self;
        [[NetworkManager sharedManager] postJSON:URL_Category parameters:@{@"category_id":selectCourseID} completion:^(id responseData, RequestState status, NSError *error) {
            if ([weakSelf.bgScrollView.mj_header isRefreshing]) {
                [weakSelf.bgScrollView.mj_header endRefreshing];
            }
            if ([weakSelf.bgScrollView.mj_footer isRefreshing]) {
                [weakSelf.bgScrollView.mj_footer endRefreshing];
            }
            weakSelf.categoryItems = [HomeCategoryItem yy_modelWithJSON:responseData];
            [weakSelf refreshFeaCourseUI];
            [weakSelf refreshVedioUI];
            [weakSelf refreshTeacherUI];
        }];
        
        [[NetworkManager sharedManager] postJSON:URL_NewsList parameters:@{@"category_id":@"",@"p":@(_page),@"offset":@"5",@"news_category_id":@""} completion:^(id responseData, RequestState status, NSError *error) {

            weakSelf.newsItems = [HomeNewsListItem yy_modelWithJSON:responseData];
            if (weakSelf.page==1) {
                [weakSelf.newsDatsSource removeAllObjects];
                weakSelf.lastViewHConstraints.constant = 40 ;
            }
            
            if (weakSelf.newsDatsSource.count<weakSelf.newsItems.total) {
                weakSelf.page++;
                [weakSelf.newsDatsSource addObjectsFromArray:            weakSelf.newsItems.rows];
                weakSelf.bgScrollView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                    [weakSelf getData];
                }];
            } else {
                weakSelf.bgScrollView.mj_footer = nil;
            }
            weakSelf.lastViewHConstraints.constant = 40 + weakSelf.newsDatsSource.count*100;
            [weakSelf.newsTabView reloadData];
        }];
    }
}

#pragma mark - methods
//课程分类
- (IBAction)selectCourseAction:(id)sender {
    CZSelectCourseVC *vc = [[CZSelectCourseVC alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.selectCourseBlock = ^(CourseItem *item) {
        [self requestCourseData];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Banner

- (void)refreshBannerUI{
    NSMutableArray *bannerImgUrlArr = [NSMutableArray array];
    for (NSInteger i = 0; i < _homeItem.banner_list.count; i ++) {
        HomeBannerItem *item = _homeItem.banner_list[i];
        NSString *imgUrl = [NSString stringWithFormat:@"http:%@",item.img];
        [bannerImgUrlArr addObject:imgUrl];
    }
    _bannerView.imageURLStringsGroup = bannerImgUrlArr;
}

#pragma mark - 精彩活动

- (void)refreshActivityUI{
    if (_homeItem.activity_list.count==0) {
        _activityViewHContraints.constant = 0;
        return;
    }
    _activityViewHContraints.constant = 140;
    HomeActivityItem *activityItem = [_homeItem.activity_list firstObject];
    _activityTitleLB.text = activityItem.title;
    [_activityImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http:%@",activityItem.img]] placeholderImage:[UIImage imageNamed:@"default_rectangle_img"]];
    _activityContentLB.text = activityItem.subtitle;
}

#pragma mark - 金牌讲师

- (void)refreshTeacherUI{
    [_teacherScroView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    if (_categoryItems.teacher_list.count==0) {
        _teacherViewHContraints.constant = 0;
        return;
    }
    _teacherScroView.contentOffset = CGPointMake(0, 0);
    NSInteger count = _categoryItems.teacher_list.count;
    CGFloat blankSpace = 15;
    NSInteger num = TEACHERNUM;
    CGFloat viewWidth = (WIDTH-blankSpace*(num+1))/TEACHERNUM;
    CGFloat viewHeight = viewWidth*1.176+10+20*5;
    _teacherViewHContraints.constant = viewHeight+40;
    _teacherScroView.contentSize = CGSizeMake((blankSpace*(count+1))+viewWidth*count,0);
    _teacherViewHContraints.constant = viewHeight+40;
    for (NSInteger i = 0; i < count; i ++) {
        HomeTeacherItem *teacherItem = _categoryItems.teacher_list[i];
        UIView *view = [[[NSBundle mainBundle]loadNibNamed:@"TeacherView" owner:self options:nil]firstObject];
        view.tag = 1000+i;
        view.frame = CGRectMake(blankSpace*(i+1)+viewWidth*i, 0, viewWidth, viewHeight);
        UIImageView *img = [view viewWithTag:1];
        [img sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http:%@",teacherItem.photo]] placeholderImage:[UIImage imageNamed:@"default_rectangle_img"]];
        UILabel *nameLB = [view viewWithTag:2];
        nameLB.text = teacherItem.name;
        UILabel *detailLB = [view viewWithTag:3];
        detailLB.text = teacherItem.info;
        [_teacherScroView addSubview:view];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(jumpTeacherDetail:)];
        [view addGestureRecognizer:tap];
    }
}

- (void)jumpTeacherDetail:(UITapGestureRecognizer *)tap {
    UIView *view = tap.view;
    NSInteger index = view.tag - 1000;
}

- (void)refreshVedioUI{
    if (_categoryItems.try_video_list.count==0) {
        _publicViewHConstraint.constant = 0;
        return;
    }
    _publicViewHConstraint.constant = 170;
    HomeTryVideoItem *tryVideoItem = [_categoryItems.try_video_list firstObject];
    _publicCourseImgView.image = nil;
    _publicTeaLB.text = @"";
    _publicTitleLB.text = @"";
    if (tryVideoItem) {
        [_publicCourseImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",tryVideoItem.img]] placeholderImage:[UIImage imageNamed:@"default_live"]];
        _publicTeaLB.text = [NSString stringWithFormat:@"主讲讲师：%@",tryVideoItem.teacher];
        _publicTitleLB.text = tryVideoItem.title;
    }
}

- (void)refreshFeaCourseUI{
    if (_categoryItems.feature_product_list.count==0) {
        _courseViewHConstraint.constant = -10;
        return;
    }
    _courseViewHConstraint.constant = 210;
    HomeFeatureProductItem *feaCourseItem1,*feaCourseItem2;
    _courseImgView1.image = nil;
    _courseTeaNameLB1.text = @"";
    _courseImgView1.image = nil;
    _courseTeaNameLB1.text = @"";
    for (NSInteger i = 0; i < MIN(2, _categoryItems.feature_product_list.count); i ++) {
        switch (i) {
            case 0:
                feaCourseItem1 = [_categoryItems.feature_product_list firstObject];
                [_courseImgView1 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http:%@",feaCourseItem1.img]] placeholderImage:[UIImage imageNamed:@"default_rectangle_img"]];
                _courseTeaNameLB1.text = feaCourseItem1.name;
                break;
            case 1:
                feaCourseItem2 = _categoryItems.feature_product_list[1];
                [_courseImgView2 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http:%@",feaCourseItem2.img]] placeholderImage:[UIImage imageNamed:@"default_rectangle_img"]];
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
    return _newsDatsSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DayNewTabCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DayNewTabCellID"];
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    HomeNewsItem *item = _newsDatsSource[indexPath.row];
    [cell.dayNewIconImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http:%@",item.img]] placeholderImage:[UIImage imageNamed:@"default_square_img"]];
    cell.dayNewTitleLB.text = item.title;
    cell.dayNewContentLB.text = item.subtitle;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    HomeNewsItem *item = _newsDatsSource[indexPath.row];
    [BaseWebVC showWithContro:self withUrlStr:[NSString stringWithFormat:@"%@%@",H5_InfiniteNews,item.ID] withTitle:@"" isPresent:NO];
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
