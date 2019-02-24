//
//  KeyChainUtil.m
//  Chaozhi
//  Notes：
//
//  Created by Jason_hzb on 2018/5/29.
//  Copyright © 2018年 小灵狗出行. All rights reserved.
//

#import "KeyChainUtil.h"
#import <Security/Security.h>

@implementation KeyChainUtil

static NSString * const SDictionaryKey = @"com.security.dictionaryKey";
static NSString * const SKeyChainKey = @"com.security.keychainKey";

+ (void)saveSecurityData:(NSString *)value {
    NSMutableDictionary *tempDic = [NSMutableDictionary dictionary];
    [tempDic setObject:value forKey:SDictionaryKey];
    [self save:SKeyChainKey data:tempDic];
}

+ (NSString *)readSecurityData{
    NSMutableDictionary *tempDic = (NSMutableDictionary *)[self load:SKeyChainKey];
    return [tempDic objectForKey:SDictionaryKey];
}

+ (void)deleteSecurityData{
    
    [self delete:SKeyChainKey];
}

+ (NSMutableDictionary *)getKeychainQuery:(NSString *)service {
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:
            (id)kSecClassGenericPassword,(id)kSecClass,
            service, (id)kSecAttrService,
            service, (id)kSecAttrAccount,
            (id)kSecAttrAccessibleAfterFirstUnlock,(id)kSecAttrAccessible,
            nil];
}

+ (void)save:(NSString *)service data:(id)data {
    //Get search dictionary
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    //Delete old item before add new item
    SecItemDelete((CFDictionaryRef)keychainQuery);
    //Add new object to search dictionary(Attention:the data format)
    [keychainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:data] forKey:(id)kSecValueData];
    //Add item to keychain with the search dictionary
    SecItemAdd((CFDictionaryRef)keychainQuery, NULL);
}

+ (id)load:(NSString *)service {
    id ret = nil;
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    //Configure the search setting
    //Since in our simple case we are expecting only a single attribute to be returned (the password) we can set the attribute kSecReturnData to kCFBooleanTrue
    [keychainQuery setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnData];
    [keychainQuery setObject:(id)kSecMatchLimitOne forKey:(id)kSecMatchLimit];
    CFDataRef keyData = NULL;
    if (SecItemCopyMatching((CFDictionaryRef)keychainQuery, (CFTypeRef *)&keyData) == noErr) {
        @try {
            ret = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge NSData *)keyData];
        } @catch (NSException *e) {
            NSLog(@"Unarchive of %@ failed: %@", service, e);
        } @finally {
            
        }
    }
    if (keyData)
        CFRelease(keyData);
    return ret;
}

+ (void)delete:(NSString *)service {
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    SecItemDelete((CFDictionaryRef)keychainQuery);
}

@end
