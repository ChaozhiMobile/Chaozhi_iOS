//
//  XLGChangeServerCell.m
//  SharenGo
//  Notes：
//
//  Created by Jason_hzb on 2018/7/5.
//  Copyright © 2018年 小灵狗出行. All rights reserved.
//

#import "XLGChangeServerCell.h"

@interface XLGChangeServerCell ()
{
    UIButton *_selectBtn;
    UILabel *_titleLab;
}
@end

@implementation XLGChangeServerCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    
        _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(autoScaleW(15), 0, WIDTH-autoScaleW(80), self.height)];
        _titleLab.textAlignment = NSTextAlignmentLeft;
        _titleLab.font = [UIFont systemFontOfSize:14];
        [self addSubview:_titleLab];
        
        _selectBtn = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH-autoScaleW(35), (self.height-autoScaleW(20))/2.0, autoScaleW(20), autoScaleW(20))];
        _selectBtn.userInteractionEnabled = NO;
        [_selectBtn setBackgroundImage:[UIImage imageNamed:@"choose"] forState:UIControlStateNormal];
        [_selectBtn setBackgroundImage:[UIImage imageNamed:@"choose_active"] forState:UIControlStateSelected];
        [self addSubview:_selectBtn];
    }
    return self;
}

- (void)setContentWithModel:(XLGChangeServerModel *)model {
    
    _titleLab.text = model.title;
    
    BOOL selectStatus = model.selectStatus;
    if (selectStatus == YES) {
        _selectBtn.selected = YES;
    } else {
        _selectBtn.selected = NO;
    }
}

@end
