//
//  CourseCategoryItem.h
//  Chaozhi
//  Notes：
//
//  Created by Jason_hzb on 2018/5/29.
//  Copyright © 2018年 小灵狗出行. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseItem.h"

@interface CourseCategoryItem : BaseItem

/*!
 *  @brief YES：选中 NO：没选中
 */
@property (nonatomic,assign) BOOL selectStatus;

@property (nonatomic, copy) NSString *ID; //id
@property (nonatomic, copy) NSString *name; //分类名称
@property (nonatomic, copy) NSString *img; //分类图片
@property (nonatomic, copy) NSString *pid; //父id
@property (nonatomic, copy) NSString *subCount; //子分类数量
@property (nonatomic, strong) NSArray *children; //子分类

@end
