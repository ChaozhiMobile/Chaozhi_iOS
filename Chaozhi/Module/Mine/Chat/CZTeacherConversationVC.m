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
#import "TUITextMessageCellData.h"

#define CellHeight autoScaleW(90)

@interface CZTeacherConversationVC ()<UITableViewDelegate,UITableViewDataSource>
/**
 *  消息列表的视图模型
 *  视图模型能够协助消息列表界面实现数据的加载、移除、过滤等多种功能。替界面分摊部分的业务逻辑运算。
 */
@property (nonatomic, strong) TConversationListViewModel *viewModel;
/** 班主任列表 */
@property (nonatomic, retain) NSArray <TeacherItem *>*teacherList;
/** <#object#> */
@property (nonatomic,retain) NSMutableArray *dataSource;
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
    self.dataSource = [NSMutableArray array];
    __weak typeof(self) weakSelf = self;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.mas_equalTo(weakSelf.view);
        make.top.mas_equalTo(weakSelf.view).offset(kNavBarH);
    }];
    
  NSArray *arr=  [[TIMManager sharedInstance]getConversationList];
    for (TIMConversation *conv in arr) {
      NSLog(@"%@",  [conv getReceiver]);
    }

    @weakify(self)
    [RACObserve(self.viewModel, dataList) subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self showTop];
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
            [weakSelf createChat];
        }
    }];
}

- (void)createChat {
    for (TeacherItem *item in self.teacherList) {
        NSString *searchStr =[NSString stringWithFormat:@"convId = '%@'",item.accid];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:searchStr];
        NSArray *data = self.viewModel.dataList;
        NSArray *result = [data filteredArrayUsingPredicate:predicate];
        if (result.count==0) {
            TIMMessage *msg = [[TIMMessage alloc] init];
            TIMCustomElem *custom = [[TIMCustomElem alloc] init];
            custom.data = [@"group_create" dataUsingEncoding:NSUTF8StringEncoding];
            //对于创建群消息时的名称显示（此时还未设置群名片），优先显示用户昵称。
            custom.ext = [NSString stringWithFormat:@"现在我们可以开始聊天啦"];
            [msg addElem:custom];
            TIMConversation *conv = [[TIMManager sharedInstance]getConversation:TIM_C2C receiver:item.accid];
            [conv sendMessage:msg succ:nil fail:nil];
        }
    }
    [self showTop];
}

- (void)showTop {
    
    NSMutableArray *topArr = [NSMutableArray array];//置顶数组
    NSMutableArray *otherArr = [NSMutableArray array];//其他
    if (self.teacherList.count>0) {//老师列表
        for (NSInteger index = self.viewModel.dataList.count-1; index>=0; index--) {
            TUIConversationCellData *data = self.viewModel.dataList[index];
            NSString *searchStr =[NSString stringWithFormat:@"accid = '%@'",data.convId];
               NSPredicate *predicate = [NSPredicate predicateWithFormat:searchStr];
               NSArray *result = [self.teacherList filteredArrayUsingPredicate:predicate];
               if (result.count>0) {
                   [topArr addObject:data];
               }
               else {
                   [otherArr addObject:data];
               }
        }
        [self.dataSource removeAllObjects];
        [self.dataSource addObjectsFromArray:topArr];
        [self.dataSource addObjectsFromArray:otherArr];
    }
    else {
        [self.dataSource addObjectsFromArray:self.viewModel.dataList];
    }
    
    [self.tableView reloadData];
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
    return self.dataSource.count;
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
//        [self.dataSource removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
        [tableView endUpdates];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CZTeacherCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myTeachListCell" forIndexPath:indexPath];
    TUIConversationCellData *data = [self.dataSource objectAtIndex:indexPath.row];
    //可以在此处修改，也可以在对应cell的初始化中进行修改。用户可以灵活的根据自己的使用需求进行设置。
    NSString *searchStr =[NSString stringWithFormat:@"accid = '%@'",data.convId];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:searchStr];
    NSArray *result = [self.teacherList filteredArrayUsingPredicate:predicate];
    cell.courseNameLabel.hidden = YES;
    cell.courseNameLabel.text = @"";
    cell.isTop = NO;
    if (result.count>0) {
        cell.courseNameLabel.hidden = NO;
        TeacherItem *item = [result firstObject];
        cell.courseNameLabel.text = item.product_name;
        cell.isTop = YES;
        data.isOnTop = YES;
    }
    cell.convData = data;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CZTeacherCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    TUIConversationCellData *data = [self.dataSource objectAtIndex:indexPath.row];
    CZChatVC *chat = [[CZChatVC alloc] init];
    chat.conversationData = data;
    chat.isTeacher = cell.isTop;
    [self.navigationController pushViewController:chat animated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.teacherList.count>0) {
        [self showTop];
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

