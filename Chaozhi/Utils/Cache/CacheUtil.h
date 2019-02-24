//
//  CacheUtil.h
//  Chaozhi
//  Notes：NSUserDefaults缓存
//
//  Created by Jason_hzb on 2018/5/29.
//  Copyright © 2018年 小灵狗出行. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CacheUtil : NSObject

+ (id)getCacherWithKey:(NSString *)key;

+ (void)saveCacher:(NSString *) key withValue:(NSString *)value;

+ (void)clearCacher;

@end
