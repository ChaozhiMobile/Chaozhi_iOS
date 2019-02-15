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

@property (nonatomic, copy) NSString *teacher_unread; //0 班主任未读消息(个数)

@end

NS_ASSUME_NONNULL_END
