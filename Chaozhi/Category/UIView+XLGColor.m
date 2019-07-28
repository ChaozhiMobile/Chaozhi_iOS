//
//  UIView+XLGColor.m
//  Chaozhi
//
//  Created by Jason_zyl on 2019/7/28.
//  Copyright © 2019 Jason_hzb. All rights reserved.
//

#import "UIView+XLGColor.h"

@implementation UIView (XLGColor)

- (UIColor *)bgThemeColor {
    return AppThemeColor;
}

- (void)setBgThemeColor:(UIColor *)bgThemeColor {
    self.backgroundColor = AppThemeColor; // 在这里将颜色改为自己的主题色
}

@end
