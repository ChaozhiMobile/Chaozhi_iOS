//
//  ModelChat.h
//  Talkfun_demo
//
//  Created by moruiquan on 16/1/26.
//  Copyright © 2016年 talk-fun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChatModel : NSObject
@property (nonatomic ,copy   ) NSString     *avatar;
@property (nonatomic ,strong ) NSDictionary *chat;

@property (nonatomic ,assign ) NSInteger    gender;
@property (nonatomic ,copy   ) NSString     *msg;
@property (nonatomic ,copy   ) NSString     *nickname;
@property (nonatomic ,copy   ) NSString     *role;
@property (nonatomic ,copy   ) NSString     *time;
@property (nonatomic ,copy   ) NSString     *sendtime;
@property (nonatomic ,copy   ) NSString     *uid;
@property (nonatomic ,copy   ) NSString     *vid;
@property (nonatomic ,copy   ) NSString     *isShow;
@property (nonatomic ,strong ) NSNumber     *amount;


@property (nonatomic ,copy   ) NSString     *vote_new;
@property (nonatomic ,copy   ) NSString     *vote_pub;
@property (nonatomic ,copy   ) NSString     *lottery_stop;
@property (nonatomic ,copy   ) NSString     *broadcast;
@property (nonatomic ,copy   ) NSString     *chat_disable;
@property (nonatomic ,copy   ) NSString     *member_kick;
@property (nonatomic ,copy   ) NSString     *launch_nickname;
@property (nonatomic ,copy   ) NSString     *mess;

@property (nonatomic ,copy   ) NSString     *starttime;

@property (nonatomic ,copy   ) NSString     *startTime;
@end
