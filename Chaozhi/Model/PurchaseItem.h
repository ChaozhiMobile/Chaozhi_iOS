//
//  PurchaseItem.h
//  Chaozhi
//
//  Created by Jason_zyl on 2018/12/28.
//  Copyright © 2018 Jason_hzb. All rights reserved.
//

#import "BaseItem.h"

@class ChatItem;

@interface PurchaseItem : BaseItem

@property (nonatomic , assign) NSInteger is_purchase; //报班状态 0未报班 1已报班
@property (nonatomic , strong) NSArray   *chat; //聊天数组，每个班型对应一个聊天结构体

@end

@interface ChatItem : BaseItem

@property (nonatomic , assign) NSInteger product_id; //产品id
@property (nonatomic , copy) NSString    *product_name; //产品名称
@property (nonatomic , copy) NSString    *chat_url; //聊天url地址

@end
