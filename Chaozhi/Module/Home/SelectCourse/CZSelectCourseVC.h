//
//  CZSelectCourseVC.h
//  Chaozhi
//
//  Created by Jason_zyl on 2018/10/7.
//  Copyright © 2018年 Jason_hzb. All rights reserved.
//

#import "BaseVC.h"
#import "CourseCategoryItem.h"

typedef void (^SelectCourseBlock) (CourseCategoryItem *item);

@interface CZSelectCourseVC : BaseVC

@property (nonatomic, copy) SelectCourseBlock selectCourseBlock; //选择完课程，回首页

@end
