//
//  GroupChatTableViewController.m
//  TalkfunSDKDemo
//
//  Created by talk－fun on 16/3/8.
//  Copyright © 2016年 talk-fun. All rights reserved.
//

#import "GroupChatTableViewController.h"
#import "ChatModel.h"
#import "MJExtension.h"
#import "ChatCell.h"

@interface GroupChatTableViewController ()

@property (nonatomic,strong) UIButton * btn;

@end

@implementation GroupChatTableViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)createArrayAndOther
{
    //row高度
    self.heightArray                   = [NSMutableArray new];
    self.tableView.separatorStyle      = UITableViewCellSeparatorStyleNone;

    self.tableView.separatorStyle      = UITableViewCellSeparatorStyleNone;
    self.tableView.sectionHeaderHeight = 30;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//    self.view.backgroundColor = [UIColor orangeColor];
    
    CGRect frame      = self.view.frame;
    frame.size.height -= 50;
    self.view.frame   = frame;
    
    CGRect rect                          = self.navigationController.view.frame;
    rect.size.height                     -= 50;
    self.navigationController.view.frame = rect;
    
    self.navigationController.navigationBar.hidden          = NO;
    self.navigationItem.title                               = self.nickname;
    self.navigationController.navigationBar.backgroundColor = [UIColor blueColor];
    
    [self recalculateCellHeight];
    [self.tableView reloadData];
    
    CGFloat distant = self.tableView.contentSize.height - self.navigationController.view.frame.size.height;
    if (distant + 44 > 0) {
        [self.tableView setContentOffset:CGPointMake(0, distant + 44)];
    }
//    NSLog(@"~~~!~~%lf ~~!~~~%lf ~~~!~~%lf ~~~!~~%lf ",self.navigationController.view.frame.origin.x,self.navigationController.view.frame.origin.y,self.navigationController.view.frame.size.width,self.navigationController.view.frame.size.height);
    //NSLog(@"！！！！！~%lf ~！！！！~!~~~%lf ~ %lf",self.tableView.contentOffset.y,self.tableView.contentSize.height,self.navigationController.view.frame.size.height);
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    CGRect frame      = self.view.frame;
    frame.size.height += 50;
    self.view.frame   = frame;
    
    CGRect rect                          = self.navigationController.view.frame;
    rect.size.height                     += 50;
    self.navigationController.view.frame = rect;
    
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    
    
}

- (void)btnClicked:(UIBarButtonItem *)btn{
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

- (void)addObj:(id)obj
{
//    [self.dataSource addObject:obj];
    //记住row的高度
    NSString * msg = obj[@"msg"];
    
    CGRect rect = [msg boundingRectWithSize:CGSizeMake(self.view.frame.size.width - 20, 9999) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];
    CGFloat height = rect.size.height + 30;
    
    [self.heightArray addObject:@(height)];
    
    [self.tableView reloadData];
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.dataSource.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    
    //NSLog(@"！！！！！~%lf ~！！！！~!~~~%lf ~ %lf",self.tableView.contentOffset.y,self.tableView.contentSize.height,self.navigationController.view.frame.size.height);
}

- (void)recalculateCellHeight;
{
    [self.heightArray removeAllObjects];
    
    for (id obj in self.dataSource) {
        
        NSString * msg = obj[@"msg"];
        
        CGRect rect = [msg boundingRectWithSize:CGSizeMake(self.view.frame.size.width - 20, 9999) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];
        CGFloat height = rect.size.height + 40;
        [self.heightArray addObject:@(height)];
        
    }
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ChatCell * cell = [tableView dequeueReusableCellWithIdentifier:@"messageCell"];
    
    if (!cell) {
        cell = [[ChatCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"messageCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    CGRect frame = cell.frame;
    frame.size.width = self.view.frame.size.width;
    cell.frame = frame;
    
    
    NSDictionary * params = self.dataSource[indexPath.row];
    //config名称时间
    //    [cell configCellWithParams:params];
    
    ChatModel *Model = [ChatModel mj_objectWithKeyValues:params];
    cell.btnBlock    = self.btnBlock;
    cell.Model       = Model;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0.0;
    if (self.heightArray.count > indexPath.row) {
        height = [self.heightArray[indexPath.row] floatValue];
    }
    
    return height;
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSDictionary * dict = self.dataSource[indexPath.row];
//    NSString * msg = dict[@"msg"];
//    
//    CGRect rect = [msg boundingRectWithSize:CGSizeMake(self.view.frame.size.width - 20, 9999) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];
//    
//    CGFloat height = rect.size.height + 40;
////    CGFloat height = [self.heightArray[indexPath.row] floatValue];
//    
//    return height;
//}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    return self.nickname;
//}

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    if (scrollView.contentOffset.y <= 0) {
//        self.tableView.tableFooterView = nil;
//        self.tableView.tableHeaderView = self.btn;
//    }else
//    {
//        self.tableView.tableHeaderView = nil;
//        self.tableView.tableFooterView = self.btn;
//    }
//}

//=============== 获取时间和用户名 ======================
- (NSString *)getUserNameAndTimeWith:(NSDictionary *)params
{
    NSString * userName            = params[@"nickname"];
    NSString * time                = params[@"time"];

    NSTimeInterval timeInterval    = [time doubleValue];
    NSDate *detaildate             = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"HH:mm"];

    NSString * currentDateStr      = [dateFormatter stringFromDate: detaildate];
    
    return [NSString stringWithFormat:@"%@:(%@)",userName,currentDateStr];
}

@end
