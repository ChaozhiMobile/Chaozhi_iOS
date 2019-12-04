//
//  XZHomeVC.m
//  Xuezhi
//
//  Created by Jason_zyl on 2019/7/28.
//  Copyright © 2019 Jason_hzb. All rights reserved.
//

#import "XZHomeVC.h"
#import <StoreKit/StoreKit.h>
#import "CZUpdateView.h"
#import "VersionItem.h"
#import "HomeInfoItem.h"
#import "CourseCategoryItem.h"
#import "VideoItem.h"
#import "TalkfunPlaybackViewController.h"
#import "XZHomeTabCell.h"
#import "XLGCustomButton.h"
#import "NotifyItem.h"

#define lineCount 5

@interface XZHomeVC ()<UITableViewDataSource,UITableViewDelegate,SKStoreProductViewControllerDelegate, UpdateViewDelegate,SDCycleScrollViewDelegate>

/** 版本更新 */
@property (nonatomic, strong) UIView *BGView;
@property (nonatomic, strong) CZUpdateView *updateView;
@property (nonatomic, retain) VersionItem *versionItem;
@property (nonatomic, retain) HomeInfoItem *homeItem;
@property (nonatomic, retain) HomeNewsListItem *newsItems;
@property (nonatomic, retain) NSMutableArray <CourseCategoryItem *>*dataArr;
@property (nonatomic, retain) NSMutableArray <HomeNewsItem *> *newsDatsSource;
@property (nonatomic, retain) HomeCategoryItem *categoryItems;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, retain) NSArray *titleArr;

@end

@implementation XZHomeVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    self.navBar.hidden = YES;
    
    if ([Utils isLoginWithJump:NO]) {
        [self getRedPointInfo];
    } else {
        self.redPointLab.hidden = YES;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = kWhiteColor;

    if (![Utils getNetStatus]) {
        XLGAlertView *alert = [[XLGAlertView alloc] initWithTitle:@"温馨提醒" content:@"检测到您的网络异常，请检查网络" leftButtonTitle:@"" rightButtonTitle:@"我知道了"];
    }
    
    _versionItem = [[VersionItem alloc] init];
    _homeItem = [[HomeInfoItem alloc] init];
    _categoryItems = [[HomeCategoryItem alloc] init];
    _newsItems = [[HomeNewsListItem alloc] init];
    _newsDatsSource = [NSMutableArray array];
    _page = 1;
    _bannerView.backgroundColor = PageColor;
    _bannerView.placeholderImage = [UIImage imageNamed:@"default_banner"];
    _bannerView.delegate = self;
    _titleArr = @[@{@"title":@"畅销好课",@"titleEN":@"PART ONE"},@{@"title":@"公开课",@"titleEN":@"PART TWO"},@{@"title":@"行业资讯",@"titleEN":@"PART THREE"}];
    
    _mainTabView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.page = 1;
        [self getData];
    }];
    
    [self getData];
    
    [self checkVersion];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeServerSucc) name:kChangeServerSuccNotification object:nil]; //环境切换成功通知
}

- (void)changeServerSucc {
    [self getData];
}

#pragma mark - 消息
- (IBAction)messageAction:(id)sender {
    if ([Utils isLoginWithJump:YES]) {
        [BaseWebVC showWithContro:self withUrlStr:H5_Message withTitle:@"我的消息" isPresent:NO];
    }
}

#pragma mark - get data

//获取小红点数量
- (void)getRedPointInfo {
    NSDictionary *dic = [NSDictionary dictionary];
    [[NetworkManager sharedManager] postJSON:URL_Notify parameters:dic imageDataArr:nil imageName:nil  completion:^(id responseData, RequestState status, NSError *error) {
        if (status == Request_Success) {
            NotifyItem *item = [NotifyItem mj_objectWithKeyValues:(NSDictionary *)responseData];
            if (![NSString isEmpty:item.msg_unread]
                && [item.msg_unread intValue] != 0) {
                self.redPointLab.hidden = NO;
                self.redPointLab.text = item.msg_unread;
            } else {
                self.redPointLab.hidden = YES;
            }
        }
    }];
}

