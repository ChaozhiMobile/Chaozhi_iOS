//
//  XZHomeVC.m
//  Xuezhi
//
//  Created by Jason_zyl on 2019/7/28.
//  Copyright © 2019 Jason_hzb. All rights reserved.
//

#import "XZHomeVC.h"

#define lineCount 5

@interface XZHomeVC ()

@end

@implementation XZHomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navBar.hidden = YES;
    self.view.backgroundColor = kWhiteColor;
    _bannerView.imageURLStringsGroup = @[@"http://static.699pic.com/images/newActivities/5d15f0f091d1f.jpg",@"http://static.699pic.com/images/newActivities/5d15f0f091d1f.jpg"];
    
    CGFloat viewLeft = 0;
    for (NSInteger index = 0; index <5; index++) {
        UIView *view = [self createMenuView];
        view.left = viewLeft;
        [_menScrollView addSubview:view];
        viewLeft = view.right;
    }
    _menScrollView.contentSize = CGSizeMake(viewLeft, 0);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==0) {
        return 2;
    }
    else if (section==2) {
        return 10;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XZHomeTabCell *cell;
    if (indexPath.section==0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"XZHomeTabCell1"];
    }
    else if (indexPath.section==1) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"XZHomeTabCell2"];
    }
    else if (indexPath.section==2) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"XZHomeTabCell3"];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0) {
        return 200;
    }
    else if (indexPath.section==1) {
       return 120;
    }
    else if (indexPath.section==2) {
        return 114;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 80;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 20;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 80)];
    
    UILabel *bgTitleLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 17, 200, 30)];
    bgTitleLab.font = [UIFont systemFontOfSize:22 weight:UIFontWeightBold];
    bgTitleLab.text = @"PART ONE";
    bgTitleLab.textColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Rectangle"]];
    bgTitleLab.textAlignment = NSTextAlignmentCenter;
    bgTitleLab.centerX = bgView.width/2.0;
    [bgView addSubview:bgTitleLab];
    
    UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 30, 200, 30)];
    titleLab.text = @"行业资讯";
    titleLab.centerX = bgView.width/2.0;
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.font = [UIFont systemFontOfSize:18 weight:UIFontWeightBold];
    [bgView addSubview:titleLab];
    
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, titleLab.bottom+3, 30, 3)];
    lineView.backgroundColor = AppThemeColor;
    lineView.centerX = titleLab.centerX;
    [bgView addSubview:lineView];
    
    UIButton *moreBtn = [[UIButton alloc]initWithFrame:CGRectMake(bgView.width-100-16, 0, 100, 40)];
    [moreBtn setTitle:@"更多课程" forState:UIControlStateNormal];
    [moreBtn setTitleColor:AppThemeColor forState:UIControlStateNormal];
    moreBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    moreBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    moreBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
    moreBtn.centerY = titleLab.centerY;
    [bgView addSubview:moreBtn];
    
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(moreBtn.width-6, 14, 6, 12)];;
    imgView.image = [UIImage imageNamed:@"home_more"];
    [moreBtn addSubview:imgView];
    
    return bgView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (UIView *)createMenuView {
    CGFloat viewW = WIDTH/lineCount;
    UIView *vv = [[UIView alloc]initWithFrame:CGRectMake(0, 0, viewW, 120)];
    
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake((vv.width-autoScaleW(44))/2.0, 26, autoScaleW(44), autoScaleW(44))];
    imgView.cornerRadius = imgView.width/2.0;
    imgView.backgroundColor = [UIColor cyanColor];
    [vv addSubview:imgView];
    
    UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(5, imgView.bottom+10, vv.width-10, 36)];
    titleLab.textColor = RGBValue(0x6C7787);
    titleLab.text = @"心理咨询";
    titleLab.font = [UIFont systemFontOfSize:12 ];
    [vv addSubview:titleLab];
    
    return vv;
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

@implementation XZHomeTabCell

@end
