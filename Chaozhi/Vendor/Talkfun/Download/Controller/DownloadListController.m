//
//  DownloadListController.m
//  TalkfunSDKDemo
//
//  Created by 孙兆能 on 16/7/11.
//  Copyright © 2016年 talk-fun. All rights reserved.
//

#import "DownloadListController.h"
#import "DownloadListTableViewCell.h"
#import "DownloadListModel.h"
//#import "TalkfunSDK.h"
#import "AppDelegate.h"
#import "TalkfunPlaybackViewController.h"
#import "NSString+Hashing.h"
#import "MJExtension.h"
#import <SDWebImage/SDWebImageManager.h>
//#import "TalkfunSmallClassPlayBackController.h"

#define FilePath [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/ImageCaches"]

@interface DownloadListController ()<UIAlertViewDelegate>

//记住选中的cell的indexPath
@property (nonatomic,strong) NSMutableArray * selectedArray;
//@property (nonatomic,strong) TalkfunSDK * talkfunSDK;
//下载管理对象
@property (nonatomic,strong) TalkfunDownloadManager * downloadManager;
@property (nonatomic,strong) UIView * footerView;
@property (nonatomic,strong) SDWebImageManager * sd_manager;
@property (nonatomic,strong)UIAlertView *alertView;

@end

@implementation DownloadListController

