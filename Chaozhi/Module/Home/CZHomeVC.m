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
#import "VersionItem.h"
#import <StoreKit/StoreKit.h>
#import "CZUpdateView.h"
#import "CZStarView.h"
#import "VideoItem.h"
#import "TalkfunPlaybackViewController.h"

#define TEACHERNUM 2.5

#define TabHeadHeight 36

//@implementation DayNewTabCell
//@end

@interface CZHomeVC ()<UITableViewDataSource,UITableViewDelegate,SKStoreProductViewControllerDelegate, UpdateViewDelegate,SDCycleScrollViewDelegate>{
    NSArray *titleArr;
    NSArray *moreArr;
    NSMutableDictionary *headHeightDic;//tabviewHead高度
}
@property (nonatomic, strong) UIView *BGView;
@property (nonatomic, strong) CZUpdateView *updateView;

@property (nonatomic , assign) NSInteger page;
@property (nonatomic , retain) VersionItem *versionItem;
@property (nonatomic , retain) HomeInfoItem *homeItem;
@property (nonatomic , retain) HomeCategoryItem *categoryItems;
@property (nonatomic , retain) HomeNewsListItem *newsItems;
@property (nonatomic , retain) NSMutableArray <HomeNewsItem *> *newsDatsSource;
@property (nonatomic , retain) CourseItem *feaCourseItem1,*feaCourseItem2;
@property (weak, nonatomic) IBOutlet UIView *statuView;

/** 轮播图 */
@property (weak, nonatomic) IBOutlet SDCycleScrollView *bannerView;

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
    
    self.view.backgroundColor = RGBValue(0xf5f5f5);
//    [UIColor whiteColor];
    
    _statusH.constant = kStatusBarH;
    [_statuView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(kStatusBarH);
    }];
    
    if (![Utils getNetStatus]) {
        XLGAlertView *alert = [[XLGAlertView alloc] initWithTitle:@"温馨提醒" content:@"检测到您的网络异常，请检查网络" leftButtonTitle:@"" rightButtonTitle:@"我知道了"];
    }
    titleArr = @[@"推荐课程",@"我们的公开课",@"微课",@"精彩活动",@"金牌讲师",@"每日新知"];
    moreArr = @[@"更多课程>",@"更多公开课>",@"更多视频>",@"",@"",@""];
    headHeightDic = [NSMutableDictionary dictionary];
    _versionItem = [[VersionItem alloc] init];
    _homeItem = [[HomeInfoItem alloc] init];
    _categoryItems = [[HomeCategoryItem alloc] init];
    _newsItems = [[HomeNewsListItem alloc] init];
    _newsDatsSource = [NSMutableArray array];
    _page = 1;
    _bannerView.backgroundColor = PageColor;
    _bannerView.placeholderImage = [UIImage imageNamed:@"default_banner"];
    _bannerView.delegate = self;
    NSString *selectCourseID = [CacheUtil getCacherWithKey:kSelectCourseIDKey];
    __weak typeof(self) weakSelf = self;
    if ([NSString isEmpty:selectCourseID]) {
        CZSelectCourseVC *vc = [[CZSelectCourseVC alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.selectCourseBlock = ^(CourseCategoryItem *item) {
            NSLog(@"选择课程ID: %@",item.ID);
            weakSelf.page = 1;
//            weakSelf.bgScrollView.contentOffset = CGPointMake(0, 0);
            [weakSelf requestCourseData];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    _mainTabView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.page = 1;
        [weakSelf getData];
    }];
    _mainTabView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf getData];
    }];
    [_bannerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(weakSelf.view.mas_width);
        make.height.mas_equalTo(weakSelf.view.mas_width).multipliedBy(0.5);
    }];
    
    [self getData];
    
    [self checkVersion];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeServerSucc) name:kChangeServerSuccNotification object:nil]; //环境切换成功通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil]; //屏幕旋转监听
}

