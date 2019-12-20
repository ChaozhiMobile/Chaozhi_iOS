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

typedef void (^SelectCourseBlock) (NSInteger index);

@interface XZCourseListVC : BaseVC

/** 选择课程回调 */
@property (nonatomic, copy) SelectCourseBlock selectBlock;

@property (nonatomic, strong) NSArray <StudyInfoItem *>*dataArr;

@end

NS_ASSUME_NONNULL_END
