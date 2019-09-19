//
//  ChapterViewController.m
//  Talkfun_demo
//
//  Created by talk－fun on 16/1/25.
//  Copyright © 2016年 talk-fun. All rights reserved.
//

#import "ChapterViewController.h"
#import "ChapterTableViewCell.h"
#import "MJExtension.h"
#import "ChapterModel.h"
@interface ChapterViewController ()

@end

@implementation ChapterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
//    //清除缓存
//    if ([[NSFileManager defaultManager] fileExistsAtPath:FilePath]) {
//        [[NSFileManager defaultManager] removeItemAtPath:FilePath error:nil];
//    }
    
    self.tableView.bounces = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chapter:) name:@"chapterList" object:nil];
    
}

- (void)chapter:(NSNotification *)notification
{
    [self.dataSource removeAllObjects];
//    [self.displayCellArray removeAllObjects];
    [self.dataDict removeAllObjects];
    [self.heightArray removeAllObjects];
    [self.answerHeightDict removeAllObjects];
    self.sum = 0;
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    if (self.dataSource.count != 0) {
        return;
    }
    NSDictionary * params = notification.userInfo;
    NSArray * array = params[@"mess"];
    
    self.dataSource  = [ChapterModel mj_objectArrayWithKeyValuesArray:array];
    //[self.dataSource addObjectsFromArray:array];
    for (int i = 0; i < self.dataSource.count; i ++) {
        [self.selectedArray addObject:@(0)];
    }
    if (self.dataSource.count == 0) {
        self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    }
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
    //MARK:章节的cell
    
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    ChapterTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"playbackCell"];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"ChapterTableViewCell" owner:nil options:nil][0];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
   // NSDictionary * params = self.dataSource[indexPath.row - 1];
    
    ChapterModel *Model = self.dataSource[indexPath.row - 1];
    cell.number         = indexPath.row;
    cell.selectedArray  = self.selectedArray;
    cell.rotated        = self.rotated;
    cell.Model          = Model;

    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 10;
    }else
        return 75;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return;
    }
    [self.selectedArray replaceObjectAtIndex:indexPath.row withObject:@(1)];
   ChapterModel *Model = self.dataSource[indexPath.row - 1];
   CGFloat duration    = [Model.starttime floatValue];
    self.setDurationBlock(duration);
    [self refreshUIWithIndex:(int)indexPath.row];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [self.selectedArray replaceObjectAtIndex:indexPath.row withObject:@(0)];
    [self refreshUIWithIndex:(int)indexPath.row];
    
}

- (void)refreshUIWithDuration:(CGFloat)duration
{
    int i = 0;
    int j = 0;
    for (i = 0; i < self.dataSource.count; i += 50) {
       // NSDictionary * dict = self.dataSource[i];
        j = 0;
        
        ChapterModel *Model = self.dataSource[i];
        
        if ([Model.starttime floatValue] - 1.0 > duration) {
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
    //前50 * （i - 1）个数据里面没有一个的starttime比duration大
    else if (j == 1)
    {
        for (i = i - 50; i < self.dataSource.count; i ++) {
           // NSDictionary * dict = self.dataSource[i];
            ChapterModel *Model = self.dataSource[i];
            if ([Model.starttime floatValue] - 1.0 > duration) {
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
           // NSDictionary * dict = self.dataSource[k];
            ChapterModel *Model = self.dataSource[k];
            if ([Model.starttime floatValue] - 1.0 > duration) {
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
