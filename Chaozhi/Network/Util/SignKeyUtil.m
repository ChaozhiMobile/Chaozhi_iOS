//
//  SignKeyUtil.m
//  Chaozhi
//  Notes：
//
//  Created by Jason_hzb on 2018/5/28.
//  Copyright © 2018年 小灵狗出行. All rights reserved.
//

#import "SignKeyUtil.h"

@implementation SignKeyUtil

+ (NSString *)getNonceString {
    
    CFUUIDRef uuid_ref = CFUUIDCreate(NULL);
    
    CFStringRef uuid_string_ref = CFUUIDCreateString(NULL, uuid_ref);
    
    NSString *uuid = [NSString stringWithString:(__bridge NSString *)uuid_string_ref];
    
    CFRelease(uuid_ref);
    
    CFRelease(uuid_string_ref);
    
    return [[uuid lowercaseString] stringByReplacingOccurrencesOfString:@"-" withString:@""];
}

/**
 * 签名算法规则
 * 1、将所有参数按照key值从低字母到高字母&拼接排列，然后&key=签名key
 * 2、md5To32bit转成大写
 */
+ (NSString *)getSignByDic:(NSMutableDictionary *)params withType:(NSString *)type {
    
    NSArray *myKeys = [params allKeys];
    NSArray *sortedKeys = [myKeys sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    
    //    NSLog(@"第一步：排序keys：%@",sortedKeys);
    
    NSMutableString *serailizedStr = [self serialize:params and: sortedKeys];
    NSString *getParams = [serailizedStr copy];
    
    //    NSLog(@"第二步：序列化转成字符串：%@",serailizedStr);
    
    NSString *jointStr = [NSString stringWithFormat:@"&key=%@",kSignKey];
    [serailizedStr appendString:jointStr];
    
    //    NSLog(@"第三步：拼接SignKey：%@",jointStr);
    
    NSString *sign = [[serailizedStr md5To32bit] uppercaseString];
    
    //    NSLog(@"第四步：md5转32位转大写：%@",sign);
    
    if ([type isEqualToString:@"post"]) {
        return sign;
    } else {
        return [NSString stringWithFormat:@"?%@&sign=%@",getParams,sign];
    }
}

+ (NSString *)getSignByStr:(NSString *)url withType:(NSString *)type {
    
    return [self getSignByDic:[self unSerialize:url] withType:type];
}

+ (NSMutableDictionary *)unSerialize:(NSString *)url {
    
    NSMutableDictionary *dictM = [NSMutableDictionary dictionary];
    
    NSRange range = [url rangeOfString:@"?"];
    
    NSString *paramStr = url;
    
    if (range.length) {
        
        NSUInteger index = range.location + 1;
        paramStr = [url substringFromIndex:index];
    }
    
    NSArray *arr = [paramStr componentsSeparatedByString:@"&"];
    
    for (NSString *item in arr) {
        
        NSArray *arrItem = [item componentsSeparatedByString:@"="];
        if ([arrItem count] > 0) {
            
            NSString *key = arrItem[0];
            NSString *value = arrItem[1];
            if (![Utils isBlankString:value]) {
                [dictM setObject:value forKey:key];
            }
        }
    }
    
    return dictM;
}

+ (NSMutableString*)serialize:(NSMutableDictionary *)params and:(NSArray *)keys {
    
    NSMutableString *serialzeStr = [NSMutableString string];
    for (NSString *key in keys) {
        
        NSString *value = [params valueForKey:key];
        if (![Utils isBlankString:value]) {
            NSString *defStr = [NSString stringWithFormat:@"%@=%@&",key,value];
            [serialzeStr appendString:defStr];
        }
    }
    
    NSRange range = [serialzeStr rangeOfString:@"&" options:NSBackwardsSearch];
    
    [serialzeStr deleteCharactersInRange:range];
    
    return serialzeStr;
}

@end
