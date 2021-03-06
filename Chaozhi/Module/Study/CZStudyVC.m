//
//  CZStudyVC.m
//  Chaozhi
//
//  Created by Jason_zyl on 2018/9/22.
//  Copyright © 2018年 Jason_hzb. All rights reserved.
//

#import "CZStudyVC.h"
#import "StudyInfoItem.h"
#import "CZNotDataView.h"
#import "CZAlertView.h"
#import "CZProtocalWebVC.h"
#import "DBManager.h"
#import "VideoItem.h"
#import "TalkfunItem.h"
#import "TalkfunViewController.h"
#import "TalkfunPlaybackViewController.h"

@implementation StudyCourseCell
@end

@interface CZStudyVC ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
{
    BOOL show;
}
/** 所有的弹框视图 */
@property (nonatomic,strong) NSMutableArray *allAlertView;
@property (nonatomic,retain) CZNotDataView *notDataView; //无数据视图

@property (weak, nonatomic) IBOutlet UIView *statusBarView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *statusBarHConstraint;
@property (weak, nonatomic) IBOutlet UIPageControl *coursePageControl;
@property (weak, nonatomic) IBOutlet UIScrollView *courseScrollView;

@property (weak, nonatomic) IBOutlet UIView *topBGBackView;
@property (weak, nonatomic) IBOutlet UIScrollView *bgScroView;

@property (weak, nonatomic) IBOutlet UIView *yuekaoView;
@property (weak, nonatomic) IBOutlet UIButton *yuekaoBtn;
@property (weak, nonatomic) IBOutlet UIImageView *yuekaoIconImgView;
@property (weak, nonatomic) IBOutlet UIButton *yuekaoTitleBtn;
@property (weak, nonatomic) IBOutlet UILabel *yuekaoTimeLab;
@property (weak, nonatomic) IBOutlet UILabel *yuekaoScoreLab;
@property (weak, nonatomic) IBOutlet UIButton *yuekaoEnterBtn;

@property (weak, nonatomic) IBOutlet UIView *liveCourseView;
@property (weak, nonatomic) IBOutlet UIImageView *liveCourseIconImgView;
@property (weak, nonatomic) IBOutlet UILabel *liveCourseTitleLB;
@property (weak, nonatomic) IBOutlet UILabel *liveCourseTeacherLB;
@property (weak, nonatomic) IBOutlet UILabel *liveStartTimeLB;
@property (weak, nonatomic) IBOutlet UIButton *enterLiveBtn;
@property (weak, nonatomic) IBOutlet UITableView *studyTabView;
@property (weak, nonatomic) IBOutlet UILabel *studyCourseTipLab;
@property (weak, nonatomic) IBOutlet UIView *studyCourseLineView;
@property (weak, nonatomic) IBOutlet UIView *titleView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *yuekaoConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *yuekaoTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *liveCourseConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *liveCourseTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *studyCourseTipConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *studyCourseTipTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tabHeightConstraint;

@property (assign, nonatomic) NSInteger currentPage;
@property (strong, nonatomic) NSArray <StudyInfoItem *>*dataArr;
@property (strong, nonatomic) NSArray <LiveItem *>*liveArr;
@property (strong, nonatomic) NSArray <LearnCourseItem *>*courseArr;
@property (strong, nonatomic) YuekaoItem *yuekaoItem;

@end

@implementation CZStudyVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navBar.hidden = YES;
    show = YES;
    [self getData];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    show = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    show = YES;
    _tabHeightConstraint.constant = 3*60;
    _statusBarHConstraint.constant = kStatusBarH;
    _allAlertView = [NSMutableArray array];
    //    __weak typeof(self) weakSelf = self;
    //    _bgScroView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
    //        [weakSelf getData];
    //    }];
    self.topBGBackView.backgroundColor = kStudyNavBgColor;
    [self blankView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSucc) name:kLoginSuccNotification object:nil]; //登录成功通知
}

- (void)loginSucc {
    _currentPage = 0;
    _courseScrollView.contentOffset = CGPointMake(0, 0);
    [self getData];
}

- (void)showAlertView {
    for (CZAlertView *alert in _allAlertView) {
        if (alert.isRelease==NO) {
            alert.hidden = NO;
            break;
        }
    }
}

#pragma mark - get data

