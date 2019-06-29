//
//  ModelQuestion.h
//  Talkfun_demo
//
//  Created by moruiquan on 16/1/26.
//  Copyright © 2016年 talk-fun. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface QuestionModel : NSObject
@property (nonatomic ,copy ) NSString  *avatar;
@property (nonatomic ,copy ) NSString *content;
@property (nonatomic ,copy ) NSString *liveid;
@property (nonatomic ,copy ) NSString *nickname;
@property (nonatomic ,copy ) NSString *qid;

@property (nonatomic ,copy ) NSString *replies;
@property (nonatomic ,copy ) NSString *replyId;
@property (nonatomic ,copy ) NSString *sn;
@property (nonatomic ,copy ) NSString *role;

@property (nonatomic ,copy ) NSString *startTime;
@property (nonatomic ,copy ) NSString *status;

@property (nonatomic ,copy ) NSString *time;
@property (nonatomic ,copy ) NSString *uid;
@property (nonatomic ,copy ) NSString *xid;

@property (nonatomic,strong) NSArray  *answer;

@end