- (void)sdkError:(NSNotification *)notification{
    NSDictionary * userInfo = notification.userInfo;
    if ([userInfo[@"code"] intValue]==TalkfunErrorDownloadError) {
        NSLog(@"缓存点播错误原因%@",userInfo[@"message"]);
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    WeakSelf
    
    self.downloadManager.diskLowReminderValueCallback = ^{
        if (weakSelf.alertView==nil) {
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"磁盘可用空间不足,无法下载!" delegate:weakSelf cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
                weakSelf.alertView.alertViewStyle = UIAlertViewStyleDefault;
                [weakSelf.alertView show];
            });
        }
        NSLog(@"磁盘空间不足够");
    };
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sdkError:) name:TalkfunErrorNotification object:nil];
    
    NSArray * playbackList = self.downloadManager.getDownloadList;
    
    [self.dataSource addObjectsFromArray:[DownloadListModel mj_objectArrayWithKeyValuesArray:playbackList]];
    
    self.tableView.backgroundColor = PageColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.allowsSelectionDuringEditing = YES;
    self.tableView.allowsSelection = NO;
    self.tableView.bounces = NO;
    self.tableView.rowHeight = 97;
    
    [self.downloadManager on:TALKFUN_EVENT_DOWNLOAD_STATUS callback:^(id obj) {
        
        TalkfunDownloadStatus downloadStatus = [obj[@"downloadStatus"] intValue];
        NSString * playbackID = obj[@"playbackID"];
        
        DownloadListModel * changedModel;
        int i = 0;
        
        int   Tag  = 0;
        for (; i < weakSelf.dataSource.count; i ++) {
            DownloadListModel * model = weakSelf.dataSource[i];
            if ([model.playbackID isEqualToString:playbackID]) {
                changedModel = model;
                Tag = [model.playbackID intValue];
                break;
            }
        }
        
        if (changedModel) {
            
            @synchronized (weakSelf) {
                if (downloadStatus == TalkfunDownloadStatusStart) {
                    //NSLog(@"status161:1");
                    changedModel.downloadStatus = TalkfunDownloadStatusStart;
                    NSString * duration = obj[@"duration"];
                    changedModel.duration = duration;
                    CGFloat totalMB = [obj[@"totalSize"] floatValue] / 1048576;
                    CGFloat writtenMB = [obj[@"downloadedSize"] floatValue] / 1048576;
                    changedModel.totalSize = [NSString stringWithFormat:@"%0.2f",totalMB];
                    changedModel.downloadedSize = [NSString stringWithFormat:@"%0.2f",writtenMB];
                    if (obj[@"thumb"]) {
                        changedModel.thumb = obj[@"thumb"];
                    }
                    dispatch_async(dispatch_queue_create("downloadImage", DISPATCH_QUEUE_CONCURRENT), ^{
                        UIImage * thumbImage = [weakSelf getDownloadImageWithThumb:changedModel.thumb];
                        if (thumbImage) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                UIImageView * downloadImageView = (UIImageView *)[weakSelf.view viewWithTag:80000+i];
                                downloadImageView.image = thumbImage;
                            });
                        }
                    });
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        UILabel * downloadBtnLabel = (UILabel *)[weakSelf.view viewWithTag:60000+i];
                        downloadBtnLabel.textColor = nil;
                        UIProgressView * progressView = (UIProgressView *)[weakSelf.view viewWithTag:20000 + i];
                        progressView.tintColor = nil;
                        
                        //NSLog(@"status161:2");
                        progressView.progress =  writtenMB / totalMB;
                        progressView.tintColor = nil;
                        
                        UILabel * playLabel = (UILabel *)[weakSelf.view viewWithTag:70000+i];
                        playLabel.hidden = YES;
                        UIImageView * downloadBtnImageView = (UIImageView *)[weakSelf.view viewWithTag:50000+i];
                        downloadBtnImageView.image = [UIImage imageNamed:@"暂停_默认"];
                        //                        UILabel * downloadBtnLabel = (UILabel *)[weakSelf.view viewWithTag:60000+i];
                        downloadBtnLabel.text = @"暂停";
                        downloadBtnLabel.textColor = nil;
                        downloadBtnImageView.hidden = NO;
                        downloadBtnLabel.hidden = NO;
                        //NSLog(@"status161:3");
                        UILabel * totalDuration = (UILabel *)[weakSelf.view viewWithTag:90000+i];
                        totalDuration.text = [weakSelf getDurationStringWith:changedModel.duration];
                        
                        UIButton * btn = (UIButton *)[weakSelf.view viewWithTag:Tag];
                        [btn setTitle:@"暂停" forState:UIControlStateNormal];
                    });
                    
                    [weakSelf.dataSource replaceObjectAtIndex:i withObject:changedModel];
                }
                else if (downloadStatus == TalkfunDownloadStatusPause)
                {
                    changedModel.downloadStatus = TalkfunDownloadStatusPause;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        UIImageView * downloadBtnImageView = (UIImageView *)[weakSelf.view viewWithTag:50000+i];
                        downloadBtnImageView.image = [UIImage imageNamed:@"继续_默认"];
                        UILabel * downloadBtnLabel = (UILabel *)[weakSelf.view viewWithTag:60000+i];
                        downloadBtnLabel.text = @"继续下载";
                        
                        UIButton * btn = (UIButton *)[weakSelf.view viewWithTag:Tag];
                        [btn setTitle:@"继续下载" forState:UIControlStateNormal];
                        
                    });
                    [weakSelf.dataSource replaceObjectAtIndex:i withObject:changedModel];
                }
                else if (downloadStatus == TalkfunDownloadStatusPrepare)
                {
                    changedModel.downloadStatus = TalkfunDownloadStatusPrepare;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        UIImageView * downloadBtnImageView = (UIImageView *)[weakSelf.view viewWithTag:50000+i];
                        downloadBtnImageView.image = [UIImage imageNamed:@"等待队列_默认"];
                        UILabel * downloadBtnLabel = (UILabel *)[weakSelf.view viewWithTag:60000+i];
                        downloadBtnLabel.text = @"等待队列";
                        
                        UIButton * btn = (UIButton *)[weakSelf.view viewWithTag:Tag];
                        [btn setTitle:@"等待中" forState:UIControlStateNormal];
                        
                    });
                    [weakSelf.dataSource replaceObjectAtIndex:i withObject:changedModel];
                }
                else if (downloadStatus == TalkfunDownloadStatusError)
                {
                    //NSLog(@"status161:4");
                    changedModel.downloadStatus = TalkfunDownloadStatusError;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //NSLog(@"status161:5");
                        UIImageView * downloadBtnImageView = (UIImageView *)[weakSelf.view viewWithTag:50000+i];
                        downloadBtnImageView.image = [UIImage imageNamed:@"重新_默认"];
                        UILabel * downloadBtnLabel = (UILabel *)[weakSelf.view viewWithTag:60000+i];
                        downloadBtnLabel.text = @"下载错误";
                        downloadBtnLabel.textColor = [UIColor redColor];
                        UIProgressView * progressView = (UIProgressView *)[weakSelf.view viewWithTag:20000 + i];
                        progressView.tintColor = [UIColor redColor];
                        
                        UIButton * btn = (UIButton *)[weakSelf.view viewWithTag:Tag];
                        [btn setTitle:@"下载错误" forState:UIControlStateNormal];
                        
                    });
                    //NSLog(@"status161:6");
                    [weakSelf.dataSource replaceObjectAtIndex:i withObject:changedModel];
                }
                else if (downloadStatus == TalkfunDownloadStatusFinish) {
                    
                    changedModel.downloadStatus = TalkfunDownloadStatusFinish;
                    CGFloat totalMB = [obj[@"totalSize"] floatValue] / 1048576;
                    changedModel.totalSize = [NSString stringWithFormat:@"%0.2f",totalMB];
                    CGFloat writtenMB = [obj[@"downloadedSize"] floatValue] / 1048576;
                    changedModel.downloadedSize = [NSString stringWithFormat:@"%0.2f",writtenMB];
                    changedModel.duration = obj[@"duration"];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        UIProgressView * progressView = (UIProgressView *)[weakSelf.view viewWithTag:20000 + i];
                        progressView.progress =  writtenMB / totalMB;
                        progressView.tintColor = nil;
                        UILabel * fileProgressLabel = (UILabel *)[weakSelf.view viewWithTag:30000 + i];
                        UILabel * progressLabel = (UILabel *)[weakSelf.view viewWithTag:40000 + i];
                        fileProgressLabel.text = [NSString stringWithFormat:@"%0.1f%%",[changedModel.downloadedSize floatValue] / [changedModel.totalSize floatValue] * 100];
                        progressLabel.text = [NSString stringWithFormat:@"%@/%@MB",changedModel.downloadedSize,changedModel.totalSize];
                        
                        UILabel * playLabel = (UILabel *)[weakSelf.view viewWithTag:70000+i];
                        playLabel.hidden = NO;
                        UIImageView * downloadBtnImageView = (UIImageView *)[weakSelf.view viewWithTag:50000+i];
                        UILabel * downloadBtnLabel = (UILabel *)[weakSelf.view viewWithTag:60000+i];
                        downloadBtnImageView.hidden = YES;
                        downloadBtnLabel.hidden = YES;
                        playLabel.text = @"播放";
                        
                        UILabel * totalDuration = (UILabel *)[weakSelf.view viewWithTag:90000+i];
                        totalDuration.text = [weakSelf getDurationStringWith:changedModel.duration];
                        
                        UIButton * btn = (UIButton *)[weakSelf.view viewWithTag:Tag];
                        [btn setTitle:@"播放" forState:UIControlStateNormal];
                        
                    });
                    [weakSelf.dataSource replaceObjectAtIndex:i withObject:changedModel];
                }
            }
        }
    }];
    
    [self.downloadManager on:TALKFUN_EVENT_DOWNLOAD_PROGRESS callback:^(id obj) {
        
        //        [weakSelf updateProgressWith:obj];
        NSString * playbackID = obj[@"playbackID"];
        //    NSLog(@"self.dataSource:%@",weakSelf.dataSource);
        for (int i = 0; i < weakSelf.dataSource.count; i ++) {
            DownloadListModel * model = weakSelf.dataSource[i];
            
            if ([model.playbackID isEqualToString:playbackID]) {
                
                CGFloat totalMB = [obj[@"totalSize"] floatValue] / 1048576;
                CGFloat writtenMB = [obj[@"downloadedSize"] floatValue] / 1048576;
                
                model.totalSize = [NSString stringWithFormat:@"%0.2f",totalMB];
                model.downloadedSize = [NSString stringWithFormat:@"%0.2f",writtenMB];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIProgressView * progressView = (UIProgressView *)[weakSelf.view viewWithTag:20000 + i];
                    UILabel * progressLabel = (UILabel *)[weakSelf.view viewWithTag:40000 + i];
                    UILabel * fileProgressLabel = (UILabel *)[weakSelf.view viewWithTag:30000 + i];
                    
                    progressView.progress =  writtenMB / totalMB;
                    fileProgressLabel.text = [NSString stringWithFormat:@"%0.1f%%",[model.downloadedSize floatValue] / [model.totalSize floatValue] * 100];
                    progressLabel.text = [NSString stringWithFormat:@"%@/%@MB",model.downloadedSize,model.totalSize];
                    
                    if (writtenMB == totalMB) {
                        [weakSelf sendLocalNotification:model.title];
                    }
                });
            }
        }
    }];
}

