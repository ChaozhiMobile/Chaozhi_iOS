//
//  CZStudyVC.m
//  Chaozhi
//
//  Created by Jason_zyl on 2018/9/22.
//  Copyright © 2018年 Jason_hzb. All rights reserved.
//

#import "CZStudyVC.h"
#import "StudyInfoItem.h"

@implementation StudyCourseCell
@end

@interface CZStudyVC ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
{
    NSInteger currentPage;
}
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
@property (weak, nonatomic) IBOutlet UITableView *studyTabView;
@property (weak, nonatomic) IBOutlet UIView *titleView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tabHeightConstraint;

@property (strong, nonatomic) NSArray <StudyInfoItem *>*dataArr;
@property (strong, nonatomic) NSArray <LiveItem *>*liveArr;
@property (strong, nonatomic) NSArray <LearnCourseItem *>*courseArr;

@end

@implementation CZStudyVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navBar.hidden = YES;
    [self getData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _tabHeightConstraint.constant = 3*60;
    _statusBarHConstraint.constant = kStatusBarH;
//    __weak typeof(self) weakSelf = self;
//    _bgScroView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        [weakSelf getData];
//    }];
}

#pragma mark - get data

// 分类列表
- (void)getData {
    currentPage = 0;
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         @"1", @"is_newest_info",
                         nil];
    __weak typeof(self) weakSelf = self;
    [[NetworkManager sharedManager] postJSON:URL_CourseList parameters:dic imageDataArr:nil imageName:nil  completion:^(id responseData, RequestState status, NSError *error) {
        if ([weakSelf.bgScroView.mj_header isRefreshing]) {
            [weakSelf.bgScroView.mj_header endRefreshing];
        }
        if (status == Request_Success) {
            self.dataArr = [StudyInfoItem mj_objectArrayWithKeyValuesArray:(NSArray *)responseData];
            [self initView];
            [self refreshUI];
        }
    }];
}

#pragma mark - init view

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
        [courseIconImgView sd_setImageWithURL:[NSURL URLWithString:item.product_img] placeholderImage:[UIImage imageNamed:@"default_square_img"]];
        UILabel *courseTitleLB = [view viewWithTag:3];
        courseTitleLB.text = item.product_name;
        UILabel *courseTypeLB = [view viewWithTag:4];
        courseTypeLB.text = item.product_sub_name;
        UILabel *courseDurationLB = [view viewWithTag:5];
        courseDurationLB.text = [NSString stringWithFormat:@"%@分钟",item.user_time];
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

- (void)courseClick:(UIButton *)btn {
    NSInteger index = btn.tag-1000;
    NSLog(@"点击页数：%ld",(long)index);
    
//    StudyInfoItem *item = self.dataArr[index];
    
}

#pragma mark - UIScrollViewDelegate协议

//减速滑动(Decelerating:使减速的)
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    int currentPageTem = fabs(scrollView.contentOffset.x)/(WIDTH-20); //计算当前页
    _coursePageControl.currentPage = currentPageTem;
    currentPage = currentPageTem;
    [self refreshUI];
}

- (void)refreshUI{
    StudyInfoItem *items = _dataArr[currentPage];
    _liveArr = items.newest_info.live_list;
    _courseArr = items.newest_info.learn_course_list;
    LiveItem *liveItems = _liveArr.firstObject;
    if (liveItems) {
//        [_liveCourseIconImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http:%@",liveItems.]]];
        _liveCourseIconImgView.image = [UIImage imageNamed:@"default_live"];
        _liveCourseTitleLB.text = liveItems.live_name;
        _liveCourseTeacherLB.text = liveItems.teacher;
        _liveStartTimeLB.text = [NSString stringWithFormat:@"开始时间：%@",liveItems.live_st];
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
