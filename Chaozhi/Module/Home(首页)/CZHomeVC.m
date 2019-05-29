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
#import <IAPShare.h>

#define TEACHERNUM 2.5

@implementation DayNewTabCell
@end

@interface CZHomeVC ()<UITableViewDataSource,UITableViewDelegate,SKStoreProductViewControllerDelegate, UpdateViewDelegate>{
}
@property (nonatomic, strong) UIView *BGView;
@property (nonatomic, strong) CZUpdateView *updateView;

@property (nonatomic , assign) NSInteger page;
@property (nonatomic , retain) VersionItem *versionItem;
@property (nonatomic , retain) HomeInfoItem *homeItem;
@property (nonatomic , retain) HomeCategoryItem *categoryItems;;
@property (nonatomic , retain) HomeNewsListItem *newsItems;;
@property (nonatomic , retain) NSMutableArray <HomeNewsItem *> *newsDatsSource;
@property (nonatomic , retain) HomeFeatureProductItem *feaCourseItem1,*feaCourseItem2;

/** 背景视图 */
@property (weak, nonatomic) IBOutlet UIScrollView *bgScrollView;
/** 轮播图 */
@property (weak, nonatomic) IBOutlet SDCycleScrollView *bannerView;
/** 推荐课程 */
@property (weak, nonatomic) IBOutlet UIView *favCourseLeftView;
@property (weak, nonatomic) IBOutlet UIView *favCourseRightView;
@property (weak, nonatomic) IBOutlet UIImageView *courseImgView1;
@property (weak, nonatomic) IBOutlet UILabel *coursePriceLB1;
@property (weak, nonatomic) IBOutlet UILabel *courseDiscountPriceLB1;
@property (weak, nonatomic) IBOutlet UILabel *courseCommentCountLB1;
@property (weak, nonatomic) IBOutlet UILabel *courseTeaNameLB1;
@property (weak, nonatomic) IBOutlet UIImageView *courseImgView2;
@property (weak, nonatomic) IBOutlet UILabel *coursePriceLB2;
@property (weak, nonatomic) IBOutlet UILabel *courseDiscountPriceLB2;
@property (weak, nonatomic) IBOutlet UILabel *courseCommentCountLB2;
@property (weak, nonatomic) IBOutlet UILabel *courseTeaNameLB2;
/** 我们的公开课 */
@property (weak, nonatomic) IBOutlet UIImageView *publicCourseImgView;
@property (weak, nonatomic) IBOutlet UILabel *publicTitleLB;
@property (weak, nonatomic) IBOutlet UILabel *publicTeaLB;
/** 微课 */
@property (weak, nonatomic) IBOutlet UIView *weikeBgView;
@property (weak, nonatomic) IBOutlet UIImageView *weikeImgView;
@property (weak, nonatomic) IBOutlet UILabel *weikeTitleLB;
@property (weak, nonatomic) IBOutlet UILabel *weikeTeaLB;
@property (weak, nonatomic) IBOutlet UILabel *weikeCountLB;
/** 精彩活动 */
@property (weak, nonatomic) IBOutlet UIImageView *activityImgView;
@property (weak, nonatomic) IBOutlet UILabel *activityTitleLB;
@property (weak, nonatomic) IBOutlet UILabel *activityContentLB;
/** 金牌讲师 */
@property (weak, nonatomic) IBOutlet UIScrollView *teacherScroView;
/** 每日新知 */
@property (weak, nonatomic) IBOutlet UITableView *newsTabView;

- (IBAction)showMoreCourseAction:(UIButton *)sender;
- (IBAction)showPublicCourseAction:(id)sender;
- (IBAction)showMoreVideoAction:(id)sender;
- (IBAction)showActivityDetailAction:(id)sender;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *courseViewTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *courseViewHConstraint; //默认240
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *publicViewTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *publicViewHConstraint; //默认186
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *weikeViewTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *weikeViewHConstraint; //默认175
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *activityViewTopContraints;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *activityViewHContraints; //默认315
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *teacherViewTopContraints;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *teacherViewHContraints; //默认220
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *newsViewTopContraints;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lastViewHConstraints; //每日新知高度 动态

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
    
    _bgScrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.page = 1;
        [weakSelf getData];
    }];
    _bgScrollView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf getData];
    }];
    
    [self getData];
    
    [self checkVersion];
}

