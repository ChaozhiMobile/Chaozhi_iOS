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
    [_thumbImgView sd_setImageWithURL:[NSURL URLWithString:item.img] placeholderImage:[UIImage imageNamed:@"default_live"]];
    _titleLab.text = item.name;
    _currentPriceLab.text = [NSString stringWithFormat:@"%@",item.price];
    _oldPriceLab.text = [NSString stringWithFormat:@"%@",item.original_price];
    NSArray *tags = [item.tags componentsSeparatedByString:@","];
    NSArray *tagsLab = @[_tagLab1,_tagLab2,_tagLab3];
    NSArray *colorArr = @[RGBValue(0xA3D280),RGBValue(0x88B9F9),RGBValue(0xE2B66E)];
    for (NSInteger index = 0; index<tagsLab.count; index++) {
        NSString *content = @"";
        if (index<tags.count) {
            content = tags[index];
        }
        UILabel *tagLab = tagsLab[index];
        tagLab.text = content;
        if (content.length>0) {
            tagLab.textColor = colorArr[index];
            tagLab.superview.borderColor = colorArr[index];
        }
        else {
            tagLab.textColor = [UIColor clearColor];;
            tagLab.superview.borderColor = [UIColor clearColor];
        }
        tagLab.superview.borderWidth = 1;
        tagLab.superview.cornerRadius = 5;
    }
}

@end
