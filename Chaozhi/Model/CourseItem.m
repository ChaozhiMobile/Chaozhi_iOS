//
//  CourseItem.m
//  Chaozhi
//  Notes：
//
//  Created by Jason_hzb on 2018/5/29.
//  Copyright © 2018年 小灵狗出行. All rights reserved.
//

#import "CourseItem.h"

@implementation CourseItem

+ (NSDictionary *)replacedKeyFromPropertyName {
    return @{
             @"ID":@"id",
             };
}

- (void)setImg:(NSString *)img {
    if (_img != img) {
        _img = [NSString stringWithFormat:@"http:%@",img];
    }
}

@end
