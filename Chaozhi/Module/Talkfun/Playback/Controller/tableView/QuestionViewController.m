//
//  QuestionViewController.m
//  Talkfun_demo
//
//  Created by talk－fun on 16/1/25.
//  Copyright © 2016年 talk-fun. All rights reserved.
//

#import "QuestionViewController.h"
#import "QuestionTableViewCell.h"
#import "PlaybackQuestionModel.h"
#import "MJExtension.h"
#import "TalkfunNewQuestionCell.h"
#import "QuestionModel.h"

@interface QuestionViewController ()

@end

@implementation QuestionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:FilePath3]) {
     
        [[NSFileManager defaultManager] removeItemAtPath:FilePath3 error:nil];
    }
    
    __weak typeof(self) weakSelf = self;
    MJRefreshNormalHeader * header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getDataWithFilePath:FilePath3 andString:@"startTime"];
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ask:) name:@"playbackAsk" object:nil];
}

//==================监听ask和chat回来的数据处理======================
- (void)ask:(NSNotification *)notification
{
    [self.dataSource removeAllObjects];
//    [self.displayCellArray removeAllObjects];
    [self.dataDict removeAllObjects];
    [self.heightArray removeAllObjects];
    [self.answerHeightDict removeAllObjects];
    self.sum = 0;
    
    NSDictionary * params = notification.userInfo;
    NSArray * arr   = params[@"mess"];
//    NSMutableArray * arr  = [NSMutableArray new];
//    if ([dict isKindOfClass:[NSDictionary class]]) {
//        for (NSString * str in dict) {
//            [arr addObject:str];
//            [self.dataDict setObject:dict[str] forKey:str];
//        }
//        //将数组里面的元素排序
//        NSArray * rankedArray = [arr sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
//            NSNumber * number1 = @([obj1 integerValue]);
//            NSNumber * number2 = @([obj2 integerValue]);
//            return [number1 compare:number2];
//        }];
//        [arr removeAllObjects];
//        for (NSString * str in rankedArray) {
//            [arr addObject:dict[str]];
//        }
//    }
    
    for (id obj in arr) {
        [self.dataSource addObject:obj];
        [self.selectedArray addObject:@(0)];
        [self.dataDict setObject:@(self.dataSource.count - 1) forKey:obj[@"qid"]];
        //记住row的高度
        NSString * content = obj[@"content"];
        //计算信息内容的高度
        CGRect rect = [content boundingRectWithSize:CGSizeMake(self.view.frame.size.width - 20, 9999) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];
        CGFloat height = rect.size.height + 30;
        [self.heightArray addObject:@(height)];
        
        //如果问题有回复（老师回复）
        if (obj[@"answer"]) {
            NSArray * answerArray = obj[@"answer"];
            NSMutableArray * arr = [NSMutableArray new];
            int i = 0;
            for (; i < answerArray.count; i ++) {
                
                NSDictionary * dictionary = answerArray[i];
                
                if ([dictionary isKindOfClass:[NSDictionary class]] && dictionary[@"message"]) {
                    NSString * msg = dictionary[@"message"];
                    CGRect rect = [msg boundingRectWithSize:CGSizeMake(self.view.frame.size.width - 20, 9999) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];
                    CGFloat height = rect.size.height + 30;
                    [arr addObject:@(height)];
                    
                }
                else if ([dictionary isKindOfClass:[NSDictionary class]] && dictionary[@"content"])
                {
                    NSString * content = dictionary[@"content"];
                    CGRect rect = [content boundingRectWithSize:CGSizeMake(self.view.frame.size.width - 20, 9999) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];
                    CGFloat height = rect.size.height + 30;
                    [arr addObject:@(height)];
                }
                
            }
            if (arr.count != 0) {
                 [self.answerHeightDict setObject:arr forKey:@(self.dataSource.count - 1)];
            }
        }
    }
    NSData * data = [NSJSONSerialization dataWithJSONObject:self.dataSource options:0 error:nil];
    [self saveData:data WithUrlStringAndParams:[NSString stringWithFormat:@"%@",self.dataSource.firstObject[@"startTime"]] inFilePath:FilePath3];
    //刷新数据
    [self.tableView reloadData];
    
}

