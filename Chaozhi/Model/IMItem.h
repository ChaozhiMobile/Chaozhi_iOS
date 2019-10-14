//
//  IMItem.h
//  Chaozhi
//
//  Created by Jason_zyl on 2019/10/14.
//  Copyright © 2019 Jason_hzb. All rights reserved.
//

#import "BaseItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface IMItem : BaseItem

@property (nonatomic, copy) NSString *accid; //腾讯IM accid
@property (nonatomic, copy) NSString *token; //腾讯IM token

@end

NS_ASSUME_NONNULL_END