- (void)getData {
    [self getBannerActivityData];
    [self requestCourseData];
}

#pragma mark - get data

//版本更新
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
            [weakSelf refreshVideoUI];
            [weakSelf refreshWeikeUI];
            [weakSelf refreshTeacherUI];
        }];
        
        [[NetworkManager sharedManager] postJSON:URL_NewsList parameters:@{@"category_id":selectCourseID,@"p":@(_page),@"offset":@"5",@"news_category_id":@""} completion:^(id responseData, RequestState status, NSError *error) {

            weakSelf.newsItems = [HomeNewsListItem yy_modelWithJSON:responseData];
            if (weakSelf.page==1) {
                [weakSelf.newsDatsSource removeAllObjects];
                weakSelf.lastViewHConstraints.constant = 40;
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
            if (weakSelf.newsDatsSource.count>0) {
                weakSelf.newsViewTopContraints.constant = 10;
                weakSelf.lastViewHConstraints.constant = 40 + weakSelf.newsDatsSource.count*100;
            } else {
                weakSelf.newsViewTopContraints.constant = 0;
                weakSelf.lastViewHConstraints.constant = 0;
            }
            [weakSelf.newsTabView reloadData];
        }];
    }
}

#pragma mark - methods
//课程分类
- (IBAction)selectCourseAction:(id)sender {
    
    // https://cloud.tencent.com/developer/article/1423496
    // https://www.jianshu.com/p/d804b7dca7e7
    // http://www.cocoachina.com/cms/wap.php?action=article&id=25288
    
    [JHHJView showLoadingOnTheKeyWindowWithType:JHHJViewTypeSingleLine]; //开始加载
    
    if(![IAPShare sharedHelper].iap) {
        NSSet *dataSet = [[NSSet alloc] initWithObjects:@"com.czjy.chaozhi000001", nil];
        [IAPShare sharedHelper].iap = [[IAPHelper alloc] initWithProductIdentifiers:dataSet];
    }
    [IAPShare sharedHelper].iap.production = NO;
    
    // 请求商品信息
    [[IAPShare sharedHelper].iap requestProductsWithCompletion:^(SKProductsRequest* request,SKProductsResponse* response)
     {
         [JHHJView hideLoading];
         
         if(response.products.count > 0 ) {
             SKProduct *product = response.products[0];
             
             NSLog(@"%@",[product localizedDescription]);
             
             [[IAPShare sharedHelper].iap buyProduct:product
                                        onCompletion:^(SKPaymentTransaction* trans){
                                            if(trans.error)
                                            {
                                                
                                            }
                                            else if(trans.transactionState == SKPaymentTransactionStatePurchased) {
                                                // 到这里购买就成功了，但是因为存在越狱手机下载某些破解内购软件的情况，需要跟苹果服务器的确认是否购买成功
                                                // IAPHelper提供了这个方法，验证这步可以写在前端，也可以写在服务器端，这个自己看情况决定吧...
                                                
                                                //   ！！ 这里有一种情况需要注意。程序走到这里的时候，已经是支付成功的状态。
                                                // 此时用户的钱已经被苹果扣掉了，接下来需要做的是验证购买信息。
                                                // 但是如果在 '购买成功'——'验证订单' 中间出现问题，断网、App崩溃等问题的话，会出现扣了钱但是充值失败的情况
                                                // 所以在这里可以将下文中的验证信息存在本地，验证成功再后删除。验证失败的话，可以在每次App启动时将信息取出来重新验证
                                                
                                                // 购买验证
                                                NSData *receipt = [NSData dataWithContentsOfURL:[[NSBundle mainBundle] appStoreReceiptURL]];
                                    
                                                NSString *encodeStr = [receipt base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
                                                NSString *sendString = [NSString stringWithFormat:@"{\"receipt-data\" : \"%@\"}", encodeStr];
                                                NSLog(@"购买凭证：%@",sendString);
                                                //网上的攻略有的比较老，在验证时使用的是trans.transactionReceipt，需要注意trans.transactionReceipt在ios9以后被弃用
                                                [[IAPShare sharedHelper].iap checkReceipt:receipt onCompletion:^(NSString *response, NSError *error) {}];
                                                
                                            }
                                            else if(trans.transactionState == SKPaymentTransactionStateFailed) {
                                                if (trans.error.code == SKErrorPaymentCancelled) {
                                                }else if (trans.error.code == SKErrorClientInvalid) {
                                                }else if (trans.error.code == SKErrorPaymentInvalid) {
                                                }else if (trans.error.code == SKErrorPaymentNotAllowed) {
                                                }else if (trans.error.code == SKErrorStoreProductNotAvailable) {
                                                }else{
                                                }
                                            }
                                        }];
         } else {
             //  ..未获取到商品
         }
     }];
    
    return;
    
    __weak typeof(self) weakSelf = self;
    CZSelectCourseVC *vc = [[CZSelectCourseVC alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.selectCourseBlock = ^(CourseItem *item) {
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

#pragma mark - 精彩活动

- (void)refreshActivityUI{
    if (_homeItem.activity_list.count==0) {
        _activityViewTopContraints.constant = 0;
        _activityViewHContraints.constant = 0;
        _activityTitleLB.superview.clipsToBounds = YES;
        return;
    }
    _activityTitleLB.superview.clipsToBounds = NO;
    _activityViewTopContraints.constant = 10;
    _activityViewHContraints.constant = 315;
    HomeActivityItem *activityItem = [_homeItem.activity_list firstObject];
    _activityTitleLB.text = activityItem.title;
    [_activityImgView sd_setImageWithURL:[NSURL URLWithString:activityItem.img] placeholderImage:[UIImage imageNamed:@"default_rectangle_img"]];
    _activityContentLB.text = activityItem.subtitle;
}

#pragma mark - 金牌讲师

- (void)refreshTeacherUI{
    [_teacherScroView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    if (_categoryItems.teacher_list.count==0) {
        _teacherViewTopContraints.constant = 0;
        _teacherViewHContraints.constant = 0;
        return;
    }
    _teacherScroView.contentOffset = CGPointMake(0, 0);
    NSInteger count = _categoryItems.teacher_list.count;
    CGFloat blankSpace = 15;
    NSInteger num = TEACHERNUM;
    CGFloat viewWidth = (WIDTH-blankSpace*(num+1))/TEACHERNUM;
    CGFloat viewHeight = viewWidth*1.176+10+20*5;
    _teacherViewTopContraints.constant = 10;
    _teacherViewHContraints.constant = viewHeight+40;
    _teacherScroView.contentSize = CGSizeMake((blankSpace*(count+1))+viewWidth*count,0);
    _teacherViewHContraints.constant = viewHeight+40;
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
        [_teacherScroView addSubview:view];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(jumpTeacherDetail:)];
        [view addGestureRecognizer:tap];
    }
}

- (void)jumpTeacherDetail:(UITapGestureRecognizer *)tap {
    UIView *view = tap.view;
    NSInteger index = view.tag - 1000;
    HomeTeacherItem *teacherItem = _categoryItems.teacher_list[index];
    NSString *str = [NSString stringWithFormat:@"%@%@",H5_TeacherDetail,teacherItem.ID];
    [BaseWebVC showWithContro:self withUrlStr:str withTitle:teacherItem.name isPresent:NO];
}

#pragma mark - 我们的公开课

- (void)refreshVideoUI {
    if (_categoryItems.try_video_list.count==0) {
        _publicViewTopConstraint.constant = 0;
        _publicViewHConstraint.constant = 0;
        return;
    }
    _publicViewTopConstraint.constant = 10;
    _publicViewHConstraint.constant = 186;
    HomeTryVideoItem *tryVideoItem = [_categoryItems.try_video_list firstObject];
    _publicCourseImgView.image = nil;
    _publicTeaLB.text = @"";
    _publicTitleLB.text = @"";
    if (tryVideoItem) {
        [_publicCourseImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",tryVideoItem.img]] placeholderImage:[UIImage imageNamed:@"default_course"]];
        _publicTeaLB.text = [NSString stringWithFormat:@"主讲讲师：%@",tryVideoItem.teacher];
        _publicTitleLB.text = tryVideoItem.title;
    }
}

#pragma mark - 微课

- (void)refreshWeikeUI{
    if (_categoryItems.weike_list.count==0) {
        _weikeViewTopConstraint.constant = 0;
        _weikeViewHConstraint.constant = 0;
        return;
    }
    _weikeViewTopConstraint.constant = 10;
    _weikeViewHConstraint.constant = 175;
    HomeWeikeItem *weikeItem = [_categoryItems.weike_list firstObject];
    _weikeImgView.image = nil;
    _weikeTitleLB.text = @"";
    _weikeTeaLB.text = @"";
    _weikeCountLB.text = @"";
    
    if (weikeItem) {
        [_weikeImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",weikeItem.cover]] placeholderImage:[UIImage imageNamed:@"default_course"]];
        CGFloat titleH = [weikeItem.title getTextHeightWithFont:[UIFont systemFontOfSize:14] width:autoScaleW(182)];
        _weikeTitleLB.height = titleH;
        _weikeTitleLB.text = weikeItem.title;
        _weikeTeaLB.text = weikeItem.teacher_name;
        _weikeCountLB.text = [NSString stringWithFormat:@"%@人观看",weikeItem.play_num];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showWeikeVideoDetail)];
        [_weikeBgView addGestureRecognizer:tap];
    }
}

- (void)refreshFeaCourseUI{
    
//    _categoryItems.feature_product_list = [NSArray array];
    
    if (_categoryItems.feature_product_list.count==0) {
        _courseViewTopConstraint.constant = 0;
        _courseViewHConstraint.constant = 0;
        return;
    }
    _courseViewTopConstraint.constant = 10;
    _courseViewHConstraint.constant = 240;
    _courseImgView1.image = nil;
    _courseTeaNameLB1.text = @"";
    _courseImgView2.image = nil;
    _courseTeaNameLB2.text = @"";
    for (NSInteger i = 0; i < MIN(2, _categoryItems.feature_product_list.count); i ++) {
        switch (i) {
            case 0:
            {
                _feaCourseItem1 = [_categoryItems.feature_product_list firstObject];
                [_courseImgView1 sd_setImageWithURL:[NSURL URLWithString:_feaCourseItem1.img] placeholderImage:[UIImage imageNamed:@"default_course"]];
                _coursePriceLB1.text = _feaCourseItem1.price;
                NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:_feaCourseItem1.original_price attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#b4b4b4"],NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle|NSUnderlinePatternSolid),NSStrikethroughColorAttributeName:[UIColor colorWithHexString:@"#b4b4b4"]}];
                _courseDiscountPriceLB1.attributedText = attrStr;
                _courseTeaNameLB1.text = _feaCourseItem1.name;
                _courseCommentCountLB1.text = _feaCourseItem1.review_num;
                [_favCourseLeftView layoutIfNeeded];
                CZStarView *view = [[CZStarView alloc] initWithFrame:CGRectMake(_favCourseLeftView.width-76, 181, 76, 12) currentScore:[_feaCourseItem1.review_star floatValue] delegate:nil];
                [_favCourseLeftView addSubview:view];
                
                UITapGestureRecognizer *leftTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(favCourseLeftAction)];
                [_favCourseLeftView addGestureRecognizer:leftTap];
            }
                break;
            case 1:
            {
                _feaCourseItem2 = _categoryItems.feature_product_list[1];
                [_courseImgView2 sd_setImageWithURL:[NSURL URLWithString:_feaCourseItem2.img] placeholderImage:[UIImage imageNamed:@"default_course"]];
                _coursePriceLB2.text = _feaCourseItem2.price;
                _courseDiscountPriceLB2.text = _feaCourseItem2.original_price;
                NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:_feaCourseItem2.original_price attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#b4b4b4"],NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle|NSUnderlinePatternSolid),NSStrikethroughColorAttributeName:[UIColor colorWithHexString:@"#b4b4b4"]}];
                _courseDiscountPriceLB2.attributedText = attrStr;
                _courseTeaNameLB2.text = _feaCourseItem2.name;
                _courseCommentCountLB2.text = _feaCourseItem2.review_num;
                [_favCourseRightView layoutIfNeeded];
                CZStarView *view = [[CZStarView alloc] initWithFrame:CGRectMake(_favCourseRightView.width-76, 181, 76, 12) currentScore:[_feaCourseItem2.review_star floatValue] delegate:nil];
                [_favCourseRightView addSubview:view];
                
                UITapGestureRecognizer *rightTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(favCourseRightAction)];
                [_favCourseRightView addGestureRecognizer:rightTap];
            }
                break;
            default:
                break;
        }
    }
}

// 推荐课程左点击
- (void)favCourseLeftAction {
    [BaseWebVC showWithContro:self withUrlStr:[NSString stringWithFormat:@"%@%@",H5_StoreProduct,_feaCourseItem1.ID] withTitle:@"" isPresent:NO];
}

// 推荐课程右点击
- (void)favCourseRightAction {
    [BaseWebVC showWithContro:self withUrlStr:[NSString stringWithFormat:@"%@%@",H5_StoreProduct,_feaCourseItem2.ID] withTitle:@"" isPresent:NO];
}

// 更多课程
- (IBAction)showMoreCourseAction:(UIButton *)sender {
    
    NSString *selectCourseID = [CacheUtil getCacherWithKey:kSelectCourseIDKey];
    [BaseWebVC showWithContro:self withUrlStr:[NSString stringWithFormat:@"%@%@",H5_Store,selectCourseID] withTitle:@"" isPresent:NO];
}

// 更多公开课
- (IBAction)showMorePublicCourseAction:(id)sender {
    [BaseWebVC showWithContro:self withUrlStr:H5_StoreFree withTitle:@"" isPresent:NO];
}

// 马上试听
- (IBAction)showPublicCourseAction:(id)sender {
    HomeTryVideoItem *tryVideoItem = [_categoryItems.try_video_list firstObject];
    [BaseWebVC showWithContro:self withUrlStr:tryVideoItem.src withTitle:tryVideoItem.title isPresent:NO];
}

// 微课视频详情
- (void)showWeikeVideoDetail {
    HomeWeikeItem *weikeItem = [_categoryItems.weike_list firstObject];
    [BaseWebVC showWithContro:self withUrlStr:[NSString stringWithFormat:@"%@%@",H5_WeikeDetail,weikeItem.ID] withTitle:weikeItem.title isPresent:NO];
}

// 更多微课视频
- (IBAction)showMoreVideoAction:(id)sender {
    [BaseWebVC showWithContro:self withUrlStr:H5_WeikeList withTitle:@"" isPresent:NO];
}

// 精彩活动
- (IBAction)showActivityDetailAction:(id)sender {
    HomeActivityItem *activityItem = [_homeItem.activity_list firstObject];
    [BaseWebVC showWithContro:self withUrlStr:[NSString stringWithFormat:@"%@%@",H5_InfiniteNews,activityItem.ID] withTitle:@"" isPresent:NO];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _newsDatsSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DayNewTabCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DayNewTabCellID"];
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    HomeNewsItem *item = _newsDatsSource[indexPath.row];
    [cell.dayNewIconImgView sd_setImageWithURL:[NSURL URLWithString:item.img] placeholderImage:[UIImage imageNamed:@"default_square_img"]];
    cell.dayNewTitleLB.text = item.title;
    cell.dayNewContentLB.text = item.subtitle;
    cell.dayNewTimeLB.text = item.ct;
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
