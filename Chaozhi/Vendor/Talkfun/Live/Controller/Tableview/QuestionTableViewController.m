//
//  QuestionTableViewController.m
//  Talkfun_demo
//
//  Created by talk－fun on 16/1/26.
//  Copyright © 2016年 talk-fun. All rights reserved.
//

#import "QuestionTableViewController.h"
#import "QuestionModel.h"
#import "MJExtension.h"
#import "TalkfunNewQuestionCell.h"
#import "QuestionCell.h"

@interface QuestionTableViewController ()

@end

@implementation QuestionTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ask:) name:@"ask" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(questionList:) name:@"questionList" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reply:) name:@"reply" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteQuestion:) name:@"deleteQuestion" object:nil];
    
}

//老师删除信息
- (void)deleteQuestion:(NSNotification *)notification
{
    NSString * qid = [NSString stringWithFormat:@"%@",notification.userInfo[@"qid"]];
    for (int i = 0; i < self.dataSource.count; i ++) {
        NSMutableDictionary * dict = self.dataSource[i];
        //先查询最外层的 如果有就直接跳出循环
        NSString * dictQid = [NSString stringWithFormat:@"%@",dict[@"qid"]];
        if ([dictQid isEqualToString:qid]) {
            if (i< self.dataSource.count) {
                 [self.dataSource removeObjectAtIndex:i];
            }
           
            break;
        }
        
        //如果没有就查询这个问题对应的answer，如果找到就删除，然后跳出循环
        NSMutableArray * answersArr = dict[@"answer"];
        int k = 0;
        for (int j = 0; j < answersArr.count; j ++) {
            NSDictionary * answer = answersArr[j];
            if ([answer[@"qid"] integerValue] == [qid integerValue]) {
                if (answersArr.count>j) {
                     [answersArr removeObjectAtIndex:j];
                }
                [dict setObject:answersArr forKey:@"answer"];
                [self.dataSource replaceObjectAtIndex:i withObject:dict];
                
                k = 1;
                break;
            }
        }
        if (k == 1) {
            break;
        }
    }
    //重新计算高度 刷新tableView
    [self recalculateCellHeight];
    [self.tableView reloadData];
    if (self.dataSource.count > 0) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.dataSource.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
    
}

//=================初始化回来的问答数据处理=========================
- (void)questionList:(NSNotification *)notification
{
    [self.rankArray removeAllObjects];
    [self.dataDict removeAllObjects];
    [self.dataSource removeAllObjects];
    [self.heightArray removeAllObjects];
    [self.answerHeightDict removeAllObjects];
    
    NSDictionary * params = notification.userInfo[@"mess"];
    NSDictionary * data   = params[@"data"];
    
    //记住自己的id
    self.me  = notification.userInfo[@"xid"];
    self.xid = [NSString stringWithFormat:@"%d",[self.me[@"xid"] intValue]];
    
    //将每个问题的id加入未排序的rankArray
    for (NSString * key in data) {
        [self.rankArray addObject:key];
//        [self.dataDict setObject:@(self.rankArray.count - 1) forKey:key];
    }
    
    //将数组里面的元素排序
    NSArray * rankedArray = [self.rankArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSNumber * number1 = @([obj1 integerValue]);
        NSNumber * number2 = @([obj2 integerValue]);
        return [number1 compare:number2];
    }];
    
    //记住每个问题的id
    for (int i = 0; i < rankedArray.count; i ++) {
        [self.dataDict setObject:@(i) forKey:rankedArray[i]];
    }
    
    for (int i = 0; i < rankedArray.count; i ++) {
        [self.dataSource addObject:data[rankedArray[i]]];
        
        NSDictionary * params = self.dataSource[i];
//        NSString * content    = params[@"content"];

//        CGRect rect           = [content boundingRectWithSize:CGSizeMake(self.view.frame.size.width - 20, 9999) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];
//        CGFloat height        = rect.size.height + 40;
//        [self.heightArray addObject:@(height)];
        
        //如果有回复
        if (params[@"answer"]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"askMessageCome" object:nil];
            
            NSArray * answerArray = params[@"answer"];
            NSMutableArray * arr = [NSMutableArray new];
            for (int i = 0; i < answerArray.count; i ++) {
                
                NSDictionary * dict = answerArray[i];

                NSString * content  = dict[@"content"];

                CGRect rect         = [content boundingRectWithSize:CGSizeMake(self.view.frame.size.width - 20, 9999) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];
                CGFloat height      = rect.size.height + 30;
                [arr addObject:@(height)];
            }
            //记住高度
//            [self.answerHeightDict setObject:arr forKey:@(self.dataSource.count - 1)];
        }
        else
        {
            NSString * xid = [NSString stringWithFormat:@"%@",params[@"xid"]];
            if (![self.xid isEqualToString:xid] && ![params[@"role"] isEqualToString:TalkfunMemberRoleSpadmin] && ![params[@"role"] isEqualToString:TalkfunMemberRoleAdmin]) {
//                [self.heightArray replaceObjectAtIndex:self.heightArray.count - 1 withObject:@(0.0)];
            }
            else
                [[NSNotificationCenter defaultCenter] postNotificationName:@"askMessageCome" object:nil];
        }
    }
    if (self.dataSource.count > 0) {
        [self.tableView reloadData];
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.dataSource.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        
    }
    
}

