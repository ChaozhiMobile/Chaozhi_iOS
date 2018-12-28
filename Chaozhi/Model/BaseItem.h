//
//  BaseItem.h
//  Chaozhi
//  Notes：model基类
//  在线json转化为model类 http://modelend.com/
//
//  Created by Jason_hzb on 2018/5/29.
//  Copyright © 2018年 小灵狗出行. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYModel.h>

@interface BaseItem : NSObject<YYModel>

@property (nonatomic, assign) UInt64 code;
@property (nonatomic, copy) NSString *msg;

@end
