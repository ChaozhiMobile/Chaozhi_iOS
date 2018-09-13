//
//  SignKeyUtil.h
//  Chaozhi
//  Notes：接口签名工具
//
//  Created by Jason_hzb on 2018/5/28.
//  Copyright © 2018年 小灵狗出行. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SignKeyUtil : NSObject

/**
 * 干扰码
 */
+ (NSString *)getNonceString;

/**
 * 参数的MD5签名值【根据字典】
 */
+ (NSString *)getSignByDic:(NSMutableDictionary *)params withType:(NSString *)type;

/**
 * 参数的MD5签名值【根据字符串】
 */
+ (NSString *)getSignByStr:(NSString *)url withType:(NSString *)type;

@end
