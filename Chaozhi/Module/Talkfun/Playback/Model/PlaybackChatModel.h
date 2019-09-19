//
//  chat.h
//  Talkfun_demo
//
//  Created by moruiquan on 16/1/15.
//  Copyright © 2016年 talk-fun. All rights reserved.
//

#import <Foundation/Foundation.h>
//聊天模型
@interface PlaybackChatModel : NSObject
@property (nonatomic ,copy   ) NSString     *avatar;
@property (nonatomic,copy  ) NSString *msg;
@property (nonatomic,copy  ) NSString *message;
@property (nonatomic,copy  ) NSString *nickname;
@property (nonatomic,copy  ) NSString *role;
@property (nonatomic,copy  ) NSString *starttime;
@property (nonatomic,copy  ) NSString *timestamp;
@property (nonatomic,copy  ) NSString *xid;

@property (nonatomic,strong) NSArray  *answer;



@end