// 分类列表
- (void)getData {
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         @"1", @"is_newest_info",
                         @"1", @"is_progress",
                         nil];
    __weak typeof(self) weakSelf = self;
    [[NetworkManager sharedManager] postJSON:URL_CourseList parameters:dic imageDataArr:nil imageName:nil completion:^(id responseData, RequestState status, NSError *error) {
        if ([weakSelf.bgScroView.mj_header isRefreshing]) {
            [weakSelf.bgScroView.mj_header endRefreshing];
        }
        if (status == Request_Success) {
            self.dataArr = [StudyInfoItem mj_objectArrayWithKeyValuesArray:(NSArray *)responseData];
            if (self.dataArr.count>0) {
                weakSelf.notDataView.hidden = YES;
                weakSelf.studyTabView.hidden = NO;
                [self initView];
                [self refreshUI];
            } else {
                weakSelf.studyTabView.hidden = YES;
                weakSelf.notDataView.hidden = NO;
            }
        }
    }];
}

#pragma mark - init view

// 无数据视图
- (void)blankView {
    _notDataView = [[CZNotDataView alloc] initWithFrame:CGRectMake(0, kNavBarH, WIDTH, HEIGHT-kNavBarH-kTabBarH)];
    _notDataView.hidden = YES;
    [self.view addSubview:_notDataView];
}

- (void)initView {
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[(__bridge id)kStudyNavBgColor.CGColor,  (__bridge id)AppThemeColor.CGColor];
    gradientLayer.locations = @[@0.0, @1.0];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(0, 1.0);
    gradientLayer.frame = _topBGBackView.bounds;
    [self.topBGBackView.layer addSublayer:gradientLayer];
    
    NSInteger courseCount = self.dataArr.count;
    __weak typeof(self) weakSelf = self;
    [_allAlertView removeAllObjects];;
    _courseScrollView.contentSize = CGSizeMake(courseCount*(WIDTH-20), 0);
    for (NSInteger i = 0; i < courseCount; i ++) {
        StudyInfoItem *item = self.dataArr[i];
        UIView *view = [[[NSBundle mainBundle]loadNibNamed:@"CZStudyView" owner:self options:nil]firstObject];
        view.frame = CGRectMake(i*(WIDTH-20), 0, (WIDTH-20), 120);
        view.tag = 120+i;
        [_courseScrollView addSubview:view];
        UIImageView *courseIconImgView = [view viewWithTag:2];
        courseIconImgView.contentMode = UIViewContentModeScaleToFill;
        [courseIconImgView sd_setImageWithURL:[NSURL URLWithString:item.product_img] placeholderImage:[UIImage imageNamed:@"default_course"]];
        UILabel *courseTitleLB = [view viewWithTag:3];
        courseTitleLB.text = item.product_name;
        UILabel *courseTypeLB = [view viewWithTag:4];
        courseTypeLB.text = item.product_sub_name;
        UILabel *courseDurationLB = [view viewWithTag:5];
        courseDurationLB.text = [NSString stringWithFormat:@"%@节",item.user_time];
        UILabel *courseSubjectLB =[view viewWithTag:6];
        courseSubjectLB.text = [NSString stringWithFormat:@"%@道",item.user_question];
        UIButton *viewBtn = [view viewWithTag:7];
        viewBtn.tag = 1000+i;
        [viewBtn addTarget:self action:@selector(courseClick:) forControlEvents:UIControlEventTouchUpInside];
        if ([item.is_agreement_confirm integerValue]==0&&show) {
            CZAlertView *alert = [[CZAlertView alloc] initWithTitle:@"温馨提示" content:item.product_name leftButtonTitle:@"不同意" rightButtonTitle:@"已阅读并同意"];
            alert.hidden = YES;
            [_allAlertView addObject:alert];
            alert.cancelBlock = ^{
                // 跳转到首页
                self.tabBarController.selectedIndex = 0;
                [self.navigationController popToRootViewControllerAnimated:NO];
                for (CZAlertView *view in weakSelf.allAlertView) {
                    [view removeFromSuperview];
                }
            };
            alert.doneBlock = ^{
                NSDictionary *dic = @{@"id":item.ID};
                [[NetworkManager sharedManager] postJSON:URL_ConfirmAgreement parameters:dic imageDataArr:nil imageName:nil completion:^(id responseData, RequestState status, NSError *error) {
                    if (status == Request_Success) {
                        alert.isRelease = YES;
                        [weakSelf showAlertView];
                    }
                }];
            };
            alert.urlClickBlock = ^{
                for (CZAlertView *view in weakSelf.allAlertView) {
                    [view removeFromSuperview];
                }
                NSDictionary *dic = @{@"order_id":item.ID};
                [[NetworkManager sharedManager] postJSON:URL_OrdersAgreement parameters:dic imageDataArr:nil imageName:nil completion:^(id responseData, RequestState status, NSError *error) {
                    if (status == Request_Success) {
                        CZProtocalWebVC *vc = [[CZProtocalWebVC alloc] init];
                        vc.webTitle = [NSString stringWithFormat:@"《%@·协议》",item.product_name];
                        vc.homeUrl = [NSString stringWithFormat:@"%@",responseData[@"agreement"]];
                        vc.hidesBottomBarWhenPushed = YES;
                        [weakSelf.navigationController pushViewController:vc animated:NO];
                    }
                }];
            };
        }
    }
    _coursePageControl.currentPageIndicatorTintColor = AppThemeColor;
    _coursePageControl.pageIndicatorTintColor = kPageControlColor;
    _coursePageControl.height = 20;
    _coursePageControl.currentPage = _currentPage;
    _coursePageControl.numberOfPages = courseCount;
    [self showAlertView];
}

