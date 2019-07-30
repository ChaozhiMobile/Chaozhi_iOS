//
//  XZHomeVC.m
//  Xuezhi
//
//  Created by Jason_zyl on 2019/7/28.
//  Copyright © 2019 Jason_hzb. All rights reserved.
//

#import "XZHomeVC.h"
#import "VersionItem.h"
#import <StoreKit/StoreKit.h>
#import "CZUpdateView.h"

#define lineCount 5

@interface XZHomeVC ()<UITableViewDataSource,UITableViewDelegate,SKStoreProductViewControllerDelegate, UpdateViewDelegate>

/** 版本更新 */
@property (nonatomic, strong) UIView *BGView;
@property (nonatomic, strong) CZUpdateView *updateView;
@property (nonatomic, retain) VersionItem *versionItem;

@end

@implementation XZHomeVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (![Utils getNetStatus]) {
        XLGAlertView *alert = [[XLGAlertView alloc] initWithTitle:@"温馨提醒" content:@"检测到您的网络异常，请检查网络" leftButtonTitle:@"" rightButtonTitle:@"我知道了"];
    }
    
    [self getData];
    
    [self checkVersion];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeServerSucc) name:kChangeServerSuccNotification object:nil]; //环境切换成功通知
    
    _versionItem = [[VersionItem alloc] init];
    _bannerView.imageURLStringsGroup = @[@"http://static.699pic.com/images/newActivities/5d15f0f091d1f.jpg",@"http://static.699pic.com/images/newActivities/5d15f0f091d1f.jpg"];
    
    CGFloat viewLeft = 0;
    for (NSInteger index = 0; index <8; index++) {
        UIView *view = [self createMenuView];
        view.left = viewLeft;
        [_courseScrollView addSubview:view];
        viewLeft = view.right;
    }
    _courseScrollView.contentSize = CGSizeMake(viewLeft, 0);
}

- (void)changeServerSucc {
    [self getData];
}

#pragma mark - get data

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
    titleLab.textAlignment = NSTextAlignmentCenter;
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
