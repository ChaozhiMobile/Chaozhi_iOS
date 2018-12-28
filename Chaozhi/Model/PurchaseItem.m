//
//  PurchaseItem.m
//  Chaozhi
//
//  Created by Jason_zyl on 2018/12/28.
//  Copyright © 2018 Jason_hzb. All rights reserved.
//

#import "PurchaseItem.h"

@implementation PurchaseItem

+ (NSDictionary *)mj_objectClassInArray
{
    return @{
             @"chat":[ChatItem class]
             };
}

@end

@implementation ChatItem

@end
