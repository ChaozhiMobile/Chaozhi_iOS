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

NSString *domainUrl(void){
    
    NSString *server = [CacheUtil getCacherWithKey:kTestServerKey];
    
    if (KOnline) {
        return @"http://api2.evcoming.com:5131/v3/"; //宁波线上服务器地址
    } else if ([Utils isBlankString:server]) {
        return @"http://122.246.11.153:5131/v3/"; //宁波测试服务器地址
    } else {
        return @"http://api2.evcoming.com:5131/v3/"; //宁波线上服务器地址
    }
}

@end
