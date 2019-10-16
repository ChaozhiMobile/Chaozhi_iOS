//
//  CZChatVC.m
//  Chaozhi
//
//  Created by zhanbing han on 2019/10/15.
//  Copyright © 2019 Jason_hzb. All rights reserved.
//

#import "CZChatVC.h"

@interface CZChatVC ()
/** <#object#> */
@property (nonatomic,strong) UITableView *chatTab;
/** <#object#> */
@property (nonatomic,strong) UIView *tabFootView;
@end

@implementation CZChatVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = nil;;
    UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 44)];
    [backBtn setImage:[UIImage imageNamed:@"Back"] forState:UIControlStateNormal];
    backBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [backBtn addTarget:self action:@selector(leftBarButtonClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];;
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.backBarButtonItem = nil;
    self.navigationItem.leftBarButtonItems = @[backBarButtonItem];
    self.navigationItem.leftItemsSupplementBackButton = NO;
    [Utils getCurrentVC];
    [self logViewHierarchy:self.view];
    
    NSLog(@"%@",_chatTab);
    
    _tabFootView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, autoScaleW(44))];
//    _tabFootView.backgroundColor = [UIColor redColor];
    _chatTab.tableFooterView = _tabFootView;
    
    [self getTeacherStatus];
}

- (void)getTeacherStatus {
    NSString *utl = [NSString stringWithFormat:@"%@%@/%@",imUrl(),URL_IMQuery_status,self.conversationData.convId];
    NSDictionary *dic = [NSDictionary dictionary];
    [[NetworkManager sharedManager] postJSON:utl parameters:dic imageDataArr:nil imageName:nil  completion:^(id responseData, RequestState status, NSError *error) {
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