- (void)recalculateCellHeight
{
//    [self.heightArray removeAllObjects];
//    [self.answerHeightDict removeAllObjects];
//    int i = 0;
//    for (id obj in self.dataSource) {
//        NSString * content = obj[@"content"];
//        
//        //计算信息内容的高度
//        CGRect rect = [content boundingRectWithSize:CGSizeMake(self.view.frame.size.width - 20, 9999) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];
//        CGFloat height = rect.size.height + 30;
//        [self.heightArray addObject:@(height)];
//        
//        //如果问题有回复（老师回复）
//        if (obj[@"answer"]) {
//            NSArray * answerArray = obj[@"answer"];
//            NSMutableArray * arr  = [NSMutableArray new];
//            for (int i = 0; i < answerArray.count; i ++) {
//                
//                NSDictionary * dict = answerArray[i];
//                NSString * content  = dict[@"content"];
//                
//                CGRect rect    = [content boundingRectWithSize:CGSizeMake(self.view.frame.size.width - 20, 9999) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];
//                CGFloat height = rect.size.height + 30;
//                [arr addObject:@(height)];
//                
//            }
//            [self.answerHeightDict setObject:arr forKey:@(i)];
//        }
//        i ++;
//    }
    [self.tableView reloadData];
}

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
    
    TalkfunNewQuestionCell * cell = [tableView dequeueReusableCellWithIdentifier:@"liveQuestionCell"];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"TalkfunNewQuestionCell" owner:nil options:nil][0];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.number = indexPath.row;
    cell.selectedArray = self.selectedArray;
    NSDictionary * dict = self.dataSource[indexPath.row - 1];
    [cell configCell:dict isPlayback:YES];
    //提问的cell

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 10;
    }
    QuestionModel * model = [QuestionModel mj_objectWithKeyValues:self.dataSource[indexPath.row-1]];
    NSArray * array = model.answer;
    CGFloat sumHeight = 0;
    for (int i = 0; i < array.count; i ++) {
        NSDictionary * dict = array[i];
        if ([dict isKindOfClass:[NSDictionary class]]) {
            NSDictionary * info = [TalkfunUtils assembleAttributeString:dict[@"content"] boundingSize:CGSizeMake(CGRectGetWidth(self.view.frame)-48, MAXFLOAT) fontSize:13 shadow:NO];
            NSString * rectStr = info[TextRect];
            CGRect rect = CGRectFromString(rectStr);
            CGFloat height = rect.size.height+15+16;
            sumHeight += height;
        }
    }
    NSDictionary * info = [TalkfunUtils assembleAttributeString:model.content boundingSize:CGSizeMake(CGRectGetWidth(self.view.frame)-48, MAXFLOAT) fontSize:13 shadow:NO];
    NSString * rectStr = info[TextRect];
    CGRect rect = CGRectFromString(rectStr);
    CGFloat height = rect.size.height+15+16;
    sumHeight += height;
    return sumHeight;
//    //拿出高度返回
//    CGFloat answerHeight = 0;
//    if ([self.answerHeightDict objectForKey:@(indexPath.row - 1)]) {
//        NSArray * arr = self.answerHeightDict[@(indexPath.row - 1)];
//        for (int i = 0; i < arr.count; i ++) {
//            answerHeight += [arr[i] floatValue];
//        }
//    }
//    CGFloat height = [self.heightArray[indexPath.row - 1] floatValue];
//    
//    if (indexPath.row == self.heightArray.count) {
//        height += 20;
//    }
//    return height + answerHeight;
}

//- (void)refreshView:(MJRefreshBaseView *)refreshView stateChange:(MJRefreshState)state
//{
//    if (state == MJRefreshStateRefreshing) {
//        if (refreshView == self.headerView) {
//            [self getDataWithFilePath:FilePath3 andString:@"startTime"];
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
    [self dataWithDuration:duration andFilePath:FilePath3];
    //    if (self.which == 2) {
    int i = 0;
    int j = 0;
    for (i = 0; i < self.dataSource.count; i += 50) {
        j = 0;
        
        NSDictionary * dict = self.dataSource[i];
        
        if ([dict[@"startTime"] floatValue] > duration) {
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
            
            if ([dict[@"startTime"] floatValue] > duration) {
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
            
            if ([dict[@"startTime"] floatValue] > duration) {
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
