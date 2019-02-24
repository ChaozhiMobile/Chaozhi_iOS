//
//  Utils.m
//  Chaozhi
//  Notes：
//
//  Created by Jason on 2018/5/7.
//  Copyright © 2018年 小灵狗出行. All rights reserved.
//

#import "Utils.h"
#import "Toast.h"
#import "NetworkUtil.h"
#import "BaseNC.h"

@interface Utils ()
{
    UIColor *_btnNormalColor; //按钮正常颜色
    UIColor *_btnSelectedColor; //按钮选中颜色
    UIColor *_btnBorderNormalColor; //按钮边框正常颜色
    UIColor *_btnBorderSelectedColor; //按钮边框选中颜色
}
@end

static Utils *_utils = nil;

@implementation Utils

/**
 类单例方法

 @return 类实例
 */
+ (instancetype)share {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _utils = [[Utils alloc] init];
    });
    return _utils;
}

/**
 存放服务器环境
 */
+ (void)setServer:(NSInteger)server {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setInteger:server forKey:kServerKey];
}

/**
 获取服务器环境
 */
+ (NSInteger)getServer {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults integerForKey:kServerKey];
}

/**
 存放是否在非Wifi情况下播放视频状态
 */
+ (void)setWifi:(BOOL)wifi {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:wifi forKey:kWifiKey];
}

/**
 获取是否在非Wifi情况下播放视频状态
 */
+ (BOOL)getWifi {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults boolForKey:kWifiKey];
}

/**
 判断网络状态

 @return YES 有网
 */
+ (BOOL)getNetStatus {
    if ([NetworkUtil currentNetworkStatus] != NotReachable) { //有网
        return YES;
    } else {
        return NO;
    }
}

/**
 获取当前时间

 @return 1990-09-18 12:23:22
 */
+ (NSString *)getCurrentDate {
    NSDate *date = [NSDate date];
    NSDateFormatter *fom = [[NSDateFormatter alloc]init];
    fom.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    return [fom stringFromDate:date];
}

/**
 获取当前控制器

 @return 当前控制器
 */
+ (UIViewController *)getCurrentVC {
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]]) {
        if([nextResponder isKindOfClass:[UITabBarController class]]) {
            UITabBarController *tab = nextResponder;
            BaseNC *nc = tab.selectedViewController;
            result = nc.topViewController;
        } else {
            result = nextResponder;
        }
    }
    else {
        result = window.rootViewController;
    }

    return result;
}

/**
 1、判断是否登录，2、是否跳转到登录页面

 @param isJump YES：跳转
 @return YES：登录
 */
+ (BOOL)isLoginWithJump:(BOOL)isJump{
    
    if (![Utils isBlankString:[UserInfo share].token]) {
        return YES;
    } else {
        if (isJump==YES) {
            //跳转到登录页面
            UIViewController *vc = [Utils getViewController:@"Main" WithVCName:@"CZLoginVC"];
            vc.hidesBottomBarWhenPushed = YES;
            [[self getCurrentVC].navigationController pushViewController:vc animated:YES];
        }
        return NO;
    }
}

/**
 1、退出登录，2、是否跳转到登录页面

 @param isJumpLoginVC YES：跳转
 */
+ (void)logout:(BOOL)isJumpLoginVC {
    
    [[UserInfo share] setUserInfo:nil]; //清除用户信息
    
    if (isJumpLoginVC==YES) {
        //跳转到登录页面
        UIViewController *vc = [Utils getViewController:@"Main" WithVCName:@"CZLoginVC"];
        vc.hidesBottomBarWhenPushed = YES;
        [[self getCurrentVC].navigationController pushViewController:vc animated:YES];
    }
}

/**
 判断字符串是否为空

 @param string 字符串
 @return YES 空
 */