- (void)getData {
    [self getBannerActivityData];
    [self getCategoryList];
    [self getCourseData];
    [self getNewList];
}

#pragma mark - 轮播图
- (void) getBannerActivityData {
    NSDictionary *dic = [NSDictionary dictionary];
    __weak typeof(self) weakSelf = self;
    [[NetworkManager sharedManager] postJSON:URL_AppHome parameters:dic completion:^(id responseData, RequestState status, NSError *error) {
        weakSelf.homeItem = [HomeInfoItem yy_modelWithJSON:responseData];
        [weakSelf refreshBannerUI];
        if ([weakSelf.mainTabView.mj_header isRefreshing]) {
            [weakSelf.mainTabView.mj_header endRefreshing];
        }
    }];
}

- (void)refreshBannerUI {
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

#pragma mark - 课程分类
- (void)getCategoryList {
    __weak typeof(self) weakSelf = self;
    NSDictionary *dic = [NSDictionary dictionary];
    [[NetworkManager sharedManager] postJSON:URL_CategoryList parameters:dic completion:^(id responseData, RequestState status, NSError *error) {
        if (status == Request_Success) {
            weakSelf.dataArr = [CourseCategoryItem mj_objectArrayWithKeyValuesArray:(NSArray *)responseData];
        }
        if ([weakSelf.mainTabView.mj_header isRefreshing]) {
            [weakSelf.mainTabView.mj_header endRefreshing];
        }
        [weakSelf refreshCategoryUI];
    }];
}

- (void)refreshCategoryUI {
    [_courseScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)]; //移除所有子视图
    CGFloat viewLeft = 0;
    for (NSInteger index = 0; index <self.dataArr.count; index++) {
        CourseCategoryItem *item = self.dataArr[index];
        XLGCustomButton *btn = [self createMenuView];
        btn.dataSource = [NSString stringWithFormat:@"%ld",(long)index];
        [btn addTarget:self action:@selector(categoryAction:) forControlEvents:UIControlEventTouchUpInside];
        btn.left = viewLeft;
        [_courseScrollView addSubview:btn];
        viewLeft = btn.right;
        UIImageView *imgView = [btn viewWithTag:1000];
        [imgView sd_setImageWithURL:[NSURL URLWithString:item.img] placeholderImage:nil];
        UILabel *titleLab = [btn viewWithTag:1001];
        titleLab.text = item.name;
    }
    _courseScrollView.contentSize = CGSizeMake(viewLeft, 0);
}

- (void)categoryAction:(XLGCustomButton *)btn {
    [CacheUtil saveCacher:kCourseCategoryKey withValue:btn.dataSource];
    CZAppDelegate.tabVC.selectedIndex = 2;
}

#pragma mark - 畅销好课、公开课
- (void)getCourseData {
    __weak typeof(self) weakSelf = self;
    NSDictionary *dic = [NSDictionary dictionary];
    [[NetworkManager sharedManager] postJSON:URL_Category parameters:dic completion:^(id responseData, RequestState status, NSError *error) {
        if ([weakSelf.mainTabView.mj_header isRefreshing]) {
            [weakSelf.mainTabView.mj_header endRefreshing];
        }
        weakSelf.categoryItems = nil;
        if (status == Request_Success) {
            weakSelf.categoryItems = [HomeCategoryItem yy_modelWithJSON:responseData];
        }
        [weakSelf.mainTabView reloadData];
    }];
}

