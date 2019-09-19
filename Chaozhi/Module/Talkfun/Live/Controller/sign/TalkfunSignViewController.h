//
//  TalkfunSignViewController.h
//  TalkfunSDKDemo
//
//  Created by moruiwei on 2017/10/18.
//  Copyright © 2017年 Talkfun. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^SignIdBlock)(NSString *signId);

@interface TalkfunSignViewController : UIViewController




@property (nonatomic, strong) SignIdBlock signIdBlock;


//MARK:签到发起
- (void)refreshUIWithParams:(NSDictionary *)singnDict;
//清空窗口
- (void)deleteClicked;
@end
