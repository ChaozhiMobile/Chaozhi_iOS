//
//  BaseScrollView.m
//  Chaozhi
//  Notes：
//
//  Created by Jason on 2018/5/7.
//  Copyright © 2018年 小灵狗出行. All rights reserved.
//

#import "BaseScrollView.h"

@implementation BaseScrollView

- (BOOL)touchesShouldCancelInContentView:(UIView *)view
{
    [super touchesShouldCancelInContentView:view];
    //NO UIScrollView不可以滚动, YES UIScrollView可以滚动
    return YES;
}

@end
