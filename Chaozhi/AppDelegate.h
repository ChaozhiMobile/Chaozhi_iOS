//
//  AppDelegate.h
//  Chaozhi
//
//  Created by Jason on 2018/5/2.
//  Copyright © 2018年 小灵狗出行. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

//控件宽高字体大小适配方法
- (CGFloat)autoScaleW:(CGFloat)w;
- (CGFloat)autoScaleH:(CGFloat)h;

@end

