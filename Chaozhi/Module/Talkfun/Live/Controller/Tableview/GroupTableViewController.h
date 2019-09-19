//
//  GroupTableViewController.h
//  TalkfunSDKDemo
//
//  Created by talk－fun on 16/3/7.
//  Copyright © 2016年 talk-fun. All rights reserved.
//

#import "RootTableViewController.h"


@interface GroupTableViewController : RootTableViewController

@property (nonatomic,strong) NSMutableDictionary * groupDict;
@property (nonatomic,copy  ) NSString            * groupid;

- (void)addObj:(id)obj;
- (void)addMessage:(id)obj;

@end
