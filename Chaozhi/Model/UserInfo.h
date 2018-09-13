//
//  UserInfo.h
//  Chaozhi
//  Notes：用户model
//
//  Created by Jason_hzb on 2018/5/29.
//  Copyright © 2018年 小灵狗出行. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfo : NSObject

@property (nonatomic,copy) NSString *token;

+ (UserInfo *)share;

- (void)getUserInfo;

- (void)setUserInfo:(NSDictionary *)userDic;

@end
