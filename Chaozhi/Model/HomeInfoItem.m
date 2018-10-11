//
//  HomeInfoItem.m
//  Chaozhi
//
//  Created by zhanbing han on 2018/10/11.
//  Copyright © 2018年 Jason_hzb. All rights reserved.
//

#import "HomeInfoItem.h"

@implementation HomeInfoItem

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass
{
    return @{@"activity_list":[HomeActivityItem class],@"banner_list":[HomeBannerItem class]};
}

@end

@implementation HomeActivityItem
@end

@implementation HomeBannerItem
@end

@implementation HomeCategoryItem
+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass
{
    return @{@"try_video_list":[HomeTryVideoItem class],@"teacher_list":[HomeTeacherItem class],@"feature_product_list":[HomeFeatureProductItem class]};
}
@end


@implementation HomeFeatureProductItem

@end

@implementation HomeTryVideoItem

@end

@implementation HomeTeacherItem

@end