- (void)refreshData {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.mainTabView reloadData];
    });
}

- (void)changeServerSucc {
    _page = 1;
    [self getData];
}

- (void)getData {
    [self getBannerActivityData];
    [self requestCourseData];
}

#pragma mark - get data

//版本更新
- (void)checkVersion {
    __weak typeof(self) weakSelf = self;
    [[NetworkManager sharedManager] postJSON:URL_CheckVersion parameters:@{@"device":@"ios",@"version":AppVersion} completion:^(id responseData, RequestState status, NSError *error) {
        
        weakSelf.versionItem = [VersionItem yy_modelWithJSON:responseData];
        
        if ([weakSelf.versionItem.grade isEqualToString:@"2"]) { //推荐升级
            [weakSelf handleVersionUpdate:UpdateTypeSelect];
        }
        if ([weakSelf.versionItem.grade isEqualToString:@"3"]) { //强制升级
            [weakSelf handleVersionUpdate:UpdateTypeForce];
        }
    }];
}

- (void)handleVersionUpdate:(UpdateType)updateType {
    
    NSString *updateNote = self.versionItem.note;
    NSArray *array = [updateNote componentsSeparatedByString:@";"];
    NSString *formatUpdateNote = @"";
    for (int i = 0; i < array.count; i ++) {
        NSString *str = [NSString stringWithFormat:@"%@\n", array[i]];
        formatUpdateNote = [formatUpdateNote stringByAppendingString:str];
    }
    
    [self.view.window addSubview:self.BGView];
    _updateView = [[CZUpdateView alloc] initWithBugDetail:formatUpdateNote withType:updateType];
    _updateView.centerX = self.view.centerX;
    _updateView.centerY = self.view.centerY+kNavBarH/2;
    _updateView.delegate = self;
    [self.BGView addSubview:_updateView];
}

- (UIView *)BGView {
    if (!_BGView) {
        _BGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
        _BGView.backgroundColor = RGBA(0, 0, 0, 0.4);
    }
    return _BGView;
}

//取消更新
- (void)updateRejectBtnClicked {
    [self.BGView removeFromSuperview];
    [self.updateView removeFromSuperview];
}

//更新
- (void)updateBtnClicked {
    if ([self.versionItem.grade intValue] == 2) {
        [self.BGView removeFromSuperview];
        [self.updateView removeFromSuperview];
    }
    
    if (@available(iOS 10.0, *)) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.versionItem.url] options:@{} completionHandler:^(BOOL success) {
        }];
    } else {
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:self.versionItem.url]];
    }
}

// 获取banner、活动数据
- (void) getBannerActivityData {
    NSDictionary *dic = [NSDictionary dictionary];
    __weak typeof(self) weakSelf = self;
    [[NetworkManager sharedManager] postJSON:URL_AppHome parameters:dic completion:^(id responseData, RequestState status, NSError *error) {
        weakSelf.homeItem = [HomeInfoItem yy_modelWithJSON:responseData];
        [weakSelf refreshBannerUI];
        [weakSelf.mainTabView reloadData];
        if ([weakSelf.mainTabView.mj_header isRefreshing]) {
            [weakSelf.mainTabView.mj_header endRefreshing];
        }
        if ([weakSelf.mainTabView.mj_footer isRefreshing]) {
            [weakSelf.mainTabView.mj_footer endRefreshing];
        }
    }];
}

