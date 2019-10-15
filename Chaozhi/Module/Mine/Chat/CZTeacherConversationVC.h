//
//  CZTeacherConversationVC.h
//  Chaozhi
//
//  Created by zhanbing han on 2019/10/15.
//  Copyright © 2019 Jason_hzb. All rights reserved.
//

#import "BaseVC.h"
#import "TUIConversationCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface CZTeacherConversationVC : BaseVC

@end

@interface TMyConversationCell : TUIConversationCell
@property (nonatomic, strong) UILabel *courseNameLabel;
@end
@interface TMyUIConversationCellData : TUIConversationCellData
/** <#object#> */
@property (nonatomic,retain) NSDictionary *extral;
@end

NS_ASSUME_NONNULL_END
