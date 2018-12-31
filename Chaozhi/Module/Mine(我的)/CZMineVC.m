//
//  CZMineVC.m
//  Chaozhi
//
//  Created by Jason_zyl on 2018/9/22.
//  Copyright © 2018年 Jason_hzb. All rights reserved.
//

#import "CZMineVC.h"
#import "PurchaseItem.h"

@interface CZMineVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UIView *headView;
@property (nonatomic,strong) UIImageView *headImgView;
@property (nonatomic,strong) UILabel *accountLab;
@property (nonatomic,strong) UIImageView *arrowImgView;
/** 图片数组 */
@property (nonatomic,strong) NSMutableArray *imageArr;
/** 名称数组 */
@property (nonatomic,strong) NSMutableArray *nameArr;
/** 报班model */
@property (nonatomic,strong) PurchaseItem *purchaseItem;
/** 报班数组 */
@property (nonatomic,strong) NSMutableArray *purchaseArr;

@end

@implementation CZMineVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"个人中心";
    
    [self getData];
    
    self.mineTableView.backgroundColor = [UIColor clearColor];
    self.mineTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.mineTableView.tableHeaderView = self.headView;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getUserInfo) name:kLoginSuccNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getUserInfo) name:kUserInfoChangeNotification object:nil];
}

#pragma mark - get data

- (void)getData {
    
    self.imageArr = [NSMutableArray arrayWithObjects:@"icon_课程",@"icon_消息",@"icon_收藏",@"icon_反馈",@"icon_设置", nil];
    self.nameArr = [NSMutableArray arrayWithObjects:@"课程订单",@"我的消息",@"我的收藏",@"问题反馈",@"系统设置", nil];
    
    [self getPurchaseStatus]; //获取报班状态
    [self getUserInfo]; //获取用户信息
}

// 报班状态
- (void)getPurchaseStatus {
    NSDictionary *dic = [NSDictionary dictionary];
    [[NetworkManager sharedManager] postJSON:URL_PurchaseStatus parameters:dic completion:^(id responseData, RequestState status, NSError *error) {
        
        if (status == Request_Success) {
            
            self.purchaseItem = [PurchaseItem mj_objectWithKeyValues:(NSDictionary *)responseData];
            self.purchaseArr = [self.purchaseItem.chat mutableCopy];
            
            if (self.purchaseItem.is_purchase == 1) {
                
                [self.imageArr insertObject:@"icon_报考资料" atIndex:0];
                [self.nameArr insertObject:@"报考资料" atIndex:0];
                
                if (self.purchaseArr.count>0) {
                    [self.imageArr insertObject:@"icon_班主任" atIndex:0];
                    [self.nameArr insertObject:@"我的班主任" atIndex:0];
                }
                
                [self.mineTableView reloadData];
            }
        }
    }];
}

// 用户信息
- (void)getUserInfo {
    
    if ([Utils isLoginWithJump:YES]) {
        NSDictionary *dic = [NSDictionary dictionary];
        [[NetworkManager sharedManager] postJSON:URL_UserInfo parameters:dic imageDataArr:nil imageName:nil  completion:^(id responseData, RequestState status, NSError *error) {
            
            if (status == Request_Success) {
                NSDictionary *userDic = responseData;
                [[UserInfo share] setUserInfo:[userDic mutableCopy]];
                
                [self.headImgView sd_setImageWithURL:[NSURL URLWithString:[UserInfo share].head_img_url] placeholderImage:[UIImage imageNamed:@"icon_red_wo"]];
                self.accountLab.text = [UserInfo share].phone;
            }
        }];
    }
}

#pragma mark - init view

- (UIView *)headView {
    if (!_headView) {
        _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, autoScaleW(120))];
        _headView.backgroundColor = kWhiteColor;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(jumpPersonalCenter)];
        [_headView addGestureRecognizer:tap];
        
        _headImgView = [[UIImageView alloc] initWithFrame:CGRectMake(autoScaleW(20), autoScaleW(30), autoScaleW(60), autoScaleW(60))];
        _headImgView.contentMode = UIViewContentModeScaleAspectFill;
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
    }
    return _headView;
}

#pragma mark - methods

// 个人中心
- (void)jumpPersonalCenter {
    if ([Utils isLoginWithJump:YES]) {
        [BaseWebVC showWithContro:self withUrlStr:H5_MyInfo withTitle:@"个人中心" isPresent:NO];
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
    
    if ([str isEqualToString:@"我的班主任"]) {
        ChatItem *chatItem = self.purchaseArr[0];
        [BaseWebVC showWithContro:self withUrlStr:chatItem.chat_url withTitle:_nameArr[indexPath.row] isPresent:NO];
    }
    
    if ([str isEqualToString:@"报考资料"]) {
        [BaseWebVC showWithContro:self withUrlStr:H5_Apply withTitle:_nameArr[indexPath.row] isPresent:NO];
    }
    
    if ([str isEqualToString:@"课程订单"]) {
        [BaseWebVC showWithContro:self withUrlStr:H5_Orders withTitle:_nameArr[indexPath.row] isPresent:NO];
    }
    
    if ([str isEqualToString:@"我的优惠券"]) {
        [BaseWebVC showWithContro:self withUrlStr:H5_Coupon withTitle:_nameArr[indexPath.row] isPresent:NO];
    }
    
    if ([str isEqualToString:@"我的消息"]) {
        [BaseWebVC showWithContro:self withUrlStr:H5_Message withTitle:_nameArr[indexPath.row] isPresent:NO];
    }
    
    if ([str isEqualToString:@"我的收藏"]) {
        [BaseWebVC showWithContro:self withUrlStr:H5_MyFav withTitle:_nameArr[indexPath.row] isPresent:NO];
    }
    
    if ([str isEqualToString:@"问题反馈"]) {
        [BaseWebVC showWithContro:self withUrlStr:H5_Feedback withTitle:_nameArr[indexPath.row] isPresent:NO];
    }
    
    if ([str isEqualToString:@"系统设置"]) {
        UIViewController *vc = [Utils getViewController:@"Main" WithVCName:@"CZSettingVC"];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:NO];
    }
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