- (void)updateModel:(DownloadListModel *)model dict:(NSDictionary *)dic
{
    NSString * access_token = dic[@"access_token"];
    TalkfunDownloadStatus downloadStatus = [dic[@"downloadStatus"] intValue];
    NSTimeInterval startDownloadTime = [dic[@"startDownloadTime"] floatValue];
    NSTimeInterval endDownloadTime = [dic[@"endDownloadTime"] floatValue];
    NSString * title = dic[@"title"];
    NSString * duration = dic[@"duration"];
    CGFloat totalSize = [dic[@"totalSize"] floatValue];
    CGFloat totalMB = totalSize / 1048576;
    CGFloat downloadedSize = [dic[@"downloadedSize"] floatValue];
    CGFloat writtenBytes = downloadedSize / 1048576;
    NSString * playbackID = dic[@"playbackID"];
    model.totalSize = [NSString stringWithFormat:@"%0.2f",totalMB];
    model.downloadedSize = [NSString stringWithFormat:@"%0.2f",writtenBytes];
    
    if ([title isEqualToString:@""]) {
        title = playbackID;
    }
    NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:startDownloadTime];
    NSDate *endDate = [NSDate dateWithTimeIntervalSince1970:endDownloadTime];
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"YYYY-MM-dd"];
    NSString * downloadStartTime = [dateFormatter stringFromDate: startDate];
    NSString * downloadEndTime = [dateFormatter stringFromDate:endDate];
    NSString * thumb = dic[@"thumb"];
    
    model.thumb = thumb;
    model.fileName = title;
    model.downloadStartTime = downloadStartTime;
    model.downloadEndTime = downloadEndTime;
    model.access_token = access_token;
    model.downloadStatus = downloadStatus;
    model.playbackID = playbackID;
    model.duration = duration;
}

