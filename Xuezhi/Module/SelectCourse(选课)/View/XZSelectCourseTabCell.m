//
//  XZSelectCourseTabCell.m
//  Xuezhi
//
//  Created by Jason_zyl on 2019/8/2.
//  Copyright © 2019 Jason_hzb. All rights reserved.
//

#import "XZSelectCourseTabCell.h"

@implementation XZSelectCourseTabCell

- (void)setItem:(CourseItem *)item {
    [_thumbImgView sd_setImageWithURL:[NSURL URLWithString:item.img] placeholderImage:[UIImage imageNamed:@"default_course"]];
    _titleLab.text = item.name;
    _currentPriceLab.text = [NSString stringWithFormat:@"%@",item.price];
    _oldPriceLab.text = [NSString stringWithFormat:@"%@",item.price];
}

@end
