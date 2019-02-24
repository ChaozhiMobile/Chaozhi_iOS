//
//  CZNotDataView.m
//  Chaozhi
//
//  Created by Jason_zyl on 2018/10/29.
//  Copyright © 2018年 Jason_hzb. All rights reserved.
//

#import "CZNotDataView.h"

@implementation CZNotDataView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = PageColor;
        
        [self initView];
    }
    return self;
}

#pragma mark - init view

- (void)initView {
    self.iconImgView = [[UIImageView alloc] initWithFrame:CGRectMake((WIDTH-autoScaleW(150))/2, autoScaleW(112), autoScaleW(150), autoScaleW(150))];
    self.iconImgView.image = [UIImage imageNamed:@"icon_no book"];
    [self addSubview:self.iconImgView];
    
    self.lab1 = [[UILabel alloc] initWithFrame:CGRectMake(0, self.iconImgView.bottom+autoScaleW(18), WIDTH, autoScaleW(20))];
    self.lab1.font = [UIFont systemFontOfSize:12 weight:UIFontWeightMedium];
    self.lab1.textColor = RGBValue(0x565454);
    self.lab1.text = @"您还没有购买课程";
    self.lab1.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.lab1];
    
    self.lab2 = [[UILabel alloc] initWithFrame:CGRectMake(0, self.lab1.bottom+autoScaleW(8), WIDTH, autoScaleW(20))];
    self.lab2.font = [UIFont systemFontOfSize:12 weight:UIFontWeightMedium];
    self.lab2.textColor = RGBValue(0xB4B4B4);
    self.lab2.text = @"看看有什么想学的吧";
    self.lab2.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.lab2];
}

@end
