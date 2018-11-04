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
        if ([product_img containsString:@"http"]) {
            _product_img = product_img;
        } else {
            _product_img = [NSString stringWithFormat:@"http:%@",product_img];
        }
    }
}

@end

@implementation NewestInfoItem

+ (NSDictionary *)mj_objectClassInArray {
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

- (void)setLive_url:(NSString *)live_url {
    if (_live_url != live_url) {
        if ([live_url containsString:@"http"]) {
            _live_url = live_url;
        } else {
            _live_url = [NSString stringWithFormat:@"http:%@",live_url];
        }
    }
}

@end

@implementation LearnCourseItem

+ (NSDictionary *)replacedKeyFromPropertyName {
    return @{
             @"ID":@"id",
             };
}

- (void)setView_url:(NSString *)view_url {
    if (_view_url != view_url) {
        if ([view_url containsString:@"http"]) {
            _view_url = view_url;
        } else {
            _view_url = [NSString stringWithFormat:@"http:%@",view_url];
        }
    }
}

@end
