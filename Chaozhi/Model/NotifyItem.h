//
//  NotifyItem.h
//  Chaozhi
//
//  Created by Jason_zyl on 2019/2/15.
//  Copyright © 2019 Jason_hzb. All rights reserved.
//

#import "BaseItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface NotifyItem : BaseItem

@property (nonatomic, copy) NSString *teacher_unread; //0 班主任消息未读(个数)
@property (nonatomic, copy) NSString *msg_unread; //0 我的消息未读(个数)

@end

NS_ASSUME_NONNULL_END
