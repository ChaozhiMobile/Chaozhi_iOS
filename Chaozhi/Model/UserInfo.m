//
//  UserInfo.m
//  Chaozhi
//  Notes：
//
//  Created by Jason_hzb on 2018/5/29.
//  Copyright © 2018年 小灵狗出行. All rights reserved.
//

#import "UserInfo.h"
#import "PurchaseItem.h"

static UserInfo *_userInfo = nil;
static NSUserDefaults *_defaults = nil;

@implementation UserInfo

+ (instancetype)share {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _userInfo = [[UserInfo alloc] init];
        _defaults = [NSUserDefaults standardUserDefaults];
    });
    NSDictionary *infoDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserInfo"];
    if (infoDic.allKeys.count>0) {
        _userInfo = [UserInfo mj_objectWithKeyValues:(NSDictionary *)infoDic];
    }
    return _userInfo;
}

- (void)setUserInfo:(NSMutableDictionary *)userDic {
    if (userDic.allKeys.count==0) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"UserInfo"];
        [CacheUtil saveCacher:@"token" withValue:@""];
    }
    [[NSUserDefaults standardUserDefaults] setObject:userDic forKey:@"UserInfo"];//存储用户信息
}

- (void)removeUserInfo {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"UserInfo"];
    [CacheUtil saveCacher:@"token" withValue:@""];
}

- (NSString *)token {
    return [CacheUtil getCacherWithKey:@"token"];
}

- (void)setHead_img_url:(NSString *)head_img_url {
    if (_head_img_url != head_img_url) {
        if ([head_img_url containsString:@"http"]) {
            _head_img_url = head_img_url;
        } else {
            _head_img_url = [NSString stringWithFormat:@"http:%@",head_img_url];
        }
    }
}

+ (NSDictionary *)mj_objectClassInArray
{
    return @{
             @"purchase":[PurchaseItem class]
             };
}

@end
