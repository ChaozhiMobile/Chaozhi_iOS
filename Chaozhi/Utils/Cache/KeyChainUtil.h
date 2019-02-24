//
//  KeyChainUtil.h
//  Chaozhi
//  Notes：keychain钥匙串存储，不会因为卸载/重装app而丢失，更加安全
//
//  Created by Jason_hzb on 2018/5/29.
//  Copyright © 2018年 小灵狗出行. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KeyChainUtil : NSObject

+ (void)saveSecurityData:(NSString *)value;

+ (NSString *)readSecurityData;

+ (void)deleteSecurityData;

@end