- (void)reloadData
{
    __weak typeof(self) weakSelf = self;
    [weakSelf.tableView reloadData];
    if (weakSelf.tableView.isEditing) {
        weakSelf.tableView.contentSize = CGSizeMake(weakSelf.tableView.contentSize.width, weakSelf.tableView.contentSize.height + CGRectGetHeight(weakSelf.footerView.frame));
        [weakSelf resetBtn];
    }
}

- (void)resetBtn
{
    [self.selectedArray removeAllObjects];
    UIButton * selectAllBtn = (UIButton *)[self.footerView viewWithTag:20];
    [selectAllBtn setTitle:@"全部选中" forState:UIControlStateNormal];
    UIButton * deleteBtn = (UIButton *)[self.footerView viewWithTag:21];
    [deleteBtn setTitle:@"删除(0)" forState:UIControlStateNormal];
}

//给个thumb地址获取图片
- (UIImage *)getDownloadImageWithThumb:(NSString *)thumb
{
    UIImage * thumbImage = nil;;
    
    NSData * imageData = [[NSData alloc] initWithContentsOfFile:[FilePath stringByAppendingPathComponent:[thumb MD5Hash]]];
    if (imageData == nil) {
        
        imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:thumb]];
    }
    
    if (imageData) {
        NSString * errorStr = [[NSString alloc] initWithData:imageData encoding:NSUTF8StringEncoding];
        NSArray * errArr = [errorStr componentsSeparatedByString:@"404 Not Found"];
        if (!errArr || errArr.count == 1) {
            thumbImage = [[UIImage alloc] initWithData:imageData];
        }
    }
    
    return thumbImage;
}

//获取时间的字符串
- (NSString *)getDurationStringWith:(NSString *)string
{
    CGFloat totalDuration = [string floatValue];
    NSInteger hour = totalDuration / 60 / 60;
    NSInteger minute = (totalDuration - hour * 60 * 60) / 60;
    NSInteger second = (totalDuration - hour * 60 * 60 - minute * 60);
    return [NSString stringWithFormat:@"回放时长: %02d:%02d:%02d",(int)hour,(int)minute,(int)second];
}

