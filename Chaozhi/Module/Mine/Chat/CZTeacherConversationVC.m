//
//  CZTeacherConversationVC.m
//  Chaozhi
//
//  Created by zhanbing han on 2019/10/15.
//  Copyright © 2019 Jason_hzb. All rights reserved.
//

#import "CZTeacherConversationVC.h"
#import "TConversationListViewModel.h"
#import "MMLayout/UIView+MMLayout.h"
#import "THeader.h"
#import "CZChatVC.h"
#import "TeacherItem.h"
#import "CZTeacherCell.h"

#define CellHeight autoScaleW(90)

@interface CZTeacherConversationVC ()<UITableViewDelegate,UITableViewDataSource>
/**
 *  消息列表的视图模型
 *  视图模型能够协助消息列表界面实现数据的加载、移除、过滤等多种功能。替界面分摊部分的业务逻辑运算。
 */
@property (nonatomic, strong) TConversationListViewModel *viewModel;
/** 班主任列表 */
@property (nonatomic, retain) NSArray <TeacherItem *>*teacherList;
@end

@implementation CZTeacherConversationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的班主任";
    self.navigationController.navigationBar.translucent = NO;
    [self setupViews];
    [self getTeacherList];
}

- (void)setupViews {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavBarH+10, WIDTH, HEIGHT-kNavBarH-10)];
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.tableView registerClass:[CZTeacherCell class] forCellReuseIdentifier:@"myTeachListCell"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];

    @weakify(self)
    [RACObserve(self.viewModel, dataList) subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.tableView reloadData];
    }];
}

#pragma mark - 我的班主任列表
- (void)getTeacherList {
    __weak typeof(self) weakSelf = self;
    NSDictionary *dic = [NSDictionary dictionary];
    [[NetworkManager sharedManager] postJSON:URL_TeacherList parameters:dic completion:^(id responseData, RequestState status, NSError *error) {
        if (status == Request_Success) {
            weakSelf.teacherList = [TeacherItem mj_objectArrayWithKeyValuesArray:responseData];
            [weakSelf.tableView reloadData];
        }
    }];
}

- (TConversationListViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [TConversationListViewModel new];
        _viewModel.listFilter = ^BOOL(TUIConversationCellData * _Nonnull data) {
            return (data.convType != TIM_SYSTEM);
        };
    }
    return _viewModel;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.dataList.count;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [tableView beginUpdates];
        TUIConversationCellData *conv = self.viewModel.dataList[indexPath.row];
        [self.viewModel removeData:conv];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
        [tableView endUpdates];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CZTeacherCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myTeachListCell" forIndexPath:indexPath];
    TUIConversationCellData *data = [self.viewModel.dataList objectAtIndex:indexPath.row];
    cell.convData = data;
    //可以在此处修改，也可以在对应cell的初始化中进行修改。用户可以灵活的根据自己的使用需求进行设置。
    NSString *searchStr =[NSString stringWithFormat:@"accid = '%@'",data.convId];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:searchStr];
    NSArray *result = [self.teacherList filteredArrayUsingPredicate:predicate];
    cell.courseNameLabel.hidden = YES;
    cell.courseNameLabel.text = @"";
    if (result.count>0) {
        cell.courseNameLabel.hidden = NO;
        TeacherItem *item = [result firstObject];
        cell.courseNameLabel.text = item.product_name;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TUIConversationCellData *data = [self.viewModel.dataList objectAtIndex:indexPath.row];
    CZChatVC *chat = [[CZChatVC alloc] init];
    chat.conversationData = data;
    [self.navigationController pushViewController:chat animated:YES];
}

- (void)didSelectConversation:(TUIConversationCell *)cell
{
//    CZChatVC *chat = [[CZChatVC alloc] init];
//    chat.conversationData = cell.data;
//    [self.navigationController pushViewController:chat animated:YES];
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

