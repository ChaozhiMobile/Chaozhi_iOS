//
//  UILabel+XLGColor.m
//  Chaozhi
//
//  Created by Jason_zyl on 2019/7/28.
//  Copyright © 2019 Jason_hzb. All rights reserved.
//

#import "UILabel+XLGColor.h"

@implementation UILabel (XLGColor)

- (UIColor *)textThemeColor {
    return AppThemeColor;
}

- (void)setTextThemeColor:(UIColor *)textThemeColor {
    self.textColor = AppThemeColor; // 在这里将颜色改为自己的主题色
}

@end
