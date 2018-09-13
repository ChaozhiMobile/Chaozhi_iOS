//
//  XLGUserService.h
//  Chaozhi
//  Notes：用户相关的接口(登录、获取用户信息等)
//
//  Created by Jason_hzb on 2018/5/29.
//  Copyright © 2018年 小灵狗出行. All rights reserved.
//

#import "BaseService.h"

@interface XLGUserService : BaseService

#pragma mark - 登录
- (void)requestLoginWithService:(NSDictionary *)param;

@end
