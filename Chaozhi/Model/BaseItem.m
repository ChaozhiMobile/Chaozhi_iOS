//
//  BaseItem.m
//  Chaozhi
//  Notes：
//
//  Created by Jason_hzb on 2018/5/29.
//  Copyright © 2018年 小灵狗出行. All rights reserved.
//

#import "BaseItem.h"

@implementation BaseItem

- (void)setValue:(nullable id)value forUndefinedKey:(NSString *)key {
    
}

+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper{
    return @{@"ID":@"id"};
}

@end
