//
//  LoginItem.h
//  Chaozhi
//  Notes：
//
//  Created by Jason_hzb on 2018/5/29.
//  Copyright © 2018年 小灵狗出行. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseItem.h"

@interface LoginItem : BaseItem

@property(nonatomic,copy)NSString *token;
@property(nonatomic,copy)NSString *areaId;
@property(nonatomic,copy)NSString *memberId;

@end
