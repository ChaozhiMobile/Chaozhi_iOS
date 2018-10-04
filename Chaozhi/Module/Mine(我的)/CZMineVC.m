//
//  CZMineVC.m
//  Chaozhi
//
//  Created by Jason_zyl on 2018/9/22.
//  Copyright © 2018年 Jason_hzb. All rights reserved.
//

#import "CZMineVC.h"

@interface CZMineVC ()<UITableViewDelegate,UITableViewDataSource>
{
    NSArray *_imageArr;
    NSArray *_nameArr;
}

@property (nonatomic,strong) UIView *headView;
@property (nonatomic,strong) UIImageView *headImgView;
@property (nonatomic,strong) UILabel *accountLab;
@property (nonatomic,strong) UIImageView *arrowImgView;

@end

@implementation CZMineVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"个人中心";
    
    [self getData];
    
    self.mineTableView.backgroundColor = [UIColor clearColor];
    self.mineTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.mineTableView.tableHeaderView = self.headView;
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginAction) name:kLoginSuccNotification object:nil];

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loginAction];
}

- (void)getData {
    
    _imageArr = @[@"icon_课程",@"icon_优惠券",@"icon_消息",@"icon_反馈",@"icon_设置"];
    _nameArr = @[@"课程订单",@"我的优惠券",@"我的消息",@"问题反馈",@"系统设置"];
}

- (UIView *)headView {
    if (!_headView) {
        _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, autoScaleW(120))];
        _headView.backgroundColor = kWhiteColor;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(jumpPersonalCenter)];
        [_headView addGestureRecognizer:tap];
        
        _headImgView = [[UIImageView alloc] initWithFrame:CGRectMake(autoScaleW(20), autoScaleW(30), autoScaleW(60), autoScaleW(60))];
        _headImgView.backgroundColor = PageColor;
        _headImgView.layer.cornerRadius = autoScaleW(30);
        [_headImgView.layer setMasksToBounds:YES];
        [_headView addSubview:_headImgView];
        
        _accountLab = [[UILabel alloc] initWithFrame:CGRectMake(_headImgView.right+autoScaleW(10), autoScaleW(50), WIDTH-autoScaleW(120), autoScaleW(20))];
        _accountLab.textColor = RGBValue(0x4A4A4A);
        _accountLab.font = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
        [_headView addSubview:_accountLab];
        
        _arrowImgView = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH-autoScaleW(23), autoScaleW(54), autoScaleW(8), autoScaleW(12))];
        _arrowImgView.image = [UIImage imageNamed:@"arrow_more"];
        [_headView addSubview:_arrowImgView];
        
        [self.headImgView sd_setImageWithURL:[NSURL URLWithString:[UserInfo share].head_img_url] placeholderImage:[UIImage imageNamed:@"icon_red_wo"]];
        self.accountLab.text = [UserInfo share].phone;
    }
    return _headView;
}

#pragma mark - methods

// 登录处理
- (void)loginAction {
    
    NSDictionary *dic = [NSDictionary dictionary];
    [[NetworkManager sharedManager] postJSON:URL_UserInfo parameters:dic imageDataArr:nil imageName:nil  completion:^(id responseData, RequestState status, NSError *error) {
        
        if (status == Request_Success) {
            NSDictionary *userDic = responseData;
            [[UserInfo share] setUserInfo:[userDic mutableCopy]];
            
//            [self.mineTableView reloadData];
            
            [self.headImgView sd_setImageWithURL:[NSURL URLWithString:[UserInfo share].head_img_url] placeholderImage:[UIImage imageNamed:@"icon_red_wo"]];
            self.accountLab.text = [UserInfo share].phone;
            
            [self.mineTableView reloadData];
        }
    }];
}

// 个人中心
- (void)jumpPersonalCenter {
    if ([Utils isLoginWithJump:YES]) {
        [BaseWebVC showWithContro:self withUrlStr:@"https://www.baidu.com/" withTitle:@"个人中心" isPresent:NO];
    }
}

#pragma mark - UITableView 代理

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _nameArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *ID = @"MineCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.backgroundColor = kWhiteColor;
        
        UIImageView *arrowImgView = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH-autoScaleW(23), autoScaleW(19), autoScaleW(8), autoScaleW(12))];
        arrowImgView.image = [UIImage imageNamed:@"arrow_more"];
        [cell addSubview:arrowImgView];
    }
    
    if (indexPath.row==_nameArr.count-1) {
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 49, WIDTH, 1)];
        lineView.backgroundColor = kWhiteColor;
        [lineView setViewShadowColor:RGBValue(0xD9E2E9) shadowOpacity:0.5 shadowBlur:autoScaleW(1) shadowOffset:CGSizeMake(0, autoScaleW(1))];
        [cell addSubview:lineView];
    } else {
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(autoScaleW(15), 49, WIDTH-autoScaleW(30), 1)];
        lineView.backgroundColor = RGBValue(0xE0E0E1);
        [cell addSubview:lineView];
    }
    
    cell.imageView.image = [UIImage imageNamed:_imageArr[indexPath.row]];
    cell.textLabel.text = _nameArr[indexPath.row];
    cell.textLabel.textColor = RGBValue(0x24253D);
    cell.textLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightMedium];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *str = _nameArr[indexPath.row];
    
    if ([str isEqualToString:@"课程订单"]) {
        [BaseWebVC showWithContro:self withUrlStr:H5_Orders withTitle:_nameArr[indexPath.row] isPresent:NO];
    }
    
    if ([str isEqualToString:@"我的优惠券"]) {
        [BaseWebVC showWithContro:self withUrlStr:H5_Orders withTitle:_nameArr[indexPath.row] isPresent:NO];
    }
    
    if ([str isEqualToString:@"我的消息"]) {
        [BaseWebVC showWithContro:self withUrlStr:H5_Orders withTitle:_nameArr[indexPath.row] isPresent:NO];
    }
    
    if ([str isEqualToString:@"问题反馈"]) {
        [BaseWebVC showWithContro:self withUrlStr:H5_Orders withTitle:_nameArr[indexPath.row] isPresent:NO];
    }
    
    if ([str isEqualToString:@"系统设置"]) {
        [BaseWebVC showWithContro:self withUrlStr:H5_Orders withTitle:_nameArr[indexPath.row] isPresent:NO];
    }
    
//    [BaseWebVC showWithContro:self withUrlStr:@"http://static.evcoming.com/vin-4-5/" withTitle:_nameArr[indexPath.row] isPresent:NO];
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
