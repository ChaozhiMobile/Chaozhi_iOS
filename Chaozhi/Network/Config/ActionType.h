//
//  ActionType.h
//  Chaozhi
//  Notes：接口Action
//
//  Created by Jason_hzb on 2018/5/29.
//  Copyright © 2018年 小灵狗出行. All rights reserved.
//

#ifndef ActionType_h
#define ActionType_h

typedef NS_ENUM(NSInteger,ActionType){
    
    _ACTION_DEFAULT_, //默认
    
    _ACTION_VALIDATE_, //获取验证码
    _ACTION_LOGIN_, //登录
};

#endif /* ActionType_h */