// 根据课程ID刷新数据
- (void)requestCourseData {
    NSString *selectCourseID = [CacheUtil getCacherWithKey:kSelectCourseIDKey];
    if (![NSString isEmpty:selectCourseID]) {
        __weak typeof(self) weakSelf = self;
        [[NetworkManager sharedManager] postJSON:URL_Category parameters:@{@"category_id":selectCourseID} completion:^(id responseData, RequestState status, NSError *error) {
            if ([weakSelf.mainTabView.mj_header isRefreshing]) {
                [weakSelf.mainTabView.mj_header endRefreshing];
            }
            if ([weakSelf.mainTabView.mj_footer isRefreshing]) {
                [weakSelf.mainTabView.mj_footer endRefreshing];
            }
            weakSelf.categoryItems = [HomeCategoryItem yy_modelWithJSON:responseData];
            [weakSelf.mainTabView reloadData];
        }];
        
        [[NetworkManager sharedManager] postJSON:URL_NewsList parameters:@{@"category_id":selectCourseID,@"p":@(_page),@"offset":@"5",@"news_category_id":@""} completion:^(id responseData, RequestState status, NSError *error) {

            weakSelf.newsItems = [HomeNewsListItem yy_modelWithJSON:responseData];
            if (weakSelf.page==1) {
                [weakSelf.newsDatsSource removeAllObjects];
            }
            
            if (weakSelf.newsDatsSource.count<weakSelf.newsItems.total) {
                weakSelf.page++;
                [weakSelf.newsDatsSource addObjectsFromArray:            weakSelf.newsItems.rows];
                weakSelf.mainTabView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                    [weakSelf getData];
                }];
            } else {
                weakSelf.mainTabView.mj_footer = nil;
            }
            [weakSelf.mainTabView reloadData];
        }];
    }
}