#pragma mark - 行业资讯
- (void)getNewList {
    __weak typeof(self) weakSelf = self;
    [[NetworkManager sharedManager] postJSON:URL_NewsList parameters:@{@"p":@(_page),@"offset":@"10"} completion:^(id responseData, RequestState status, NSError *error) {
        if ([weakSelf.mainTabView.mj_header isRefreshing]) {
            [weakSelf.mainTabView.mj_header endRefreshing];
        }
        if ([weakSelf.mainTabView.mj_footer isRefreshing]) {
            [weakSelf.mainTabView.mj_footer endRefreshing];
        }
        weakSelf.newsItems = [HomeNewsListItem yy_modelWithJSON:responseData];
        if (weakSelf.page==1) {
            [weakSelf.newsDatsSource removeAllObjects];
        }
        if (weakSelf.newsDatsSource.count<weakSelf.newsItems.total) {
            weakSelf.page++;
            [weakSelf.newsDatsSource addObjectsFromArray:            weakSelf.newsItems.rows];
            weakSelf.mainTabView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                [weakSelf getNewList];
            }];
            weakSelf.mainTabView.tableFooterView = nil;
        } else {
            UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, WIDTH, autoScaleW(48))];
            lab.backgroundColor = PageColor;
            lab.text = @"我也是有底线的~";
            lab.textColor = RGBValue(0xBDBBBB);
            lab.textAlignment = NSTextAlignmentCenter;
            lab.font = [UIFont systemFontOfSize:12 weight:UIFontWeightMedium];
            weakSelf.mainTabView.mj_footer = nil;
            weakSelf.mainTabView.tableFooterView = lab;
        }
        [weakSelf.mainTabView reloadData];
    }];
}

#pragma mark - 版本更新
- (void)checkVersion {
    [[NetworkManager sharedManager] postJSON:URL_CheckVersion parameters:@{@"device":@"ios",@"version":AppVersion} completion:^(id responseData, RequestState status, NSError *error) {
        
        self.versionItem = [VersionItem yy_modelWithJSON:responseData];
        
        if ([self.versionItem.grade isEqualToString:@"2"]) { //推荐升级
            [self handleVersionUpdate:UpdateTypeSelect];
        }
        if ([self.versionItem.grade isEqualToString:@"3"]) { //强制升级
            [self handleVersionUpdate:UpdateTypeForce];
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

#pragma mark - UITableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==0) {
        BOOL line = self.categoryItems.feature_product_list.count%2==0;
        if (line) {
            return self.categoryItems.feature_product_list.count/2;
        }
        return self.categoryItems.feature_product_list.count/2+1;
    }
    else if (section==1) {
        return self.categoryItems.try_video_list.count;
    }
    else if (section==2) {
        return _newsDatsSource.count;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XZHomeTabCell *cell;
    if (indexPath.section==0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"XZHomeTabCellGoodsCourse"];
        CourseItem *leftItem = self.categoryItems.feature_product_list[indexPath.row*2];
        [cell setItem:leftItem withView:cell.leftView];
        if (self.categoryItems.feature_product_list.count%2==0) {
            CourseItem *rightItem = self.categoryItems.feature_product_list[indexPath.row*2+1];
            [cell setItem:rightItem withView:cell.rightView];
        }
    }
    else if (indexPath.section==1) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"XZHomeTabCellPublicCourse"];
        HomeTryVideoItem *item = self.categoryItems.try_video_list[indexPath.row];
        cell.publicItem = item;
    }
    else if (indexPath.section==2) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"XZHomeTabCellNews"];
        HomeNewsItem *item = _newsDatsSource[indexPath.row];
        cell.newsItem = item;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section==1) {
        HomeTryVideoItem *tryVideoItem = [_categoryItems.try_video_list firstObject];
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
    else if (indexPath.section==2) {
        HomeNewsItem *item = _newsDatsSource[indexPath.row];
        [BaseWebVC showWithContro:self withUrlStr:[NSString stringWithFormat:@"%@%@",H5_InfiniteNews,item.ID] withTitle:@"" isPresent:NO];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0) {
        return (WIDTH-16*2-14)/2.0*(99.0/164.0)
        +100;
    }
    else
        if (indexPath.section==1) {
       return 120;
    }
    else if (indexPath.section==2) {
        return 114;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section==0) {
        if (self.categoryItems.feature_product_list.count==0) {
            return CGFLOAT_MIN;
        }
    }
    else if (section==1) {
        if (self.categoryItems.try_video_list.count==0) {
            return CGFLOAT_MIN;
        }
    }
    else if (section==2) {
        if (self.newsDatsSource.count==0) {
            return CGFLOAT_MIN;
        }
    }
    return 80;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section==1) {
        return 10;
    }
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 80)];
    bgView.clipsToBounds = YES;
    
    NSDictionary *dic = _titleArr[section];
    UILabel *bgTitleLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 17, 200, 30)];
    bgTitleLab.font = [UIFont systemFontOfSize:22 weight:UIFontWeightBold];
    bgTitleLab.text = dic[@"titleEN"];
    bgTitleLab.textColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Rectangle"]];
    bgTitleLab.textAlignment = NSTextAlignmentCenter;
    bgTitleLab.centerX = bgView.width/2.0;
    [bgView addSubview:bgTitleLab];
    
    UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 30, 200, 30)];
    titleLab.text = dic[@"title"];
    titleLab.centerX = bgView.width/2.0;
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.font = [UIFont systemFontOfSize:18 weight:UIFontWeightBold];
    [bgView addSubview:titleLab];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, titleLab.bottom+3, 30, 3)];
    lineView.backgroundColor = AppThemeColor;
    lineView.centerX = titleLab.centerX;
    [bgView addSubview:lineView];
    
    UIButton *moreBtn = [[UIButton alloc]initWithFrame:CGRectMake(bgView.width-100-16, 0, 100, 40)];
    moreBtn.tag = 1000+section;
    [moreBtn setTitle:@"更多课程" forState:UIControlStateNormal];
    [moreBtn setTitleColor:AppThemeColor forState:UIControlStateNormal];
    moreBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    moreBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    moreBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
    moreBtn.centerY = titleLab.centerY;
    [moreBtn addTarget:self action:@selector(moreClickAction:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:moreBtn];
    
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(moreBtn.width-6, 14, 6, 12)];;
    imgView.image = [UIImage imageNamed:@"home_more"];
    [moreBtn addSubview:imgView];
    
    if ([dic[@"title"] isEqualToString:@"行业资讯"]) {
        moreBtn.hidden = YES;
    }
    
    return bgView;
}

