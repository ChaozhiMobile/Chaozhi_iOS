//
//  StudyInfoItem.m
//  Chaozhi
//
//  Created by Jason_zyl on 2018/10/19.
//  Copyright © 2018年 Jason_hzb. All rights reserved.
//

#import "StudyInfoItem.h"

@implementation StudyInfoItem

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
             @"ID":@"id",
             };
}

+ (NSDictionary *)mj_objectClassInArray
{
    return @{
             @"newest_info":[NewestInfoItem class]
             };
}

- (void)setProduct_img:(NSString *)product_img {
    if (_product_img != product_img) {
        _product_img = [NSString stringWithFormat:@"http:%@",product_img];
    }
}

@end

@implementation NewestInfoItem

+ (NSDictionary *)replacedKeyFromPropertyName {
    return @{
             @"live_list":[LiveItem class],
             @"learn_course_list":[LearnCourseItem class],
             };
}

@end

@implementation LiveItem

+ (NSDictionary *)replacedKeyFromPropertyName {
    return @{
             @"ID":@"id",
             };
}

@end

@implementation LearnCourseItem

+ (NSDictionary *)replacedKeyFromPropertyName {
    return @{
             @"ID":@"id",
             };
}

@end
