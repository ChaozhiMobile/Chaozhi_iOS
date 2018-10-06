//
//  CZStudyVC.m
//  Chaozhi
//
//  Created by Jason_zyl on 2018/9/22.
//  Copyright © 2018年 Jason_hzb. All rights reserved.
//

#import "CZStudyVC.h"

@implementation StudyCourseCell
@end

@interface CZStudyVC ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIView *statusBarView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *statusBarHConstraint;

@property (weak, nonatomic) IBOutlet UIView *topBGBackView;
@property (weak, nonatomic) IBOutlet UIScrollView *bgScroView;

@property (weak, nonatomic) IBOutlet UIImageView *courseIconImgView;
@property (weak, nonatomic) IBOutlet UILabel *courseTitleLB;
@property (weak, nonatomic) IBOutlet UILabel *courseTypeLB;
@property (weak, nonatomic) IBOutlet UILabel *courseDurationLB;
@property (weak, nonatomic) IBOutlet UILabel *courseSubjectLB;
@property (weak, nonatomic) IBOutlet UIImageView *liveCourseIconImgView;
@property (weak, nonatomic) IBOutlet UILabel *liveCourseTitleLB;
@property (weak, nonatomic) IBOutlet UILabel *liveCourseTeacherLB;
@property (weak, nonatomic) IBOutlet UILabel *liveStartTimeLB;
@property (weak, nonatomic) IBOutlet UITableView *studyTabView;
@property (weak, nonatomic) IBOutlet UIView *titleView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tabHeightConstraint;

@end

@implementation CZStudyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tabHeightConstraint.constant = 3*60;
    _statusBarHConstraint.constant = kStatusBarH;
//    [_bgScroView addSubview:_titleView];
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[(__bridge id)RGBValue(0xF76B1C).CGColor,  (__bridge id)RGBValue(0xC31A1F).CGColor];
    gradientLayer.locations = @[@0.0, @1.0];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(0, 1.0);
    gradientLayer.frame = _topBGBackView.bounds;
    [self.topBGBackView.layer addSublayer:gradientLayer];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    StudyCourseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"homeStudyCourseCellID"];
    return cell;
}

- (void)viewWillAppear:(BOOL)animated {
    
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