#pragma mark - methods

#pragma mark - 顶部课程
- (void)courseClick:(UIButton *)btn {
    NSInteger index = btn.tag-1000;
    NSLog(@"点击页数：%ld",(long)index);
    
    //    StudyInfoItem *item = self.dataArr[index];
}

#pragma mark - 录播课程
- (IBAction)luboAction:(id)sender {
    StudyInfoItem *items = _dataArr[_currentPage];
    NSString *tikuStr = [NSString stringWithFormat:@"%@%@",H5_Video,items.product_id];
    [BaseWebVC showWithContro:self withUrlStr:tikuStr withTitle:@"录播课程" isPresent:NO];
}

#pragma mark - 直播课程
- (IBAction)zhiboAction:(id)sender {
    StudyInfoItem *items = _dataArr[_currentPage];
    NSString *tikuStr = [NSString stringWithFormat:@"%@%@",H5_Live,items.product_id];
    [BaseWebVC showWithContro:self withUrlStr:tikuStr withTitle:@"直播课程" isPresent:NO];
}

#pragma mark - 资料库
- (IBAction)ziliaokuAction:(id)sender {
    StudyInfoItem *items = _dataArr[_currentPage];
    NSString *tikuStr = [NSString stringWithFormat:@"%@%@",H5_Doc,items.product_id];
    [BaseWebVC showWithContro:self withUrlStr:tikuStr withTitle:@"资料库" isPresent:NO];
}

#pragma mark - 题库
- (IBAction)tikuAction:(id)sender {
    StudyInfoItem *items = _dataArr[_currentPage];
    NSString *tikuStr = [NSString stringWithFormat:@"%@%@",H5_Question,items.product_id];
    [BaseWebVC showWithContro:self withUrlStr:tikuStr withTitle:@"题库" isPresent:NO];
}

#pragma mark - 最新月考
/** 更多月考成绩 */
- (IBAction)showMoreYuekaoAction:(id)sender {
    StudyInfoItem *items = _dataArr[_currentPage];
    [BaseWebVC showWithContro:self withUrlStr:[NSString stringWithFormat:@"%@%@",H5_MonthlyList,items.product_id] withTitle:@"我的月考" isPresent:NO];
}

/** 月考结果页 */
- (IBAction)yuekaoResultAction:(id)sender {
    StudyInfoItem *items = _dataArr[_currentPage];
    [BaseWebVC showWithContro:self withUrlStr:[NSString stringWithFormat:@"%@%@/%@",H5_MonthlyResult,items.product_id,_yuekaoItem.ID] withTitle:@"" isPresent:NO];
}

