//
//  BaseNavBar.m
//  Chaozhi
//  Notes：
//
//  Created by Jason on 2018/5/7.
//  Copyright © 2018年 小灵狗出行. All rights reserved.
//

#import "BaseNavBar.h"

@implementation BaseNavBar

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (@available(iOS 11.0, *)) { //适配iOS11
        for (UIView *view in self.subviews) {
            //两个都要设置，还要判断是否为iPhone X
            if([view isKindOfClass:NSClassFromString(@"_UIBarBackground")]) {
                view.frame = CGRectMake(0, 0, WIDTH, kNavBarH);
            } else if ([view isKindOfClass:NSClassFromString(@"_UINavigationBarContentView")]) {
                view.frame = CGRectMake(0, kStatusBarH, WIDTH, kNavBarH-kStatusBarH);
            }
        }
    }
    
    self.translucent = NO;
    self.barTintColor = kWhiteColor;
    [self setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIColor blackColor], NSForegroundColorAttributeName,
      [UIFont systemFontOfSize:17], NSFontAttributeName, nil]];
    //将导航条默认黑线改成阴影
    [self setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
//    self.shadowImage = [UIImage imageNamed:@"NavbarShadow"]; //阴影图片
    self.shadowImage = [UIImage imageWithColor:[UIColor clearColor]];
}

@end