#pragma mark - 按钮点击事件
- (void)controlBtnClicked:(UIButton *)btn
{
    int tag  = 0;
    for (int i =  0; i<self.dataSource.count;  i++) {
        DownloadListModel * model = self.dataSource[i];
        if ([model.playbackID intValue] ==btn.tag) {
            tag = i ;
            break;
        }
    }
    
    if (tag> self.dataSource.count) {
        return;
    }
    DownloadListModel * model = self.dataSource[tag];
    if ([btn.titleLabel.text isEqualToString:@"下载"] || [btn.titleLabel.text isEqualToString:@"继续下载"] || [btn.titleLabel.text isEqualToString:@"重新下载"] || [btn.titleLabel.text isEqualToString:@"下载错误"]) {
        [self.downloadManager startDownload:model.playbackID];
    }
    else if ([btn.titleLabel.text isEqualToString:@"播放"]) {
        //1：普通大班回放，2：纯视频类型回放
        NSString *videoType =  [self.downloadManager getVideoType:model.playbackID];
        if ([videoType isEqualToString:@"1"]) {
            //TODO:原生模式的点播
            TalkfunPlaybackViewController * playbackVC = [TalkfunPlaybackViewController new];
            playbackVC.playbackID = model.playbackID;
            playbackVC.res = @{@"data":@{@"access_token":model.access_token},TalkfunPlaybackID:model.playbackID};
            playbackVC.downloadCompleted = YES;//下载完成
            [self presentViewController:playbackVC animated:NO completion:nil];
        }else if ([videoType isEqualToString:@"2"]) {
            
            //            //TODO:原生模式的点播
            //            TalkfunSmallClassPlayBackController * playbackVC = [TalkfunSmallClassPlayBackController new];
            //            playbackVC.playbackID = model.playbackID;
            //            playbackVC.res = @{@"data":@{@"access_token":model.access_token},TalkfunPlaybackID:model.playbackID};
            //            playbackVC.downloadCompleted = YES;//下载完成
            //            [self presentViewController:playbackVC animated:NO completion:nil];
        }
        return;
    }
    else if ([btn.titleLabel.text isEqualToString:@"暂停"]){
        [self.downloadManager pauseDownload:model.playbackID];
    }
    else if ([btn.titleLabel.text isEqualToString:@"等待中"]){
        [self.downloadManager pauseDownload:model.playbackID];
    }
    
    [self.tableView reloadData];
}

