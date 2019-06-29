//
//  GroupChatTableViewController.h
//  TalkfunSDKDemo
//
//  Created by talk－fun on 16/3/8.
//  Copyright © 2016年 talk-fun. All rights reserved.
//

#import "RootTableViewController.h"

@interface GroupChatTableViewController : RootTableViewController

@property (nonatomic,copy) NSString * groupid;
@property (nonatomic,copy) NSString * nickname;
- (void)addObj:(id)obj;

@end
