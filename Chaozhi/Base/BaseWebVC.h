//
//  BaseWebVC.h
//  Chaozhi
//  Notes：WebView基类
//
//  Created by Jason on 2018/5/7.
//  Copyright © 2018年 小灵狗出行. All rights reserved.
//

#import "BaseVC.h"

@interface BaseWebVC : BaseVC

@property (nonatomic, assign) BOOL isShowWebTitle;
@property (strong, nonatomic) NSString *homeUrl;
@property (strong, nonatomic) NSString *webTitle;
@property (assign, nonatomic) BOOL isPresent;

/** 传入控制器、url、标题 H5获取参数*/
+ (void)showWithContro:(UIViewController *)contro withUrlStr:(NSString *)urlStr withTitle:(NSString *)title isPresent:(BOOL)isPresent;

@end
