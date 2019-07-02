//
//  DownloadListController.h
//  TalkfunSDKDemo
//
//  Created by 孙兆能 on 16/7/11.
//  Copyright © 2016年 talk-fun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DownloadListController : UITableViewController

@property (nonatomic,strong) NSMutableArray * dataSource;
@property (nonatomic,copy  ) void (^controlBtnBlock)(NSString * playbackID,NSString *fileName,NSInteger btnNum,BOOL pauseDownload);

@end
