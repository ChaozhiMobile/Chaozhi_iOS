//
//  CZHomeVC.m
//  Chaozhi
//
//  Created by Jason_zyl on 2018/9/22.
//  Copyright © 2018年 Jason_hzb. All rights reserved.
//

#import "CZHomeVC.h"
#import <SDCycleScrollView.h>
@implementation DayNewTabCell
@end

@interface CZHomeVC ()<UITableViewDataSource,UITableViewDelegate>
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
- (IBAction)showMoreCourseAction:(UIButton *)sender;
- (IBAction)showPublicCourseAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *showMorePublicCourseAction;
- (IBAction)showActivityDetailAction:(id)sender;

@end

@implementation CZHomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _bannerView.imageURLStringsGroup = @[@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1538225125394&di=422070ccf9e0a249d5d0691cb9acef8f&imgtype=0&src=http%3A%2F%2Fpic.qiantucdn.com%2F58pic%2F25%2F99%2F58%2F58aa038a167e4_1024.jpg",@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1538225125394&di=422070ccf9e0a249d5d0691cb9acef8f&imgtype=0&src=http%3A%2F%2Fpic.qiantucdn.com%2F58pic%2F25%2F99%2F58%2F58aa038a167e4_1024.jpg",@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1538225125394&di=422070ccf9e0a249d5d0691cb9acef8f&imgtype=0&src=http%3A%2F%2Fpic.qiantucdn.com%2F58pic%2F25%2F99%2F58%2F58aa038a167e4_1024.jpg"];
    self.title = @"首页";
    _lastViewHConstraints.constant = 5*100+40;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DayNewTabCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DayNewTabCellID"];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
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

- (IBAction)showMoreCourseAction:(UIButton *)sender {
}

- (IBAction)showPublicCourseAction:(id)sender {
}
- (IBAction)showActivityDetailAction:(id)sender {
}
@end
