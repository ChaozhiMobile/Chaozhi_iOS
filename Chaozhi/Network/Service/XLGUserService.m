//
//  XLGUserService.m
//  Chaozhi
//  Notes：
//
//  Created by Jason_hzb on 2018/5/29.
//  Copyright © 2018年 小灵狗出行. All rights reserved.
//

#import "XLGUserService.h"
#import "LoginItem.h"

@implementation XLGUserService

- (void)requestLoginWithService:(NSDictionary *)param {
    
    [[CommonRequest shareRequest] requestWithPost:URL_LoginOrRegister parameters:param success:^(id data) {

        NSDictionary *result = data[@"result"];

        NSMutableDictionary *userDic = [[[NSUserDefaults standardUserDefaults] objectForKey:@"UserInfo"] mutableCopy];
        if (!userDic) {
            userDic = [NSMutableDictionary dictionary];
        }
        [userDic setObject:result[@"token"] forKey:@"token"];
        [[UserInfo share] setUserInfo:userDic];

        [self onSuccMessage:result withType:_ACTION_LOGIN_];

    } failure:^(NSString *code) {

        [self onFailMessageWithType:_ACTION_LOGIN_];
    }];
}

@end
