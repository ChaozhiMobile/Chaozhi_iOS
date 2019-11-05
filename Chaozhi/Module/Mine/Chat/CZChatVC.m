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

@end

@implementation CZChatVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self logViewHierarchy:self.view];
    if (_isTeacher) {
        [self getTeacherStatus];
    }
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    self.navigationItem.rightBarButtonItem = nil;
    self.navigationItem.leftItemsSupplementBackButton = NO;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"Back"] style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor blackColor];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showTapAction) name:@"didTapOnRestNameLabel" object:nil];
}

- (void)getTeacherStatus {
    [self mySendMsgWithName:@"联系其他老师" content:@"班主任不在线，您可以留言，或者"];
    return;

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
    [self.navigationController popViewControllerAnimated:NO];
     //创建成功后，默认跳转到群组对应的聊天界面
    TUIConversationCellData *data = [[TUIConversationCellData alloc] init];
    data.convId = @"在线老师";
    data.convType = TIM_C2C;
//    data.title = @"你好呀";
    CZChatVC *chat = [[CZChatVC alloc] init];
    chat.conversationData = data;
    BaseNC *nc = CZAppDelegate.tabVC.selectedViewController;
    [nc.topViewController.navigationController pushViewController:chat animated:YES];
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