//操作按钮的点击事件
- (void)buttonClicked:(UIButton *)btn
{
    if (btn.tag == 10) {
        self.downloadManager = nil;
        
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if (btn.tag == 11)
    {
        self.tableView.allowsMultipleSelectionDuringEditing = YES;
        [self.tableView setEditing:!self.tableView.editing animated:YES];
        if (self.tableView.isEditing) {
            if (self.tableView.contentSize.height > self.view.frame.size.height - CGRectGetHeight(self.footerView.frame)) {
                self.tableView.contentSize = CGSizeMake(CGRectGetWidth(self.tableView.frame), self.tableView.contentSize.height + CGRectGetHeight(self.footerView.frame));
            }
            [btn setTitle:@"取消" forState:UIControlStateNormal];
            [self.view addSubview:self.footerView];
        }
        else
        {
            if (self.tableView.contentSize.height > self.view.frame.size.height) {
                self.tableView.contentSize = CGSizeMake(CGRectGetWidth(self.tableView.frame), self.tableView.contentSize.height - CGRectGetHeight(self.footerView.frame));
            }
            [btn setTitle:@"编辑" forState:UIControlStateNormal];
            [self resetBtn];
            [self.footerView removeFromSuperview];
        }
    }
    else if (btn.tag == 20)
    {
        [self.selectedArray removeAllObjects];
        btn.selected = !btn.selected;
        if (btn.selected) {
            [btn setTitle:@"取消全选" forState:UIControlStateNormal];
            for (int i = 0; i < self.dataSource.count; i ++) {
                NSIndexPath * indexPath = [NSIndexPath indexPathForRow:i inSection:0];
                [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionTop];
                [self.selectedArray addObject:indexPath];
            }
            UIButton * deleteBtn = (UIButton *)[self.footerView viewWithTag:21];
            [deleteBtn setTitle:[NSString stringWithFormat:@"删除(%d)",(int)self.selectedArray.count] forState:UIControlStateNormal];
        }
        else
        {
            for (int i = 0; i < self.dataSource.count; i ++) {
                NSIndexPath * indexPath = [NSIndexPath indexPathForRow:i inSection:0];
                [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
            }
            [self resetBtn];
        }
    }
    else if (btn.tag == 21)
    {
        if(self.dataSource.count==0){
            return;
        }
        
        NSMutableArray *modelArray = [NSMutableArray array];
        
        for (NSIndexPath * indexPath  in self.selectedArray) {
            
            DownloadListModel * model = self.dataSource[indexPath.row];
            
            [modelArray addObject:model];
            
            NSMutableString *mutableCopyString = [model.playbackID mutableCopy];
            
            [self.downloadManager deleteDownload:mutableCopyString success:nil];
        }
        
        for (DownloadListModel * model in modelArray) {
            [self.dataSource removeObject:model];
        }
        
        [self.tableView reloadData];
        
        //        [self.tableView deleteRowsAtIndexPaths:self.selectedArray withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

#pragma mark - tableView delegate
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DownloadListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"downloadList"];
    
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"DownloadListTableViewCell" owner:nil options:nil][0];
    }
    
    //    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.downloadImageView.image = [UIImage imageNamed:@"默认图片"];
    cell.downloadImageView.tag = 80000+indexPath.row;
    
    DownloadListModel * model = self.dataSource[indexPath.row];
    WeakSelf
    [self.sd_manager  loadImageWithURL:[NSURL URLWithString:model.thumb] options:32 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        
    } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (image) {
                cell.downloadImageView.image = image;
            }
        });
    }];
    
    dispatch_async(dispatch_queue_create("downloadImage", DISPATCH_QUEUE_CONCURRENT), ^{
        UIImage * thumbImage = [weakSelf getDownloadImageWithThumb:model.thumb];
        if (thumbImage) {
            dispatch_async(dispatch_get_main_queue(), ^{
                cell.downloadImageView.image = thumbImage;
            });
        }
    });
    
    cell.fileName.text = model.title;
    if (model.totalSize) {
        if (model.downloadedSize) {
            cell.progressLabel.text = [NSString stringWithFormat:@"%0.2lf/%0.2lfMB",[model.downloadedSize floatValue]/1024/1024,[model.totalSize floatValue]/1024/1024];
        }
        else
        {
            cell.progressLabel.text = [NSString stringWithFormat:@"0/%0.2lfMB",[model.totalSize floatValue]/1024/1024];
        }
    }
    if ([model.downloadedSize floatValue] == 0) {
        cell.progressView.progress = 0;
    }
    else
    {
        cell.progressView.progress = [model.downloadedSize floatValue] / [model.totalSize floatValue];
    }
    
    cell.progressView.tag = 20000 + indexPath.row;
    if ([model.totalSize floatValue] != 0) {
        cell.fileProgressLabel.text = [NSString stringWithFormat:@"%0.1f%%",[model.downloadedSize floatValue] / [model.totalSize floatValue] * 100];
    }
    cell.fileProgressLabel.tag = 30000+indexPath.row;
    cell.progressLabel.tag = 40000+indexPath.row;
    
    //    cell.controlBtn.titleLabel.text = @"开始";
    TalkfunDownloadStatus downloadStatus = model.downloadStatus;
    
    cell.downloadBtnLabel.hidden = NO;
    cell.downloadBtnImageView.hidden = NO;
    cell.downloadBtnLabel.textColor = [UIColor blackColor];
    cell.progressView.tintColor = nil;
    cell.playLabel.hidden = YES;
    cell.downloadBtnImageView.tag = 50000+indexPath.row;
    cell.downloadBtnLabel.tag = 60000+indexPath.row;
    cell.playLabel.tag = 70000+indexPath.row;
    if (downloadStatus == TalkfunDownloadStatusFinish) {
        cell.progressView.progress = 1.0;
        //        if (cell.progressView.progress == 1.0) {
        //            cell.progressView.hidden = YES;
        //        }
        if (model.totalSize) {
            cell.progressLabel.text = [NSString stringWithFormat:@"%0.2lfMB",[model.totalSize floatValue] / 1048576];
        }
        
        [cell.controlBtn setTitle:@"播放" forState:UIControlStateNormal];
        
        cell.downloadBtnLabel.hidden = YES;
        cell.downloadBtnImageView.hidden = YES;
        cell.playLabel.text = @"播放";
        cell.playLabel.hidden = NO;
    }
    else if (downloadStatus == TalkfunDownloadStatusStart)
    {
        [cell.controlBtn setTitle:@"暂停" forState:UIControlStateNormal];
        cell.downloadBtnImageView.image = [UIImage imageNamed:@"暂停_默认"];
        cell.downloadBtnLabel.text = @"暂停";
    }
    else if (downloadStatus == TalkfunDownloadStatusPause)
    {
        //TODO:重新下载
        [cell.controlBtn setTitle:@"继续下载" forState:UIControlStateNormal];
        cell.downloadBtnImageView.image = [UIImage imageNamed:@"继续_默认"];
        cell.downloadBtnLabel.text = @"继续下载";
    }
    else if (downloadStatus == TalkfunDownloadStatusError)
    {
        //下载错误
        [cell.controlBtn setTitle:@"下载错误" forState:UIControlStateNormal];
        cell.downloadBtnImageView.image = [UIImage imageNamed:@"重新_默认"];
        cell.downloadBtnLabel.text = @"下载错误";
        cell.downloadBtnLabel.textColor = [UIColor redColor];
        cell.progressView.tintColor = [UIColor redColor];
    }
    else if (downloadStatus == TalkfunDownloadStatusPrepare)
    {
        [cell.controlBtn setTitle:@"等待中" forState:UIControlStateNormal];
        cell.downloadBtnImageView.image = [UIImage imageNamed:@"等待队列_默认"];
        cell.downloadBtnLabel.text = @"等待队列";
    }
    else if (downloadStatus == TalkfunDownloadStatusUnstart)
    {
        cell.progressView.progress = 0;
        [cell.controlBtn setTitle:@"下载" forState:UIControlStateNormal];
        cell.downloadBtnImageView.image = [UIImage imageNamed:@"继续_默认"];
        cell.downloadBtnLabel.text = @"下载";
    }
    [cell.controlBtn addTarget:self action:@selector(controlBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    cell.controlBtn.tag = [model.playbackID intValue];//开始下载的tag 与回放id 绑定
    
    if (cell.progressView.progress == 1 && downloadStatus == TalkfunDownloadStatusStart) {
        //        cell.downloadBtnImageView.hidden = YES;
        //        cell.downloadBtnLabel.hidden = YES;
        //        cell.playLabel.hidden = NO;
        //        cell.playLabel.text = @"处理中";
    }
    
    cell.totalDuration.text = [self getDurationStringWith:model.duration];
    cell.totalDuration.tag = 90000+indexPath.row;
    
    cell.tag = 10000 + indexPath.row;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return kNavBarH;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), kNavBarH)];
    contentView.backgroundColor = kWhiteColor;
    UIButton * backBtn = ({
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, kStatusBarH, 60, 44);
        [btn setImage:[UIImage imageNamed:@"Back"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = 10;
        btn;
    });
    UILabel * titleLab = ({
        UILabel * titleLab = [[UILabel alloc] init];
        titleLab.frame = CGRectMake(WIDTH/2-100, kStatusBarH, 200, 44);
        titleLab.text = @"我的下载";
        titleLab.textColor = kTitleColor;
        titleLab.font = [UIFont systemFontOfSize:17];
        titleLab.textAlignment = NSTextAlignmentCenter;
        titleLab;
    });
    UIButton * editBtn = ({
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(CGRectGetMaxX(contentView.frame) - 60, kStatusBarH, 60, 44);
        [btn setTitle:@"编辑" forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = 11;
        btn;
    });
    [contentView addSubview:backBtn];
    [contentView addSubview:titleLab];
    [contentView addSubview:editBtn];
    
    return contentView;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.tableView.editing) {
        return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
    }
    else
    {
        return UITableViewCellEditingStyleDelete;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.selectedArray addObject:indexPath];
    
    NSLog(@"didSelectRowAtIndexPath==>%ld",(long)indexPath.row);
    UIButton * deleteBtn = (UIButton *)[self.footerView viewWithTag:21];
    [deleteBtn setTitle:[NSString stringWithFormat:@"删除(%d)",(int)self.selectedArray.count] forState:UIControlStateNormal];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.selectedArray removeObject:indexPath];
    UIButton * deleteBtn = (UIButton *)[self.footerView viewWithTag:21];
    [deleteBtn setTitle:[NSString stringWithFormat:@"删除(%d)",(int)self.selectedArray.count] forState:UIControlStateNormal];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        DownloadListModel * model = self.dataSource[indexPath.row];
        [self.downloadManager deleteDownload:model.playbackID success:^(id result) {
            
        }];
        if(self.dataSource.count>indexPath.row){
            [self.dataSource removeObjectAtIndex:indexPath.row];
        }
        
        [self.tableView reloadData];
    }
}

