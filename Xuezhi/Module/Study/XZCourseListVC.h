//
//  XZCourseListVC.h
//  Xuezhi
//
//  Created by Jason_zyl on 2019/12/20.
//  Copyright © 2019 Jason_hzb. All rights reserved.
//

#import "BaseVC.h"
#import "StudyInfoItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface XZCourseListVC : BaseVC

@property (strong, nonatomic) NSArray <StudyInfoItem *>*dataArr;

@end

NS_ASSUME_NONNULL_END