/** 月考参加考试/再做一遍 */
- (IBAction)yuekaoAction:(id)sender {
    
    if ([_yuekaoEnterBtn.titleLabel.text isEqualToString:@"再做一遍"]) {
        __weak typeof(self) weakSelf = self;
        XLGAlertView *alert = [[XLGAlertView alloc] initWithTitle:@"温馨提示" content:@"重新答题将删除您之前的做题记录" leftButtonTitle:@"取消" rightButtonTitle:@"确认重做"];
        alert.doneBlock = ^{
            StudyInfoItem *items = weakSelf.dataArr[weakSelf.currentPage];
            NSDictionary *dic = @{@"type":@"3",@"id":weakSelf.yuekaoItem.ID,@"product_id":items.product_id};
            [[NetworkManager sharedManager] postJSON:URL_ResetAnswer parameters:dic imageDataArr:nil imageName:nil completion:^(id responseData, RequestState status, NSError *error) {
                if (status == Request_Success) {
                    [weakSelf yuekaoExamAction];
                }
            }];
        };
    } else { //参加考试
        [self yuekaoExamAction];
    }
}

/** 月考考试 */
- (void)yuekaoExamAction {
    StudyInfoItem *items = _dataArr[_currentPage];
    [BaseWebVC showWithContro:self withUrlStr:[NSString stringWithFormat:@"%@%@/%@",H5_MonthlyAnswer,items.product_id,_yuekaoItem.ID] withTitle:@"" isPresent:NO];
}

#pragma mark - 最新直播课程
- (IBAction)liveCourseAction:(id)sender {
    
    LiveItem *liveItem = _liveArr.firstObject;
    VideoItem *videoItem = [[VideoItem alloc] init];
    videoItem.type = [liveItem.status isEqualToString:@"1"]?@"3":@"2";
    videoItem.live_id = liveItem.live_id;
    StudyInfoItem *items = _dataArr[_currentPage];
    videoItem.product_id = items.product_id;
    [self talkfunVideo:videoItem];
}

#pragma mark - 欢拓原生视频
/**
 * 播放视频。类型1:录播; 2:回放; 3:直播 (后台回放和直播都是2，本地需要区分下)
 */
- (void)talkfunVideo:(VideoItem *)item {
    NSString *type = [item.type isEqualToString:@"1"]?@"1":@"2";
    NSDictionary *dic = @{@"type":type,@"live_id":item.live_id};
    [[NetworkManager sharedManager] postJSON:URL_LiveToken parameters:dic imageDataArr:nil imageName:nil completion:^(id responseData, RequestState status, NSError *error) {
        if (status == Request_Success) {
            TalkfunItem *talkfunItem = [TalkfunItem mj_objectWithKeyValues:(NSDictionary *)responseData];
            if ([item.type isEqualToString:@"1"]
                || [item.type isEqualToString:@"2"]) {
                TalkfunPlaybackViewController *vc = [[TalkfunPlaybackViewController alloc] init];
                vc.res = [[NSDictionary alloc] initWithObjectsAndKeys:@{@"access_token":talkfunItem.access_token},@"data", nil];
                vc.playbackID = item.live_id;
                vc.videoItem = item;
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
            if ([item.type isEqualToString:@"3"]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    TalkfunViewController *myVC = [[TalkfunViewController alloc] init];
                    myVC.res = [[NSDictionary alloc] initWithObjectsAndKeys:@{@"access_token":talkfunItem.access_token},@"data",@"0",@"code", nil];
                    myVC.videoItem = item;
                    myVC.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:myVC animated:YES];
                });
            }
        }
    }];
}

#pragma mark - UIScrollViewDelegate协议

//减速滑动(Decelerating:使减速的)
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    int currentPageTem = fabs(scrollView.contentOffset.x)/(WIDTH-20); //计算当前页
    _coursePageControl.currentPage = currentPageTem;
    _currentPage = currentPageTem;
    [self refreshUI];
}

