//
//  ChatViewController.m
//  Talkfun_demo
//
//  Created by talk－fun on 16/1/25.
//  Copyright © 2016年 talk-fun. All rights reserved.
//

#import "ChatViewController.h"
#import "MJExtension.h"
#import "PlaybackChatModel.h"
#import "ChatTableViewCell.h"
#import "TalkfunNewChatTableViewCell.h"

@interface ChatViewController ()

@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:FilePath2]) {
        
        [[NSFileManager defaultManager] removeItemAtPath:FilePath2 error:nil];
        
    }
    
    __weak typeof(self) weakSelf = self;
    MJRefreshNormalHeader * header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getDataWithFilePath:FilePath2 andString:@"starttime"];
        [weakSelf.tableView.mj_header endRefreshing];
    }];
    self.tableView.mj_header = header;
    
    MJRefreshAutoStateFooter * footer = [MJRefreshAutoStateFooter footerWithRefreshingBlock:^{
        [weakSelf removeExtraData];
        [weakSelf.tableView.mj_footer endRefreshing];
    }];
    [footer setTitle:@"点击或上拉清除多余信息" forState:MJRefreshStateIdle];
    [footer setTitle:@"松开清除多余信息" forState:MJRefreshStateWillRefresh];
    [footer setTitle:@"正在清除多余信息" forState:MJRefreshStateRefreshing];
    footer.automaticallyRefresh = NO;
    self.tableView.mj_footer = footer;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noti:) name:@"playbackChat" object:nil];
}

//================== 监听chat回来的数据处理 ======================
- (void)noti:(NSNotification *)notification
{
    [self.dataSource removeAllObjects];
//    [self.displayCellArray removeAllObjects];
    [self.dataDict removeAllObjects];
    [self.heightArray removeAllObjects];
    [self.answerHeightDict removeAllObjects];
    self.sum = 0;
    
    NSDictionary * params = notification.userInfo;
    NSArray * array = params[@"mess"];

    for (id obj in array) {
       [self.dataSource addObject:obj];
        [self.selectedArray addObject:@(0)];

        
    }
    NSData * data = [NSJSONSerialization dataWithJSONObject:self.dataSource options:0 error:nil];
    [self saveData:data WithUrlStringAndParams:[NSString stringWithFormat:@"%@",self.dataSource.firstObject[@"starttime"]] inFilePath:FilePath2];
    
    //刷新数据
    [self.tableView reloadData];
    
}

- (void)recalculateCellHeight
{
//    [self.heightArray removeAllObjects];
//    for (id obj in self.dataSource) {
//        
//        NSString * msg = obj[@"message"];
//        
//        //计算信息内容的高度
//        if (msg) {
//            NSString * msgString = msg;
//            for (NSString * name in self.expressionDict) {
//                msgString = [msgString stringByReplacingOccurrencesOfString:name withString:self.expressionDict[name]];
//                
//            }
//            
//            CGRect rect    = [msgString boundingRectWithSize:CGSizeMake(self.view.frame.size.width - 20, 9999) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];
//            CGFloat height = rect.size.height + 30;
//            
//            [self.heightArray addObject:@(height)];
//        }
//       
//    }
    [self.tableView reloadData];
}

#pragma mark - tableView dataSource 代理方法
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    TalkfunNewChatTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"newChatCell"];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"TalkfunNewChatTableViewCell" owner:nil options:nil][0];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary * params = self.dataSource[indexPath.row - 1];

    cell.number = indexPath.row;
    cell.selectedArray = self.selectedArray;
    [cell configCell:params isPlayback:YES];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 10;
    }
    
    NSDictionary * params = self.dataSource[indexPath.row - 1];
//    PlaybackChatModel *Model = [PlaybackChatModel mj_objectWithKeyValues:params];
//    NSDictionary * info = [TalkfunUtils assembleAttributeString:Model.message boundingSize:CGSizeMake(CGRectGetWidth(self.tableView.frame) - 48, MAXFLOAT) fontSize:14 shadow:NO];
//    NSString * rectStr = info[TextRect];
//    CGRect rect = CGRectFromString(rectStr);
//    CGFloat height = rect.size.height+15+16+8;
    
    
    
    
    
    
    
            NSString * msg = params[@"msg"];
    
            //计算信息内容的高度
            NSString * msgString = msg;
            for (NSString * name in self.expressionDict) {
                msgString = [msgString stringByReplacingOccurrencesOfString:name withString:self.expressionDict[name]];
    
            }
    
            CGRect rect    = [msgString boundingRectWithSize:CGSizeMake(self.view.frame.size.width - 20, 9999) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];
            CGFloat height = rect.size.height + 30+8;
    
//            [self.heightArray addObject:@(height)];
    
    
    
//     CGFloat height = 100;
//    CGFloat height = [self.heightArray[indexPath.row - 1] floatValue];
//    
//    if (indexPath.row == self.heightArray.count) {
//        height += 20;
//    }
    
    return height;
}

//- (void)refreshView:(MJRefreshBaseView *)refreshView stateChange:(MJRefreshState)state
//{
//    if (state == MJRefreshStateRefreshing) {
//        if (refreshView == self.headerView) {
//            [self getDataWithFilePath:FilePath2 andString:@"starttime"];
//        }
//        else if (refreshView == self.footerView)
//        {
//            [self removeExtraData];
//        }
//        
//        [self.headerView endRefreshing];
//        [self.footerView endRefreshing];
//    }
//}

- (void)refreshUIWithDuration:(CGFloat)duration
{
    [self dataWithDuration:duration andFilePath:FilePath2];
    int i = 0;
    int j = 0;
    for (i = 0; i < self.dataSource.count; i += 50) {
        j = 0;
        
        NSDictionary * dict = self.dataSource[i];
        
        if ([dict[@"starttime"] floatValue] > duration) {
            j = i;
            break;
        }
        j = 1;
    }
    //第一个数据的starttime就大于duration
    if (j == 0)
    {
        if (self.selectedArray.count != 1 && [self.selectedArray[1] integerValue] != 1) {
            self.cellNum = 1;
            [self refreshUIWithIndex:self.cellNum];
        }
        
    }
    //没有一个数据的starttime比duration大
    else if (j == 1)
    {
        for (i = i - 50; i < self.dataSource.count; i ++) {
            NSDictionary * dict = self.dataSource[i];
            
            if ([dict[@"starttime"] floatValue] > duration) {
                if (self.cellNum != i) {
                    [self refreshUIWithIndex:i];
                    self.cellNum = i;
                }
                break;
            }
        }
        if (i == self.dataSource.count) {
            if (self.cellNum != i) {
                [self refreshUIWithIndex:(int)self.dataSource.count];
                self.cellNum = (int)self.dataSource.count;
            }
        }
    }
    //有数据的starttime比duration大 但不是第一个
    else if (j != 0) {
        for (int k = j - 50; k < j; k ++) {
            NSDictionary * dict = self.dataSource[k];
            
            if ([dict[@"starttime"] floatValue] > duration) {
                if (self.cellNum != k) {
                    [self refreshUIWithIndex:k];
                    self.cellNum = k;
                }
                break;
            }
        }
    }
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
