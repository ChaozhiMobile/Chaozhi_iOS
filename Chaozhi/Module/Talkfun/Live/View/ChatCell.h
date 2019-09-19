//
//  ChatCell.h
//  Talkfun_demo
//
//  Created by moruiquan on 16/1/26.
//  Copyright © 2016年 talk-fun. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ChatModel;
@interface ChatCell : UITableViewCell

@property (nonatomic ,strong              ) ChatModel *Model;

@property (nonatomic,copy) void (^btnBlock) (BOOL,NSString  *);

@end