- (void)refreshUI {
    StudyInfoItem *items = _dataArr[_currentPage];
    _liveArr = items.newest_info.live_list;
    _courseArr = items.newest_info.learn_course_list;
    _yuekaoItem = items.newest_info.exam_month;
    
    if (!_yuekaoItem) {
        _yuekaoView.hidden = YES;
        _yuekaoTopConstraint.constant = 0;
        _yuekaoConstraint.constant = 0;
    } else {
        _yuekaoView.hidden = NO;
        _yuekaoTopConstraint.constant = 10;
        _yuekaoConstraint.constant = 124;
        
        [_yuekaoTitleBtn setTitle:_yuekaoItem.name forState:UIControlStateNormal];
        _yuekaoTimeLab.text = [NSString stringWithFormat:@"月考时间：%@",[NSString stringWithFormat:@"%@年%@月",_yuekaoItem.year,_yuekaoItem.month]];
        if ([_yuekaoItem.status isEqualToString:@"0"]) { //未考试
            _yuekaoBtn.userInteractionEnabled = NO;
            _yuekaoScoreLab.text = @"我的成绩：还未完成";
            [_yuekaoEnterBtn setTitle:@"参加考试" forState:UIControlStateNormal];
        } else {
            _yuekaoBtn.userInteractionEnabled = YES;
            _yuekaoScoreLab.text = [NSString stringWithFormat:@"我的成绩：%@分",_yuekaoItem.score];
            [_yuekaoEnterBtn setTitle:@"再做一遍" forState:UIControlStateNormal];
        }
    }
    if (_liveArr.count==0) {
        _liveCourseView.hidden = YES;
        _liveCourseTopConstraint.constant = 0;
        _liveCourseConstraint.constant = 0;
        _studyCourseTipTopConstraint.constant = 0;
    } else {
        _liveCourseView.hidden = NO;
        _liveCourseTopConstraint.constant = 10;
        _liveCourseConstraint.constant = 150;
        _studyCourseTipTopConstraint.constant = 10;
        
        LiveItem *liveItems = _liveArr.firstObject;
        if (liveItems) {
            _liveCourseIconImgView.image = [UIImage imageNamed:@"default_live"];
            _liveCourseTitleLB.text = liveItems.live_name;
            _liveCourseTeacherLB.text = [NSString stringWithFormat:@"主讲讲师：%@",liveItems.teacher];
            _liveStartTimeLB.text = [NSString stringWithFormat:@"开始时间：%@",liveItems.live_st];
            if ([liveItems.status isEqualToString:@"-1"]) {
                _enterLiveBtn.userInteractionEnabled = YES;
                [_enterLiveBtn setTitle:@"查看回放" forState:UIControlStateNormal];
                [_enterLiveBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
                _enterLiveBtn.backgroundColor = AppThemeColor;
                _enterLiveBtn.borderColor = [UIColor clearColor];
            }
            else if ([liveItems.status isEqualToString:@"0"]) {
                _enterLiveBtn.userInteractionEnabled = NO;
                [_enterLiveBtn setTitle:@"即将开始" forState:UIControlStateNormal];
                [_enterLiveBtn setTitleColor:RGBValue(0x7c7c7c) forState:UIControlStateNormal];
                _enterLiveBtn.backgroundColor = kWhiteColor;
                _enterLiveBtn.borderColor = RGBValue(0xF0F0F0);
            } else { //进入直播
                _enterLiveBtn.userInteractionEnabled = YES;
                [_enterLiveBtn setTitle:@"进入直播" forState:UIControlStateNormal];
                [_enterLiveBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
                _enterLiveBtn.backgroundColor = AppThemeColor;
                _enterLiveBtn.borderColor = [UIColor clearColor];
            }
        }
    }
    if (_courseArr.count==0) {
        _studyCourseTipConstraint.constant = 50;
        
        _studyCourseTipLab.text = @"您还没有开始学习，加油噢";
        _studyCourseTipLab.textAlignment = NSTextAlignmentCenter;
        _studyCourseLineView.hidden = YES;
    } else {
        _studyCourseTipConstraint.constant = 30;
        _studyCourseTipLab.text = @"最新学习课程";
        _studyCourseTipLab.textAlignment = NSTextAlignmentLeft;
        _studyCourseLineView.hidden = NO;
    }
    _tabHeightConstraint.constant = _courseArr.count*60;
    [_studyTabView reloadData];
}

#pragma mark - UITableView 代理

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _courseArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    StudyCourseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"homeStudyCourseCellID"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    LearnCourseItem *item = _courseArr[indexPath.row];
    cell.studyCourseTitleLB.text = item.name;
    cell.studycourseTimeLB.text = [NSString stringWithFormat:@"学习时间：%@",item.ut];
    return cell;
}

#pragma mark - 最新学习课程
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    LearnCourseItem *item = _courseArr[indexPath.row];
    VideoItem *videoItem = [[VideoItem alloc] init];
    videoItem.type = item.type;;
    videoItem.live_id = item.live_id;
    StudyInfoItem *items = _dataArr[_currentPage];
    videoItem.product_id = items.product_id;
    [self talkfunVideo:videoItem];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
