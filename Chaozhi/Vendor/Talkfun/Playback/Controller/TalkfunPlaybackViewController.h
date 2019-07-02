//
//  TalkfunPlaybackViewController.h
//  TalkfunSDKDemo
//
//  Created by 孙兆能 on 2016/11/28.
//  Copyright © 2016年 talk-fun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TalkfunPlaybackViewController : UIViewController

@property (nonatomic,strong) NSDictionary * res;
//@property (nonatomic,assign) BOOL isProtrait;
@property (nonatomic,copy) NSString * playbackID;
@property (nonatomic,copy) NSString *access_token;

//下载完成  (用来隐藏下载按键)
@property (nonatomic,assign)BOOL downloadCompleted;
@end
