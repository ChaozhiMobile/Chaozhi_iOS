//
//  UserInfo.h
//  Chaozhi
//  Notes：用户model
//
//  Created by Jason_hzb on 2018/5/29.
//  Copyright © 2018年 小灵狗出行. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseItem.h"
@interface UserInfo : BaseItem

@property (nonatomic,copy) NSString *token;
@property (nonatomic,copy) NSString *ID; //用户id
@property (nonatomic,copy) NSString *status; //
@property (nonatomic,copy) NSString *buy_flag; //
@property (nonatomic,copy) NSString *phone; //手机号码
@property (nonatomic,copy) NSString *cn_name; //中文名称
@property (nonatomic,copy) NSString *sex; //M 男 F女
@property (nonatomic,copy) NSString *birthday; //生日
@property (nonatomic,copy) NSString *email; //邮箱
@property (nonatomic,copy) NSString *province; //省
@property (nonatomic,copy) NSString *city; //市
@property (nonatomic,copy) NSString *county; //区/县
@property (nonatomic,copy) NSString *addr; //地址
@property (nonatomic,copy) NSString *head_img; //头像
@property (nonatomic,copy) NSString *nickname; //昵称
@property (nonatomic,copy) NSString *autograph; //签名
@property (nonatomic,copy) NSString *brief; //简介
@property (nonatomic,copy) NSString *head_img_url; //头像地址

+ (UserInfo *)share;

- (void)setUserInfo:(NSMutableDictionary *)userDic;

- (void)removeUserInfo;

@end
