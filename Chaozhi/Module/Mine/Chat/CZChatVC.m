//
//  CZChatVC.m
//  Chaozhi
//
//  Created by zhanbing han on 2019/10/15.
//  Copyright © 2019 Jason_hzb. All rights reserved.
//

#import "CZChatVC.h"
#import "MyCustomCellData.h"
#import "TCUtil.h"

@interface CZChatVC ()

@property (nonatomic,strong) UITableView *chatTab;
@property (nonatomic,strong) UIView *tabFootView;
/** <#object#> */
@property (nonatomic,strong) UILabel *tipsLab;
/** <#object#> */
@property (nonatomic,strong) UIButton *tipsBtn;
@end

@implementation CZChatVC

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self logViewHierarchy:self.view];
    
    _tabFootView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, autoScaleW(44))];
    _tabFootView.backgroundColor = [UIColor clearColor];
    _chatTab.tableFooterView = _tabFootView;
    [self initTabFooterView];
    self.tipsLab.text = @"订婚的黑乎乎的";
    [self.tipsBtn setTitle:@"啦啦啦啦啦" forState:UIControlStateNormal];
    
    [self getTeacherStatus];
    self.navigationItem.rightBarButtonItem = nil;
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"Back"] style:UIBarButtonItemStylePlain target:self action:nil];
}

- (void)getTeacherStatus {

    NSString *utl = [NSString stringWithFormat:@"%@%@/%@",imUrl(),URL_IMQuery_status,self.conversationData.convId];
    NSDictionary *dic = [NSDictionary dictionary];
    [[NetworkManager sharedManager] getJSON:utl parameters:dic completion:^(id responseData, RequestState status, NSError *error) {
        if (status == Request_Success) {

        }
    }];
}

- (void)logViewHierarchy:(UIView *)superView
{
    for (UIView *subview in superView.subviews)
    {
        if ([subview isKindOfClass:[ UITableView class]]) {
            self.chatTab = (UITableView *)subview;
            break;
        }
        else {
            [self logViewHierarchy:subview];
        }
    }
}

- (void)initTabFooterView {
    UIView *bgView = [[UIView alloc]init];
    [_tabFootView addSubview:bgView];
    
    __weak typeof(self) weakSelf = self;
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(weakSelf.tabFootView);
        make.height.mas_equalTo(weakSelf.tabFootView);
    }];
    
    _tipsLab = [[UILabel alloc]init];
    _tipsLab.textColor = [UIColor lightGrayColor];
    _tipsLab.font = [UIFont systemFontOfSize:13];
    [bgView addSubview:_tipsLab];
    [_tipsLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.mas_equalTo(bgView);
    }];
    
    _tipsBtn = [[UIButton alloc]init];
    [_tipsBtn setTitleColor:kBlueColor forState:UIControlStateNormal];
    _tipsBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [bgView addSubview:_tipsBtn];
    [_tipsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.mas_equalTo(bgView);
        make.left.mas_equalTo(weakSelf.tipsLab.mas_right);
    }];
    
    
    [self doForceScrollToBottom];
    
}

-(void) doForceScrollToBottom
{
    [self.chatTab scrollToNearestSelectedRowAtScrollPosition:UITableViewScrollPositionBottom animated:YES];
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
