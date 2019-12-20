//
//  XZCourseListCell.h
//  Xuezhi
//
//  Created by Jason_zyl on 2019/12/20.
//  Copyright © 2019 Jason_hzb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StudyInfoItem.h"
#import "CZVerticalLabel.h"

NS_ASSUME_NONNULL_BEGIN

@interface XZCourseListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *courseImgView;
@property (weak, nonatomic) IBOutlet CZVerticalLabel *courseNameLab;
@property (weak, nonatomic) IBOutlet UILabel *courseJieLab;
@property (weak, nonatomic) IBOutlet UILabel *courseDaoLab;

/** 学习课程model */
@property (nonatomic,retain) StudyInfoItem *item;

@end

NS_ASSUME_NONNULL_END