+ (BOOL)isBlankString:(id)string {
    
    string = [NSString stringWithFormat:@"%@",string];
    
    if (string == nil) {
        return YES;
    }
    if (string == NULL) {
        return YES;
    }
    if ([string isEqual:[NSNull null]]) {
        return YES;
    }
    if ([string isEqualToString:@"(null)"]) {
        return YES;
    }
    if ([string isEqualToString:@"null"]) {
        return YES;
    }
    if([string isEqualToString:@"<null>"])
    {
        return YES;
    }
    if ([string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length==0) {
        return YES;
    }
    return NO;
}

/**
 仿安卓消息提示

 @param message 提示内容
 */
+ (void)showToast:(NSString *)message {
    [Toast showBottomWithText:message bottomOffset:HEIGHT/2 duration:1.5];
}

// 验证手机号
+ (BOOL)validateMobile:(NSString *)mobile {
    
    NSString *mobileRegex = @"^1[0123456789]\\d{9}$";
    NSPredicate *mobileTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", mobileRegex];
    return [mobileTest evaluateWithObject:mobile];
}

/**
 设置控件阴影

 @param view 视图View
 */
+ (void)setViewShadowStyle:(UIView *)view {
    view.layer.shadowOffset =  CGSizeMake(0, 2); //阴影偏移量
    view.layer.shadowOpacity = 0.2; //透明度
    view.layer.shadowColor =  kShadowColor.CGColor; //阴影颜色
    view.layer.shadowRadius = 5; //模糊度
    view.layer.shadowPath = [[UIBezierPath bezierPathWithRect:view.bounds] CGPath];
    [view.layer setMasksToBounds:NO];
}

/**
 设置按钮显示、点击效果

 @param btn 按钮
 @param shadow 是否显示阴影
 @param normalBorderColor 正常边框颜色
 @param selectedBorderColor 选中边框颜色
 @param borderWidth 边框宽度
 @param normalColor 正常按钮颜色
 @param selectedColor 选中按钮颜色
 @param radius 圆角
 */
- (void)setButtonClickStyle:(UIButton *)btn Shadow:(BOOL)shadow normalBorderColor: (UIColor *)normalBorderColor selectedBorderColor: (UIColor *)selectedBorderColor BorderWidth:(int)borderWidth normalColor:(UIColor *)normalColor selectedColor:(UIColor *)selectedColor cornerRadius:(CGFloat)radius {
    
    _btnNormalColor = normalColor;
    _btnSelectedColor = selectedColor;
    _btnBorderNormalColor =normalBorderColor;
    _btnBorderSelectedColor =selectedBorderColor;
    btn.layer.borderColor =normalBorderColor.CGColor;
    [btn.layer setBorderWidth:borderWidth];
    btn.backgroundColor = normalColor;
    btn.layer.cornerRadius = radius;
    if (shadow == YES) {
        [Utils setViewShadowStyle:btn];
    }
    [btn addTarget:self action:@selector(downClick:) forControlEvents:UIControlEventTouchDown];
    [btn addTarget:self action:@selector(doneClick:) forControlEvents:UIControlEventTouchUpOutside];
}

- (void)downClick:(UIButton *)button {
    button.layer.borderColor = _btnBorderSelectedColor.CGColor;
    button.backgroundColor = _btnSelectedColor;
    [button.layer setMasksToBounds:YES];
}

- (void)doneClick:(UIButton *)button {
    button.layer.borderColor = _btnBorderNormalColor.CGColor;
    button.backgroundColor = _btnNormalColor;
    [button.layer setMasksToBounds:NO];
}

/**
 屏幕快照

 @param view 视图View
 @return 屏幕截图
 */
+ (UIImage *)snapshotSingleView:(UIView *)view {
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, YES, 0);
    [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:YES];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+(UIViewController *)getViewController:(NSString *)stordyName WithVCName:(NSString *)name{
    UIStoryboard *story = [UIStoryboard storyboardWithName:stordyName bundle:nil];
    return [story instantiateViewControllerWithIdentifier:name];
}

@end