#pragma mark - methods
//课程分类
- (IBAction)selectCourseAction:(id)sender {
    __weak typeof(self) weakSelf = self;
    CZSelectCourseVC *vc = [[CZSelectCourseVC alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.selectCourseBlock = ^(CourseCategoryItem *item) {
        weakSelf.page = 1;
        [self requestCourseData];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Banner

- (void)refreshBannerUI{
    NSMutableArray *bannerImgUrlArr = [NSMutableArray array];
    for (NSInteger i = 0; i < _homeItem.banner_list.count; i ++) {
        HomeBannerItem *item = _homeItem.banner_list[i];
        [bannerImgUrlArr addObject:item.img];
    }
    _bannerView.imageURLStringsGroup = bannerImgUrlArr;
}

#pragma mark - SDCycleScrollViewDelegate

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    HomeBannerItem *item = _homeItem.banner_list[index];
    if (![NSString isEmpty:item.param]) {
        [BaseWebVC showWithContro:self withUrlStr:item.param withTitle:item.title isPresent:NO];
    }
}

#pragma mark - UITableView 代理
/** 代理 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 6;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==5) {
        return _newsDatsSource.count;
    }
    else {
        NSInteger count = 0;
        if (section==0) {
            count = _categoryItems.feature_product_list.count;
        }
        else if (section==1) {
            count = _categoryItems.try_video_list.count;
        }
        else if (section==2) {
            count = _categoryItems.weike_list.count;
        }
        else if (section==3) {
            count = _homeItem.activity_list.count;
        }
        else if (section==4) {
            count = _categoryItems.teacher_list.count;
        }
        CGFloat height = (count==0?1:TabHeadHeight);
        [headHeightDic setObject:@(height) forKey:@(section)];
        return count==0?0:1;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CZHomeBaseCell *cell;
    if (indexPath.section==0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"CZHomeCourseCell"];
        CZHomeCourseCell *tempCell = (CZHomeCourseCell *)cell;
        NSInteger count = _categoryItems.feature_product_list.count;
        NSArray *arr = @[tempCell.leftView,tempCell.rightView];
        for (NSInteger index = 0; index<MIN(2, count); index++) {
            UIView *bgView = arr[index];
            CourseItem *item = _categoryItems.feature_product_list[index];
            UIImageView *imgView = [bgView viewWithTag:1000];
            UILabel *priceLab = [bgView viewWithTag:1001];
            UILabel *oldPriceLab = [bgView viewWithTag:1002];
            UILabel *titleLab = [bgView viewWithTag:1003];
            UILabel *countLab = [bgView viewWithTag:1004];
            CZStarView *starView = [bgView viewWithTag:1005];
            UIButton *sender = [bgView viewWithTag:1006];
            [imgView sd_setImageWithURL:[NSURL URLWithString:item.img] placeholderImage:[UIImage imageNamed:@"default_course"]];
            priceLab.text = item.price;
            oldPriceLab.text = item.original_price;
            titleLab.text = item.name;
            countLab.text = item.review_num;
            starView.score = [item.review_star floatValue];
            [sender setTitle:item.ID forState:UIControlStateNormal];
            [sender addTarget:self action:@selector(coureseDetail:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    else if (indexPath.section==1) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"CZHomePublicCell"];
        HomeTryVideoItem *tryVideoItem = [_categoryItems.try_video_list firstObject];
        [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",tryVideoItem.img]] placeholderImage:[UIImage imageNamed:@"default_course"]];
        cell.titleLab.text = tryVideoItem.title;
        cell.contentLab.text = [NSString stringWithFormat:@"主讲讲师：%@",tryVideoItem.teacher];
        cell.dataSource = tryVideoItem;
    }
    else if (indexPath.section==2) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"CZHomeWeiKeCell"];
        HomeWeikeItem *weikeItem = [_categoryItems.weike_list firstObject];
        CZHomeWeiKeCell *tempCell = (CZHomeWeiKeCell *)cell;
        [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",weikeItem.cover]] placeholderImage:[UIImage imageNamed:@"default_course"]];
        cell.titleLab.text = weikeItem.title;
        cell.contentLab.text = weikeItem.teacher_name;
        tempCell.countLab.text = [NSString stringWithFormat:@"%@人观看",weikeItem.play_num];
        cell.dataSource = weikeItem;
    }
    else if (indexPath.section==3) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"CZHomeActivityCell"];
        HomeActivityItem *activityItem = [_homeItem.activity_list firstObject];
        cell.titleLab.text = activityItem.title;
        [cell.imgView sd_setImageWithURL:[NSURL URLWithString:activityItem.img] placeholderImage:[UIImage imageNamed:@"default_rectangle_img"]];
        cell.contentLab.text = activityItem.subtitle;
        cell.dataSource = activityItem;
    }
    else if (indexPath.section==4) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"CZHomeGoldTeacherCell"];
        CZHomeGoldTeacherCell *tempCell = (CZHomeGoldTeacherCell *)cell;
        [self refreshTeacherUI:tempCell.teacherScroView];
    }
    else if (indexPath.section==5) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"CZHomeNewsCell"];
        CZHomeNewsCell *tempCell = (CZHomeNewsCell *)cell;
        HomeNewsItem *item = _newsDatsSource[indexPath.row];
        [tempCell.imgView sd_setImageWithURL:[NSURL URLWithString:item.img] placeholderImage:[UIImage imageNamed:@"default_square_img"]];
        tempCell.titleLab.text = item.title;
        tempCell.contentLab.text = item.subtitle;
        tempCell.timeLab.text = item.ct;
        cell.dataSource = item;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    NSInteger count = 0;
    if (section==0) {
        count = _categoryItems.feature_product_list.count;
    }
    else if (section==1) {
        count = _categoryItems.try_video_list.count;
    }
    else if (section==2) {
        count = _categoryItems.weike_list.count;
    }
    else if (section==3) {
        count = _homeItem.activity_list.count;
    }
    else if (section==4) {
        count = _categoryItems.teacher_list.count;
    }
    else if (section==5) {
        count = _newsDatsSource.count;
    }
    if (count==0) {
        return 0.000001;
    }
    return  TabHeadHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    CGFloat height = [[headHeightDic objectForKey:@(section)] floatValue];
    if (height==0) {
        return 1;
    }
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, TabHeadHeight)];
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.clipsToBounds = YES;
    UIImageView *leftIcon = [[UIImageView alloc]init];
    leftIcon.image = [UIImage imageNamed:@"home_title_one"];
    [bgView addSubview:leftIcon];
    
    UILabel *titleLab = [[UILabel alloc]init];
    titleLab.font = [UIFont systemFontOfSize:14];
    [bgView addSubview:titleLab];
    titleLab.text = titleArr[section];
    
    UIButton *sender = [[UIButton alloc]init];
    [sender setTitleColor:kBlackColor forState:UIControlStateNormal];
    sender.titleLabel.font = [UIFont systemFontOfSize:13];
    [sender setTitle:moreArr[section] forState:UIControlStateNormal];
    [sender addTarget:self action:@selector(showMoreAction:) forControlEvents:UIControlEventTouchUpInside];
    sender.tag = 100+section;
    [bgView addSubview:sender];
    
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = RGBValue(0xe6e6e6);
    [bgView addSubview:lineView];

    if (section==4) {
        bgView.backgroundColor = self.view.backgroundColor;
        lineView.backgroundColor = self.view.backgroundColor;
    }
    
    [leftIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(bgView).offset(12);
        make.centerY.mas_equalTo(bgView);
    }];
    
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(leftIcon).offset(10);
        make.centerY.mas_equalTo(bgView);
    }];
    
    [sender mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(bgView).offset(-4);
        make.top.bottom.mas_equalTo(bgView);
        make.width.mas_equalTo(100);
    }];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(bgView);
        make.height.mas_equalTo(1);
    }];
    
    
    return bgView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *bgView = [[UIView alloc]init];
    bgView.backgroundColor = self.view.backgroundColor;
    return bgView;
}

#pragma mark - 点击详情
/** 点击详情 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CZHomeBaseCell *tabCell = (CZHomeBaseCell *)[tableView cellForRowAtIndexPath:indexPath];
    if (indexPath.section==1) {//我们公开课点击
        HomeTryVideoItem *tryVideoItem = tabCell.dataSource;
        VideoItem *item = [[VideoItem alloc] init];
        item.live_id = tryVideoItem.live_id;
        item.product_id = @"0";
        item.type = @"1";
        TalkfunPlaybackViewController *vc = [[TalkfunPlaybackViewController alloc] init];
        vc.res = [[NSDictionary alloc] initWithObjectsAndKeys:@{@"access_token":tryVideoItem.access_token},@"data", nil];
        vc.playbackID = item.live_id;
        vc.videoItem = item;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (indexPath.section==2) {//微课点击
        HomeWeikeItem *weikeItem = tabCell.dataSource;
        [BaseWebVC showWithContro:self withUrlStr:[NSString stringWithFormat:@"%@%@",H5_WeikeDetail,weikeItem.ID] withTitle:weikeItem.title isPresent:NO];
    }
    else if (indexPath.section==3) {//精彩活动点击
           HomeActivityItem *activityItem = tabCell.dataSource;
           [BaseWebVC showWithContro:self withUrlStr:[NSString stringWithFormat:@"%@%@",H5_InfiniteNews,activityItem.ID] withTitle:@"" isPresent:NO];
       }
    else if (indexPath.section==4) {
           
       }
    else if (indexPath.section==5) {//活动点击
           HomeNewsItem *item = _newsDatsSource[indexPath.row];
           [BaseWebVC showWithContro:self withUrlStr:[NSString stringWithFormat:@"%@%@",H5_InfiniteNews,item.ID] withTitle:@"" isPresent:NO];
    }
    else if (indexPath.section==0) {
           
    }
}

#pragma mark - 更多点击
/** 更多点击 */
- (void)showMoreAction:(UIButton *)sender {
    NSInteger index = sender.tag-100;
    if (index==0) {//更多课程
        NSString *selectCourseID = [CacheUtil getCacherWithKey:kSelectCourseIDKey];
        [BaseWebVC showWithContro:self withUrlStr:[NSString stringWithFormat:@"%@%@",H5_Store,selectCourseID] withTitle:@"" isPresent:NO];
    }
    else if (index==1) {// 更多公开课
        [BaseWebVC showWithContro:self withUrlStr:H5_StoreFree withTitle:@"" isPresent:NO];
    }
    else if (index==2) {
        [BaseWebVC showWithContro:self withUrlStr:H5_WeikeList withTitle:@"" isPresent:NO];
    }
}

#pragma mark - 金牌讲师

- (void)refreshTeacherUI:(UIScrollView *)scroll{
    [scroll.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    scroll.contentOffset = CGPointMake(0, 0);
    NSInteger count = _categoryItems.teacher_list.count;
    CGFloat blankSpace = 15;
    NSInteger num = TEACHERNUM;
    CGFloat viewWidth = (WIDTH-blankSpace*(num+1))/TEACHERNUM;
    CGFloat viewHeight = viewWidth*1.176+10+20*5;

    scroll.contentSize = CGSizeMake((blankSpace*(count+1))+viewWidth*count,0);
    [scroll mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(viewHeight+20);
        make.width.mas_equalTo(scroll.superview.mas_width);
    }];
    UIView *contentView = [[UIView alloc]init];;
    contentView.backgroundColor = [UIColor clearColor];
    [scroll addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo (scroll);
        make.height.mas_equalTo (scroll); //此处没有设置宽的约束
    }];
    
    UIView *lastView;
    
    for (NSInteger i = 0; i < count; i ++) {
        HomeTeacherItem *teacherItem = _categoryItems.teacher_list[i];
        UIView *view = [[[NSBundle mainBundle]loadNibNamed:@"TeacherView" owner:self options:nil]firstObject];
        view.tag = 1000+i;
        view.frame = CGRectMake(blankSpace*(i+1)+viewWidth*i, 0, viewWidth, viewHeight);
        UIImageView *img = [view viewWithTag:1];
        [img sd_setImageWithURL:[NSURL URLWithString:teacherItem.photo] placeholderImage:[UIImage imageNamed:@"default_rectangle_img"]];
        UILabel *nameLB = [view viewWithTag:2];
        nameLB.text = teacherItem.name;
        UILabel *detailLB = [view viewWithTag:3];
        detailLB.text = teacherItem.info;
        [contentView addSubview:view];
        
        [view mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(contentView.mas_top).offset(0);
            make.bottom.mas_equalTo(contentView.mas_bottom);
            make.left.mas_equalTo(lastView?lastView.mas_right:@0).offset(20);
            make.width.mas_equalTo(viewWidth);
            make.height.mas_equalTo(viewHeight);
        }];
        lastView = view;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(jumpTeacherDetail:)];
        [view addGestureRecognizer:tap];
    }
    [contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(lastView.mas_right).offset(20);
    }];
}

#pragma mark - 教师详情
/** 教师详情 */
- (void)jumpTeacherDetail:(UITapGestureRecognizer *)tap {
    UIView *view = tap.view;
    NSInteger index = view.tag - 1000;
    HomeTeacherItem *teacherItem = _categoryItems.teacher_list[index];
    NSString *str = [NSString stringWithFormat:@"%@%@",H5_TeacherDetail,teacherItem.ID];
    [BaseWebVC showWithContro:self withUrlStr:str withTitle:teacherItem.name isPresent:NO];
}

#pragma mark - 课程详情
/** 课程详情 */
- (void)coureseDetail:(UIButton *)sender {
    [BaseWebVC showWithContro:self withUrlStr:[NSString stringWithFormat:@"%@%@",H5_StoreProduct,sender.currentTitle] withTitle:@"" isPresent:NO];
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

@implementation CZHomeBaseCell
@end

@implementation CZHomeCourseCell
@end

@implementation CZHomePublicCell
@end

@implementation CZHomeWeiKeCell
@end

@implementation CZHomeActivityCell
@end

@implementation CZHomeGoldTeacherCell
@end

@implementation CZHomeNewsCell
@end