//==================监听reply回来的数据处理======================
- (void)reply:(NSNotification *)notification
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"askMessageCome" object:nil];
    
    NSDictionary * params = notification.userInfo;
    NSString * str        = [params[@"mess"][@"replyId"] stringValue];
    if (!self.dataDict[str]) {
        [self.dataSource addObject:params[@"mess"][@"question"]];
        
        [self.dataDict setObject:@(self.dataSource.count - 1) forKey:[NSString stringWithFormat:@"%@",params[@"mess"][@"question"][@"qid"]]];
    }
    NSInteger num         = [str integerValue];
    NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
    int j = 0;
    for (NSDictionary * ques in self.dataSource) {
        if ([ques[@"qid"] integerValue] == num) {
            [dict setDictionary:ques];
            break;
        }
        j += 1;
    }
    
    if (![dict objectForKey:@"answer"]) {
        [dict setObject:@[] forKey:@"answer"];
    }
    NSMutableArray * answerArray = [[NSMutableArray alloc] initWithArray:dict[@"answer"]];
    [answerArray addObject:params[@"mess"]];
    [dict setObject:answerArray forKey:@"answer"];
    [self.dataSource replaceObjectAtIndex:j withObject:dict];
    
    //记住row的高度
//    NSString * content = self.dataSource[num][@"content"];
    
//    CGRect rect = [content boundingRectWithSize:CGSizeMake(self.view.frame.size.width - 20, 9999) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];
//    CGFloat height = rect.size.height + 30;
    
//    [self.heightArray replaceObjectAtIndex:num withObject:@(height)];
    
    
    NSMutableArray * arr = [NSMutableArray new];
    for (int i = 0; i < answerArray.count; i ++) {
        
        NSDictionary * dict = answerArray[i];
        NSString * content  = dict[@"content"];

        CGRect rect         = [content boundingRectWithSize:CGSizeMake(self.view.frame.size.width - 20, 9999) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];
        CGFloat height      = rect.size.height + 30;
        [arr addObject:@(height)];
        
    }
