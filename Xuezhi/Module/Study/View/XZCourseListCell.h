//
//  XZCourseListCell.h
//  Xuezhi
//
//  Created by Jason_zyl on 2019/12/20.
//  Copyright © 2019 Jason_hzb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StudyInfoItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface XZCourseListCell : UITableViewCell

/** 学习课程model */
@property (nonatomic,retain) StudyInfoItem *item;

@end

NS_ASSUME_NONNULL_END
