//
//  ChapterViewController.m
//  Talkfun_demo
//
//  Created by talk－fun on 16/1/25.
//  Copyright © 2016年 talk-fun. All rights reserved.
//

#import "AlbumViewController.h"
#import "MJExtension.h"
#import "AlbumCellTableViewCell.h"
#import "AlbumModel.h"
@interface AlbumViewController ()

@end

@implementation AlbumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.bounces = NO;
    
    [self.dataSource removeAllObjects];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chapter:) name:@"GetPlayAlbum" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(vodStop) name:@"VodStop" object:nil];
}

- (void)removeAllData
{
    
}

- (void)chapter:(NSNotification *)notification
{
    NSDictionary * params = notification.userInfo;
    NSArray * array = params[@"mess"][@"album"];
    NSString * liveid = params[@"mess"][@"liveid"];
    
    //如果不是同一个回放里面的专辑
    if (![liveid isEqualToString:self.playbackID]) {
        int i = 0;
        for (; i < array.count; i ++) {
            NSDictionary * dict = array[i];
            if ([dict[@"id"] isEqualToString:self.playbackID]) {
                break;
            }
        }
        if (i == array.count) {
            self.playbackID = liveid;
            [self.dataSource removeAllObjects];
//            [self.displayCellArray removeAllObjects];
        }
    }
    
  //  [self.dataSource removeAllObjects];
    [self.dataDict removeAllObjects];
    [self.heightArray removeAllObjects];
    [self.answerHeightDict removeAllObjects];
    self.sum = 0;
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    if (self.dataSource.count != 0) {
        return;
    }
    
    
    self.dataSource  = [AlbumModel mj_objectArrayWithKeyValuesArray:array];
//    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    
    [self.selectedArray removeAllObjects];
    for (int i = 0; i < self.dataSource.count; i ++) {
        [self.selectedArray addObject:@(0)];
    }
    
    [self.selectedArray replaceObjectAtIndex:0 withObject:@(1)];
    
    [self.tableView reloadData];
 
//    [self  tableView:self.tableView  didSelectRowAtIndexPath:indexPath];
}


#pragma mark - <数据源>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.dataSource.count ;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    AlbumCellTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"album"];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"AlbumCellTableViewCell" owner:nil options:nil][0];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
   
    if (self.dataSource) {
        AlbumModel *statusModel = self.dataSource[indexPath.row];
        cell.number = indexPath.row;
        
        cell.selectedArray = self.selectedArray;
        cell.rotated = self.rotated;
        cell.Model = statusModel;
        
    }
  
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    for (int j = 0; j < self.selectedArray.count; j ++) {
        [self.selectedArray replaceObjectAtIndex:j withObject:@(0)];
    }
    [self.selectedArray replaceObjectAtIndex:indexPath.row withObject:@(1)];

    [self refreshUIWithIndex:(int)indexPath.row];

    AlbumModel *statusModel = self.dataSource[indexPath.row];

    if (self.setAlbumBlock) {
        self.setAlbumBlock(statusModel.access_token);
    }
}

- (void)vodStop{
    NSInteger index = [self.selectedArray indexOfObject:@(1)];
    if (![self.selectedArray containsObject:@(1)]) {
        index = 0;
    }
    [self.selectedArray replaceObjectAtIndex:index withObject:@(0)];
    if (self.selectedArray.count-1>=index+1) {
        [self refreshUIWithIndex:(int)index+1];
        [self.selectedArray replaceObjectAtIndex:index+1 withObject:@(1)];
        AlbumModel *statusModel = self.dataSource[index+1];
        if (self.setAlbumBlock) {
            self.setAlbumBlock(statusModel.access_token);
        }
    }
}

- (void)refreshUIWithIndex:(int)index
{
    
    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    
    for (int j = 0; j < self.selectedArray.count; j ++) {
        [self.selectedArray replaceObjectAtIndex:j withObject:@(0)];
    }
    [self.selectedArray replaceObjectAtIndex:index withObject:@(1)];
    [self.tableView reloadData];
    if (self.dataSource.count == 0) {
        return;
    }
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  
        return 70;
  
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
