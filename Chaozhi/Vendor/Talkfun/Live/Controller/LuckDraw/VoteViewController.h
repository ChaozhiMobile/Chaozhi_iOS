//
//  VoteViewController.h
//  Talkfun_demo
//
//  Created by talk－fun on 16/1/16.
//  Copyright © 2016年 talk-fun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VoteViewController : UIViewController

//block的第一个参数是：是否按了投票按钮  第二个参数是：问题的唯一标识vid
@property (nonatomic,copy) void (^voteBlock)(NSString * vid,NSArray * optionsArray);
//方向
@property (nonatomic,assign) NSInteger orientation;

//清空窗口
- (void)removeFromSuperview;
//MARK:投票发起
- (void)refreshUIWithParams:(NSDictionary *)params;
//MARK:结束投票
- (void)refreshUIWithResult:(NSDictionary *)params;

@end