#pragma mark - 更多课程
- (void)moreClickAction:(UIButton *)btn {
    NSInteger index = btn.tag - 1000;
    if (index == 0) { //更多畅销好课
//        [BaseWebVC showWithContro:self withUrlStr:[NSString stringWithFormat:@"%@%@",H5_Store,@"0"] withTitle:@"" isPresent:NO];
        [CacheUtil saveCacher:kCourseCategoryKey withValue:@"0"];
        CZAppDelegate.tabVC.selectedIndex = 2;
    }
    if (index == 1) { //更多公开课
        [BaseWebVC showWithContro:self withUrlStr:H5_StoreFree withTitle:@"" isPresent:NO];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (XLGCustomButton *)createMenuView {
    CGFloat viewW = WIDTH/lineCount;
    XLGCustomButton *btn = [[XLGCustomButton alloc] initWithFrame:CGRectMake(0, 0, viewW, 120)];
    
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake((btn.width-autoScaleW(44))/2.0, 26, autoScaleW(44), autoScaleW(44))];
    imgView.cornerRadius = imgView.width/2.0;
    imgView.tag = 1000;
    [btn addSubview:imgView];
    
    UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(5, imgView.bottom+10, btn.width-10, 36)];
    titleLab.textColor = RGBValue(0x6C7787);
    titleLab.text = @"心理咨询";
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.font = [UIFont systemFontOfSize:12 ];
    titleLab.tag = 1001;
    [btn addSubview:titleLab];
    
    return btn;
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
