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
        return H5_URL; //正式地址
    } else {
        return H5_URL_D; //测试地址
    }
}

NSString *domainUrl(void) {
    
    if (KOnline || [Utils getServer] == 1) {
        return BASE_URL; //正式地址
    } else {
        return BASE_URL_D; //测试地址
    }
}

@end
