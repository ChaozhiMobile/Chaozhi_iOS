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

@implementation StudyCourseCell
@end

@interface CZStudyVC ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
{
    NSInteger currentPage;
}

@property (nonatomic,retain) CZNotDataView *notDataView; //无数据视图

@property (weak, nonatomic) IBOutlet UIView *statusBarView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *statusBarHConstraint;
@property (weak, nonatomic) IBOutlet UIPageControl *coursePageControl;
@property (weak, nonatomic) IBOutlet UIScrollView *courseScrollView;

@property (weak, nonatomic) IBOutlet UIView *topBGBackView;
@property (weak, nonatomic) IBOutlet UIScrollView *bgScroView;

@property (weak, nonatomic) IBOutlet UIImageView *liveCourseIconImgView;
@property (weak, nonatomic) IBOutlet UILabel *liveCourseTitleLB;
@property (weak, nonatomic) IBOutlet UILabel *liveCourseTeacherLB;
@property (weak, nonatomic) IBOutlet UILabel *liveStartTimeLB;
@property (weak, nonatomic) IBOutlet UIButton *enterLiveBtn;
@property (weak, nonatomic) IBOutlet UITableView *studyTabView;
@property (weak, nonatomic) IBOutlet UILabel *studyCourseTipLab;
@property (weak, nonatomic) IBOutlet UIView *studyCourseLineView;
@property (weak, nonatomic) IBOutlet UIView *titleView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tabHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *studyCourseTipConstraint;

@property (strong, nonatomic) NSArray <StudyInfoItem *>*dataArr;
@property (strong, nonatomic) NSArray <LiveItem *>*liveArr;
@property (strong, nonatomic) NSArray <LearnCourseItem *>*courseArr;

@end

@implementation CZStudyVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tabHeightConstraint.constant = 3*60;
    _statusBarHConstraint.constant = kStatusBarH;
    
//    __weak typeof(self) weakSelf = self;
//    _bgScroView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        [weakSelf getData];
//    }];
    
    [self blankView];
    
    [self getData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getData) name:kLoginSuccNotification object:nil]; //登录成功通知
}

#pragma mark - get data

// 分类列表
- (void)getData {
    currentPage = 0;
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         @"1", @"is_newest_info",
                         @"1", @"is_progress",
                         nil];
    __weak typeof(self) weakSelf = self;
    [[NetworkManager sharedManager] postJSON:URL_CourseList parameters:dic imageDataArr:nil imageName:nil  completion:^(id responseData, RequestState status, NSError *error) {
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
    gradientLayer.colors = @[(__bridge id)RGBValue(0xF76B1C).CGColor,  (__bridge id)RGBValue(0xC31A1F).CGColor];
    gradientLayer.locations = @[@0.0, @1.0];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(0, 1.0);
    gradientLayer.frame = _topBGBackView.bounds;
    [self.topBGBackView.layer addSublayer:gradientLayer];
    
    NSInteger courseCount = self.dataArr.count;
    
    _courseScrollView.contentSize = CGSizeMake(courseCount*(WIDTH-20), 0);
    for (NSInteger i = 0; i < courseCount; i ++) {
        
        StudyInfoItem *item = self.dataArr[i];
        
        UIView *view = [[[NSBundle mainBundle]loadNibNamed:@"MyStudyView" owner:self options:nil]firstObject];
        view.frame = CGRectMake(i*(WIDTH-20), 0, (WIDTH-20), 120);
        view.tag = 120+i;
        [_courseScrollView addSubview:view];
        UIImageView *courseIconImgView = [view viewWithTag:2];
        courseIconImgView.contentMode = UIViewContentModeCenter;
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
    }
    _coursePageControl.height = 20;
    _coursePageControl.currentPage = 0;
    _coursePageControl.numberOfPages = courseCount;
}

#pragma mark - methods

#pragma mark - 课程点击
- (void)courseClick:(UIButton *)btn {
    NSInteger index = btn.tag-1000;
    NSLog(@"点击页数：%ld",(long)index);
    
//    StudyInfoItem *item = self.dataArr[index];
}

#pragma mark - 录播课程点击
- (IBAction)luboAction:(id)sender {
    StudyInfoItem *items = _dataArr[currentPage];
    NSString *tikuStr = [NSString stringWithFormat:@"%@%@",H5_Video,items.product_id];
    [BaseWebVC showWithContro:self withUrlStr:tikuStr withTitle:@"" isPresent:NO];
}

#pragma mark - 直播课程
- (IBAction)zhiboAction:(id)sender {
    StudyInfoItem *items = _dataArr[currentPage];
    NSString *tikuStr = [NSString stringWithFormat:@"%@%@",H5_Live,items.product_id];
    [BaseWebVC showWithContro:self withUrlStr:tikuStr withTitle:@"" isPresent:NO];
}

#pragma mark - 资料库
- (IBAction)ziliaokuAction:(id)sender {
    StudyInfoItem *items = _dataArr[currentPage];
    NSString *tikuStr = [NSString stringWithFormat:@"%@%@",H5_Doc,items.product_id];
    [BaseWebVC showWithContro:self withUrlStr:tikuStr withTitle:@"" isPresent:NO];
}

#pragma mark - 题库
- (IBAction)tikuAction:(id)sender {
    StudyInfoItem *items = _dataArr[currentPage];
    NSString *tikuStr = [NSString stringWithFormat:@"%@%@",H5_Question,items.product_id];
    [BaseWebVC showWithContro:self withUrlStr:tikuStr withTitle:@"" isPresent:NO];
}

#pragma mark - 直播课程
- (IBAction)liveCourseAction:(id)sender {
    LiveItem *liveItems = _liveArr.firstObject;
    [BaseWebVC showWithContro:self withUrlStr:liveItems.live_url withTitle:@"" isPresent:NO];
}

#pragma mark - UIScrollViewDelegate协议

//减速滑动(Decelerating:使减速的)
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    int currentPageTem = fabs(scrollView.contentOffset.x)/(WIDTH-20); //计算当前页
    _coursePageControl.currentPage = currentPageTem;
    currentPage = currentPageTem;
    [self refreshUI];
}

- (void)refreshUI {
    StudyInfoItem *items = _dataArr[currentPage];
    _liveArr = items.newest_info.live_list;
    _courseArr = items.newest_info.learn_course_list;
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
    LiveItem *liveItems = _liveArr.firstObject;
    if (liveItems) {
//        [_liveCourseIconImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http:%@",liveItems.]]];
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
    
    _tabHeightConstraint.constant = (MIN(_courseArr.count, 3))*60;
    [_studyTabView reloadData];
}

#pragma mark - UITableView 代理

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return MIN(_courseArr.count, 3);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    StudyCourseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"homeStudyCourseCellID"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    LearnCourseItem *item = _courseArr[indexPath.row];
    cell.studyCourseTitleLB.text = item.name;
    cell.studycourseTimeLB.text = [NSString stringWithFormat:@"学习时间：%@",item.ut];
    return cell;
}

// 学习课程点击
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    LearnCourseItem *item = _courseArr[indexPath.row];
    [BaseWebVC showWithContro:self withUrlStr:item.view_url withTitle:@"" isPresent:NO];
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
