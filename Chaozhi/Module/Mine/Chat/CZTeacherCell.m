//
//  CZTeacherCell.m
//  Chaozhi
//
//  Created by zhanbing han on 2019/10/16.
//  Copyright © 2019 Jason_hzb. All rights reserved.
//

#import "CZTeacherCell.h"
#import "NSDate+TUIKIT.h"

#define CellSpace autoScaleW(10)

@implementation CZTeacherCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];

        _headImageView = [[UIImageView alloc] init];
        [self addSubview:_headImageView];

        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = [UIFont systemFontOfSize:12];
        _timeLabel.textColor = [UIColor lightGrayColor];
        _timeLabel.layer.masksToBounds = YES;
        [self addSubview:_timeLabel];

        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.layer.masksToBounds = YES;
        [self addSubview:_titleLabel];

        _unReadView = [[TUnReadView alloc] init];
        [self addSubview:_unReadView];

        _subTitleLabel = [[UILabel alloc] init];
        _subTitleLabel.layer.masksToBounds = YES;
        _subTitleLabel.font = [UIFont systemFontOfSize:14];
        _subTitleLabel.textColor = [UIColor lightGrayColor];
        [self addSubview:_subTitleLabel];

        _courseNameLabel = [[CZLabel alloc] init];
        _courseNameLabel.backgroundColor = RGBAValue(0x42AFD9, 0.1);
        _courseNameLabel.edgeInsets = UIEdgeInsetsMake(3, 3, 3, 3);//设置内边距
        [_courseNameLabel sizeToFit];
        _courseNameLabel.layer.cornerRadius = 5;
        [_courseNameLabel.layer setMasksToBounds:YES];
        _courseNameLabel.numberOfLines = 0;
        _courseNameLabel.font = [UIFont systemFontOfSize:14];
        _courseNameLabel.textColor = RGBValue(0x1691C0);
        [self addSubview:_courseNameLabel];
        
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        [_headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(CellSpace);
            make.size.mas_equalTo(CGSizeMake(autoScaleW(60), autoScaleW(60)));
            make.centerY.mas_equalTo(self);
        }];
   
        [_unReadView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(_headImageView);
            make.top.mas_equalTo(_headImageView).offset(-CellSpace/2.0);
            make.size.mas_equalTo(CGSizeMake(autoScaleW(20), autoScaleW(20)));
        }];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.headImageView.mas_right).offset(CellSpace);
            make.top.mas_equalTo(self).offset(CellSpace);
            make.right.mas_equalTo(self).offset(100);
        }];
        
        [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
               make.right.mas_equalTo(self).offset(-CellSpace);
               make.top.mas_equalTo(self).offset(CellSpace);
               make.centerY.mas_equalTo(_titleLabel);
        }];
        
        [_courseNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.titleLabel);
            make.top.mas_equalTo(_titleLabel.mas_bottom).offset(CellSpace);
            make.right.mas_lessThanOrEqualTo(self).offset(-CellSpace);

        }];
        
        [_subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.titleLabel);
            make.top.mas_equalTo(_courseNameLabel.mas_bottom).offset(CellSpace);
            make.right.mas_equalTo(_titleLabel).offset(-CellSpace);
            make.bottom.mas_equalTo(self).offset(-CellSpace);
        }];
    }
    return self;
}

- (void)setConvData:(TUIConversationCellData *)convData {
    if (_convData!=convData) {
        _convData = convData;
    }
    [self.headImageView sd_setImageWithURL:convData.avatarUrl placeholderImage:self.convData.avatarImage];
    self.titleLabel.text = convData.title;
    self.timeLabel.text = [convData.time tk_messageString];
    self.subTitleLabel.text = convData.subTitle;
    [self.unReadView setNum:convData.unRead];
}

@end
