//
//  CZSelectCourseCell.m
//  Chaozhi
//
//  Created by Jason_zyl on 2018/10/7.
//  Copyright © 2018年 Jason_hzb. All rights reserved.
//

#import "CZSelectCourseCell.h"

@interface CZSelectCourseCell ()
{
    UIImageView *_iconImgView;
    UILabel *_titleLab;
    UIButton *_selectBtn;
}
@end

@implementation CZSelectCourseCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _iconImgView = [[UIImageView alloc] initWithFrame:CGRectMake(autoScaleW(20), self.height/2-autoScaleW(10), autoScaleW(20), autoScaleW(20))];
        [self addSubview:_iconImgView];
        
       
        
        _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(_iconImgView.right+autoScaleW(12), 0, WIDTH-autoScaleW(80), self.height)];
        _titleLab.textAlignment = NSTextAlignmentLeft;
        _titleLab.font = [UIFont systemFontOfSize:13];
        _titleLab.textColor = RGBValue(0x24253D);
        [self addSubview:_titleLab];
        
        _selectBtn = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH-autoScaleW(35), (self.height-autoScaleW(20))/2.0, autoScaleW(20), autoScaleW(20))];
        _selectBtn.userInteractionEnabled = NO;
        [_selectBtn setBackgroundImage:[UIImage imageNamed:@"icon_select"] forState:UIControlStateNormal];
        [self addSubview:_selectBtn];
        
        
        [_iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(autoScaleW(20), autoScaleW(20)));
            make.left.mas_equalTo(self).offset(autoScaleW(20));
            make.centerY.mas_equalTo(self);
        }];
        
        [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_iconImgView.mas_right).offset(autoScaleW(12));
            make.centerY.mas_equalTo(self);
            make.right.mas_equalTo(self).offset(-autoScaleW(60));
            
        }];
        
        [_selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(autoScaleW(20), autoScaleW(20)));
            make.right.mas_equalTo(self).offset(-autoScaleW(35));
            make.centerY.mas_equalTo(self);
        }];
    }
    return self;
}

- (void)setContentWithModel:(CourseCategoryItem *)model {
    
    [_iconImgView sd_setImageWithURL:[NSURL URLWithString:model.img] placeholderImage:[UIImage imageNamed:@"default_square_img"]];
    
    _titleLab.text = model.name;
    
    BOOL selectStatus = model.selectStatus;
    if (selectStatus == YES) {
        _selectBtn.hidden = NO;
//        _titleLab.textColor = AppThemeColor;
    } else {
        _selectBtn.hidden = YES;
//        _titleLab.textColor = RGBValue(0x24253D);
    }
}

@end
