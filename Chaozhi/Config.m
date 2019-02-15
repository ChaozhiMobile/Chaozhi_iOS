//
//  Config.m
//  Chaozhi
//  Notes：
//
//  Created by Jason_hzb on 2018/5/29.
//  Copyright © 2018年 小灵狗出行. All rights reserved.
//

#import "Config.h"

@implementation Config

NSString *h5Url(void) {
    if (KOnline || [Utils getServer] == 1) {
        return @"https://m.chaozhiedu.com/"; //正式地址
    } else {
//        return @"http://mtest.chaozhiedu.com/"; //测试地址
        return @"http://10.0.6.144:8082/"; //开发地址
    }
}

NSString *domainUrl(void) {
    
    if (KOnline || [Utils getServer] == 1) {
        return @"https://aci-api.chaozhiedu.com/"; //正式地址
    } else {
        return @"http://test-aci-api.chaozhiedu.com/"; //测试地址
    }
}

@end
