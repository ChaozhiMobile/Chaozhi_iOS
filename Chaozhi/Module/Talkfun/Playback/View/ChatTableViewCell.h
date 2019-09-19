//
//  ChatTableViewCell.h
//  Talkfun_demo
//
//  Created by moruiquan on 16/1/25.
//  Copyright © 2016年 talk-fun. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PlaybackChatModel;
@interface ChatTableViewCell : UITableViewCell

@property (nonatomic,strong) NSDictionary      * expressionDict;
//序号
@property (nonatomic,assign) NSInteger         number;

@property (nonatomic,strong) NSMutableArray    * selectedArray;
@property (nonatomic,strong) PlaybackChatModel *Model;

@end