//是否可以编辑  默认YES
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == self.tableView) {
        CGRect frame = self.footerView.frame;
        frame.origin.y = CGRectGetMaxY(self.view.frame) - CGRectGetHeight(self.footerView.frame) + scrollView.contentOffset.y;
        self.footerView.frame = frame;
    }
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    if (APPLICATION.statusBarOrientation == UIInterfaceOrientationLandscapeRight) {
        return UIInterfaceOrientationMaskLandscapeRight;
    }
    if (APPLICATION.statusBarOrientation == UIInterfaceOrientationPortrait) {
        return UIInterfaceOrientationMaskPortrait;
    }
    return UIInterfaceOrientationMaskPortrait;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    printf("_____________downloadList_____________");
}

- (TalkfunDownloadManager *)downloadManager
{
    if (!_downloadManager) {
        _downloadManager = [TalkfunDownloadManager shareManager];
    }
    return _downloadManager;
}

- (NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray new];
    }
    return _dataSource;
}

- (NSMutableArray *)selectedArray
{
    if (!_selectedArray) {
        _selectedArray = [NSMutableArray new];
    }
    return _selectedArray;
}

- (UIView *)footerView
{
    if (!_footerView) {
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.view.frame) - 60 - kTabBarSafeH, CGRectGetWidth(self.view.frame), 60)];
        _footerView.backgroundColor = kWhiteColor;
        UIButton * selectAllBtn = ({
            UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(15, 10, CGRectGetWidth(self.view.frame) / 2 - 20, CGRectGetHeight(_footerView.frame) - 20);
            [btn setBackgroundColor:[UIColor colorWithRed:0 green:178 / 255.0 blue:1 alpha:1]];
            [btn setTitle:@"全部选中" forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:13];
            btn.titleLabel.textAlignment = NSTextAlignmentCenter;
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
            btn.selected = NO;
            btn.tag = 20;
            btn.layer.cornerRadius = 3;
            btn;
        });
        
        UIButton * editBtn = ({
            UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(15 + 5 + 5 + CGRectGetWidth(selectAllBtn.frame), 10, CGRectGetWidth(self.view.frame) / 2 - 20, CGRectGetHeight(_footerView.frame) - 20);
            [btn setBackgroundColor:[UIColor redColor]];
            [btn setTitle:@"删除(0)" forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:13];
            btn.titleLabel.textAlignment = NSTextAlignmentCenter;
            [btn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
            btn.tag = 21;
            btn.layer.cornerRadius = 3;
            btn;
        });
        [_footerView addSubview:selectAllBtn];
        [_footerView addSubview:editBtn];
    }
    return _footerView;
}

