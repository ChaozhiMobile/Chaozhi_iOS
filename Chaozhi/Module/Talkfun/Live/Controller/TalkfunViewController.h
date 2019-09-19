//
//  TalkfunViewController.h
//  TalkfunSDKDemo
//
//  Created by 孙兆能 on 2016/11/18.
//  Copyright © 2016年 talk-fun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoItem.h"

@interface TalkfunViewController : BaseVC

/** 视频model */
@property (nonatomic,retain) VideoItem *videoItem;

@property (nonatomic,strong) NSDictionary * res;

//token
@property (nonatomic,strong)NSString *token;

//是否扫码自动启动
@property (nonatomic,assign)BOOL autoStart;

@end
