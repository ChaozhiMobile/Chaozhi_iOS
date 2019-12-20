//
//  XZCourseListCell.m
//  Xuezhi
//
//  Created by Jason_zyl on 2019/12/20.
//  Copyright © 2019 Jason_hzb. All rights reserved.
//

#import "XZCourseListCell.h"

@implementation XZCourseListCell

- (void)setItem:(StudyInfoItem *)item {
    [self.courseImgView sd_setImageWithURL:[NSURL URLWithString:item.product_img] placeholderImage:[UIImage imageNamed:@"default_rectangle_img"]];
    self.courseNameLab.text = item.product_name;
    self.courseJieLab.text = [NSString stringWithFormat:@"%@节",item.user_time];
    self.courseDaoLab.text = [NSString stringWithFormat:@"%@道",item.user_question];
}

@end