- (SDWebImageManager *)sd_manager{
    if (!_sd_manager) {
        _sd_manager = [SDWebImageManager sharedManager];
    }
    return _sd_manager;
}

#pragma mark 本地通知
- (void)sendLocalNotification:(NSString*)title
{
    // 1.创建本地通知
    UILocalNotification *localNote = [[UILocalNotification alloc] init];
    
    // 2.设置本地通知的内容
    // 2.1.设置通知发出的时间
    localNote.fireDate = [NSDate dateWithTimeIntervalSinceNow:1.0];
    // 2.2.设置通知的内容
    localNote.alertBody = [NSString stringWithFormat:@"%@,下载完成",title];
    // 2.3.设置滑块的文字（锁屏状态下：滑动来“解锁”）
    localNote.alertAction = @"滑动来解锁”";
    // 2.4.决定alertAction是否生效
    localNote.hasAction = NO;
    
    // 2.6.设置alertTitle
    //    localNote.alertTitle = @"下载完成";
    // 2.7.设置有通知时的音效
    localNote.soundName = @"default";
    // 2.8.设置应用程序图标右上角的数字
    localNote.applicationIconBadgeNumber = 0;
    
    // 2.9.设置额外信息
    localNote.userInfo = @{@"type" : @1};
    
    // 3.调用通知
    [[UIApplication sharedApplication] scheduleLocalNotification:localNote];
}
#pragma mark - alertView delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    self.alertView =nil;
}

@end
