//
//  ModelChat.m
//  Talkfun_demo
//
//  Created by moruiquan on 16/1/26.
//  Copyright © 2016年 talk-fun. All rights reserved.
//

#import "ChatModel.h"
#import "MJExtension.h"
@implementation ChatModel

+(NSDictionary *)replacedKeyFromPropertyName
{
    return @{
             
             @"vote_new":@"vote:new",
             @"vote_pub":@"vote:pub",
             
              @"lottery_stop":@"lottery:stop",
              @"chat_disable":@"chat:disable",
              @"member_kick":@"member:kick",
           
             
             };
}

@end
