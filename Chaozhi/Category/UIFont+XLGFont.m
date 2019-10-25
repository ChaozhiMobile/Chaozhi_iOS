//
//  UIFont+XLGFont.m
//  Chaozhi
//
//  Created by Jason_zyl on 2019/10/25.
//  Copyright © 2019 Jason_hzb. All rights reserved.
//

#import "UIFont+XLGFont.h"
#import <objc/runtime.h>

#define kScale MIN([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) / 375

@implementation UIFont (XLGFont)

+ (void)load {
    //保证线程安全
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        //拿到系统方法
        Method orignalMethod1 = class_getClassMethod(class, @selector(systemFontOfSize:));
        //拿到自己定义的方法
        Method myMethod1 = class_getClassMethod(class, @selector(test_systemFontOfSize:));
        //交换方法
        method_exchangeImplementations(orignalMethod1, myMethod1);
        
        //拿到系统方法
        Method orignalMethod2 = class_getClassMethod(class, @selector(systemFontOfSize:weight:));
        //拿到自己定义的方法
        Method myMethod2 = class_getClassMethod(class, @selector(test_systemFontOfSize:weight:));
        //交换方法
        method_exchangeImplementations(orignalMethod2, myMethod2);
    });
}

+ (UIFont *)test_systemFontOfSize:(CGFloat)fontSize {
    if (IsIPAD) {
        return [UIFont test_systemFontOfSize:fontSize*1.5];
    }
    return [UIFont test_systemFontOfSize:fontSize*kScale];
}

+ (UIFont *)test_systemFontOfSize:(CGFloat)fontSize weight:(UIFontWeight)weight {
    if (IsIPAD) {
        return [UIFont test_systemFontOfSize:fontSize*1.5 weight:weight];
    }
    return [UIFont test_systemFontOfSize:fontSize*kScale weight:weight];
}

@end
