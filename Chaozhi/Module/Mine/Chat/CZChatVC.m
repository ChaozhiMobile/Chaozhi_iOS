//
//  CZChatVC.m
//  Chaozhi
//
//  Created by zhanbing han on 2019/10/15.
//  Copyright © 2019 Jason_hzb. All rights reserved.
//

#import "CZChatVC.h"
#import "MyCustomCellData.h"
#import "TUIJoinGroupMessageCellData.h"
#import "TUIJoinGroupMessageCell.h"
#import "BaseNC.h"

@interface CZChatVC ()

@property (nonatomic,strong) UITableView *chatTab;
/** <#object#> */
@property (nonatomic,copy) NSString *otherTeacherAccid;
@end

@implementation CZChatVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self logViewHierarchy:self.view];
    _otherTeacherAccid = @"";
//    if (_isTeacher) {
        [self getTeacherStatus];
//    }
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    self.navigationItem.rightBarButtonItem = nil;
    self.navigationItem.leftItemsSupplementBackButton = NO;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"Back"] style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor blackColor];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showTapAction) name:@"didTapOnRestNameLabel" object:nil];
    NSMutableArray *moreMenus = [NSMutableArray array];
    [moreMenus addObject:[TUIInputMoreCellData photoData]];
    [moreMenus addObject:[TUIInputMoreCellData pictureData]];
    self.chat.moreMenus = moreMenus;
}

- (void)getTeacherStatus {
    __weak typeof(self) weakSelf = self;
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",imUrl(),URL_IMQuery_status];
    NSDictionary *dic = @{@"accid":self.conversationData.convId};
    [[NetworkManager sharedManager] postJSON:urlStr parameters:dic completion:^(id responseData, RequestState status, NSError *error) {
        if (status == Request_Success) {
            NSArray *arr = responseData;
            if (arr.count>0) {
                NSDictionary *dic = [arr firstObject];
                NSString *state = [NSString stringWithFormat:@"%@",dic[@"State"]];
                if ([state isEqualToString:@"Offline"]) {
                    [weakSelf mySendMsgWithName:@"联系其他老师" content:@"班主任不在线，您可以留言，或者"];
//                    weakSelf.otherTeacherAccid = [NSString stringWithFormat:@"%@",dic[@"To_Account"]];
                }
            }
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

- (void)mySendMsgWithName:(NSString *)name content:(NSString *)content {
    TUIJoinGroupMessageCellData *joinGroupData = [[TUIJoinGroupMessageCellData alloc] initWithDirection:MsgDirectionIncoming];
    NSString *userString = name;
    joinGroupData.status = Msg_Status_Init;
    joinGroupData.content = [NSString stringWithFormat:@"%@%@",content, userString];
    [joinGroupData.userName addObject:userString];
    [joinGroupData.userID addObject:[[TIMManager sharedInstance] getLoginUser]];
    [self.chat sendMessage:joinGroupData];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self scrollTableToFoot:YES];
    });
}


- (void)showTapAction{
    [self queryOtherTeacher];
    return;
    
    if ([NSString isEmpty:self.otherTeacherAccid]) {
        [self mySendMsgWithName:@"" content:@"抱歉，没有空闲的老师！"];
    }
    
    [self.navigationController popViewControllerAnimated:NO];
     //创建成功后，默认跳转到群组对应的聊天界面
}

- (void)queryOtherTeacher {
    __weak typeof(self) weakSelf = self;
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",imUrl(),URL_Change_teacher];
    NSDictionary *dic = @{@"accid":[[TIMManager sharedInstance] getLoginUser],@"faceid":self.conversationData.convId};
    [[NetworkManager sharedManager] postJSON:urlStr parameters:dic completion:^(id responseData, RequestState status, NSError *error) {
        if (status == Request_Success) {
                NSDictionary *dataDic = responseData;
                if ([dataDic.allKeys containsObject:@"statusCode"]) {
                    NSInteger statusCode = [dataDic[@"statusCode"] integerValue];
                    if (statusCode==401) {
                        [weakSelf mySendMsgWithName:@"" content:@"抱歉，没有空闲的老师！"];
                    }
                }
                else {
                    TUIConversationCellData *data = [[TUIConversationCellData alloc] init];
                    data.convId = responseData[@"faceid"];
                    data.convType = TIM_C2C;
                //    data.title = @"你好呀";
                    CZChatVC *chat = [[CZChatVC alloc] init];
                    chat.conversationData = data;
                    BaseNC *nc = CZAppDelegate.tabVC.selectedViewController;
                    [nc.topViewController.navigationController pushViewController:chat animated:YES];

                }
        }
    }];
}

- (void)scrollTableToFoot:(BOOL)animated
{
    NSInteger s = [self.chatTab numberOfSections];  //有多少组
    if (s<1) return;  //无数据时不执行 要不会crash
    NSInteger r = [self.chatTab numberOfRowsInSection:s-1]; //最后一组有多少行
    if (r<1) return;
    NSIndexPath *ip = [NSIndexPath indexPathForRow:r-1 inSection:s-1];  //取最后一行数据
    [self.chatTab scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionBottom animated:animated]; //滚动到最后一行
}

#pragma mark - 自定义方法
//返回
- (void)backAction {
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
    [self.navigationController popViewControllerAnimated:YES];
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
