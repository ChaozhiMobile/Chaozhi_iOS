//
//  CourseCategoryItem.m
//  Chaozhi
//  Notes：
//
//  Created by Jason_hzb on 2018/5/29.
//  Copyright © 2018年 小灵狗出行. All rights reserved.
//

#import "CourseCategoryItem.h"

@implementation CourseCategoryItem

//+ (NSDictionary *)replacedKeyFromPropertyName {
//    return @{
//             @"ID":@"id",
//             };
//}

- (void)setImg:(NSString *)img {
    if (_img != img) {
        if ([img containsString:@"http"]) {
            _img = img;
        } else {
            _img = [NSString stringWithFormat:@"http:%@",img];
        }
    }
}

@end
