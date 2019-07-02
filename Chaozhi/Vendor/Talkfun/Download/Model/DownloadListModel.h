//
//  DownloadListModel.h
//  TalkfunSDKDemo
//
//  Created by 孙兆能 on 16/7/11.
//  Copyright © 2016年 talk-fun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TalkfunDownloadManager.h"

@interface DownloadListModel : NSObject

//@property (nonatomic,strong)NSNumber * totalSize;
//title
@property (nonatomic,copy)NSString * fileName;
@property (nonatomic,copy)NSString * totalSize;
@property (nonatomic,copy)NSString * downloadedSize;
@property (nonatomic,copy)NSString * duration;
// 未开始  、 暂停  、 正在下载  、 下载完成 、 下载错误   status
@property (nonatomic,assign)TalkfunDownloadStatus downloadStatus;
@property (nonatomic,copy)NSString * access_token;
//downloadStartTime + downloadEndTime
@property (nonatomic,copy)NSString * downloadStartTime;
@property (nonatomic,copy)NSString * downloadEndTime;

@property (nonatomic,copy)NSString * playbackID;
@property (nonatomic,copy)NSString * title;

//缩略图片
@property (nonatomic,copy)NSString * thumb;

@end