//    [self.answerHeightDict setObject:arr forKey:@(num)];
    
    [self.tableView reloadData];
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.dataSource.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}
//==================监听ask和chat回来的数据处理======================
- (void)ask:(NSNotification *)notification
{
    NSDictionary * params = notification.userInfo;
    [self.dataSource addObject:params[@"mess"]];
    
    [self.dataDict setObject:@(self.dataSource.count - 1) forKey:[NSString stringWithFormat:@"%@",params[@"mess"][@"qid"]]];
    
    //记住row的高度
//    NSString * content = params[@"mess"][@"content"];
    
//    CGRect rect    = [content boundingRectWithSize:CGSizeMake(self.view.frame.size.width - 20, 9999) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];
//    CGFloat height = rect.size.height + 30;

//    [self.heightArray addObject:@(height)];
    
    //如果问题有回复（老师回复）
    if (params[@"mess"][@"answer"]) {
        NSArray * answerArray = params[@"mess"][@"answer"];
        NSMutableArray * arr = [NSMutableArray new];
        for (int i = 0; i < answerArray.count; i ++) {
            
            NSDictionary * dict = answerArray[i];

            NSString * content  = dict[@"content"];

            CGRect rect         = [content boundingRectWithSize:CGSizeMake(self.view.frame.size.width - 20, 9999) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];
            CGFloat height      = rect.size.height + 30;
            [arr addObject:@(height)];
            
        }
//        [self.answerHeightDict setObject:arr forKey:@(self.dataSource.count - 1)];
    }
    else
    {
        
        
        NSString * xid =[self getNumber:params[@"mess"][@"xid"]];
        
        if (![self.xid isEqualToString:xid] && (![xid isEqualToString:TalkfunMemberRoleAdmin] && ![xid isEqualToString:TalkfunMemberRoleSpadmin])) {
            
//            [self.heightArray replaceObjectAtIndex:self.heightArray.count - 1 withObject:@(0.0)];
            
        }
        else
            [[NSNotificationCenter defaultCenter] postNotificationName:@"askMessageCome" object:nil];
        
    }
    
    [self.tableView reloadData];
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.dataSource.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}
- (NSString*)getNumber:(NSObject*)obj
{
    NSString *UsersXid = @"0";
    
    if([obj isKindOfClass:[NSNumber class] ]){
        
        NSNumber  *num     = (NSNumber*) obj;
        NSNumberFormatter *tempNum = [[NSNumberFormatter alloc] init];
        
        UsersXid = [tempNum stringFromNumber:num];
    }else if([obj isKindOfClass:[NSString class] ]){
        
        NSString  *str    = (NSString*)obj;
        UsersXid = str;
    }
    
    return UsersXid;
}

- (void)recalculateCellHeight;
{

    [self.tableView reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TalkfunNewQuestionCell * cell = [tableView dequeueReusableCellWithIdentifier:@"liveQuestionCell"];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"TalkfunNewQuestionCell" owner:nil options:nil][0];
    }

    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.number = indexPath.row + 1;
    [cell configCell:self.dataSource[indexPath.row] isPlayback:NO];
    
   return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    QuestionModel * model = [QuestionModel mj_objectWithKeyValues:self.dataSource[indexPath.row]];
    NSArray * array = model.answer;
    CGFloat sumHeight = 0;
    for (int i = 0; i < array.count; i ++) {
        NSDictionary * dict = array[i];
        NSDictionary * info = [TalkfunUtils assembleAttributeString:dict[@"content"] boundingSize:CGSizeMake(CGRectGetWidth(self.view.frame)-48, MAXFLOAT) fontSize:13 shadow:NO];
        NSString * rectStr = info[TextRect];
        CGRect rect = CGRectFromString(rectStr);
        CGFloat height = rect.size.height+15+16;
        sumHeight += height;
    }
    NSDictionary * info = [TalkfunUtils assembleAttributeString:model.content boundingSize:CGSizeMake(CGRectGetWidth(self.view.frame)-48, MAXFLOAT) fontSize:13 shadow:NO];
    NSString * rectStr = info[TextRect];
    CGRect rect = CGRectFromString(rectStr);
    CGFloat height = rect.size.height+15+16;
    sumHeight += height;
    return sumHeight;

}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
