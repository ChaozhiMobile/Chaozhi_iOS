//
//  Public.h
//  Chaozhi
//
//  Created by Jason_zyl on 2019/7/28.
//  Copyright © 2019 Jason_hzb. All rights reserved.
//

#ifndef Public_h
#define Public_h

/****************************头文件*****************************/

#import "AppDelegate.h"
#import "BaseVC.h"
#import "BaseWebVC.h"
#import <UIImageView+WebCache.h>
#import <UIButton+WebCache.h>
#import "Utils.h"
#import "CacheUtil.h"
#import "ReactiveObjC.h"
#import "Masonry.h"
#import <XLGCategory.h>
#import "UserInfo.h"
#import "Config.h"
#import "NetworkManager.h"
#import "JHHJView.h"
#import "XLGLottie.h"
#import <MJExtension.h>
#import <MJRefresh.h>
#import "XLGAlertView.h"
#import "Talkfun.h"

// AppDelegate
#define CZAppDelegate ((AppDelegate *)[UIApplication sharedApplication].delegate)
#define kCachePath [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject]

/******************************keys****************************/

// 网络请求key
#define kSignKey   @"ghOwfR7Wz44cbKU93KVSxwYXPGloNu"
#define kNonceStr  [SignKeyUtil getNonceString]

// cache key
#define kIapCheck @"IapCheck"
#define kServerKey @"ServerKey"
#define kWifiKey   @"WifiKey"
#define kSelectCourseIDKey   @"SelectCourseIDKey"

/******************************通知****************************/

#define kLoginSuccNotification  @"kLoginSuccNotification"
#define kLogoutSuccNotification  @"kLogoutSuccNotification"
#define kUserInfoChangeNotification  @"kUserInfoChangeNotification"
#define kChangeServerSuccNotification  @"kChangeServerSuccNotification"

/********************屏幕宽高、系统版本、手机型号******************/

#define SCREEN_BOUNDS [[UIScreen mainScreen] bounds]
#define WIDTH  [[UIScreen mainScreen] bounds].size.width
#define HEIGHT [[UIScreen mainScreen] bounds].size.height
#define kNavBarH (IS_IPhoneX?88:64)
#define kStatusBarH (IS_IPhoneX?44:20)
#define kTabBarH (IS_IPhoneX?83:49)
#define kTabBarSafeH (IS_IPhoneX?34:0)
#define IS_IOS_11 ([[[UIDevice currentDevice] systemVersion] floatValue]>=11.0)
#define IS_IPhoneX (CGSizeEqualToSize(CGSizeMake(375.f, 812.f), [UIScreen mainScreen].bounds.size) || CGSizeEqualToSize(CGSizeMake(812.f, 375.f), [UIScreen mainScreen].bounds.size))

// 控件宽高、字体适配
#define autoScaleW(width) (float)width / 375 * WIDTH
#define autoScaleH(height) (float)height / 667 * HEIGHT

/*****************************系统版本***************************/

// 判断是否是IOS7
#define IS_IOS_7  ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0 ? YES : NO)
// 判断是否是IOS8
#define IS_IOS_8  ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0 ? YES : NO)
// 判断是否是IOS9
#define IS_IOS_9  ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0 ? YES : NO)
// 判断是否是IOS10
#define IS_IOS_10 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0 ? YES : NO)

/*****************************APP信息***************************/

// app版本
#define AppVersion      [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
// app build版本
#define AppBuildVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]
// app名称
#define AppName         [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"]
// appChannel  1超职 2学智
#define AppChannel      [[[NSBundle mainBundle] infoDictionary] objectForKey:@"channel"]
// 当前系统语言
#define CurrentLanguage ([[NSLocale preferredLanguages] objectAtIndex:0])

#if TARGET_IPHONE_SIMULATOR //模拟器
#define IS_SIMULATOR YES
#elif TARGET_OS_IPHONE      //真机
#define IS_SIMULATOR NO
#endif

/*****************************颜色*****************************/

#define RGB(r,g,b) [UIColor colorWithRed:(float)r/255.0f green:(float)g/255.0f blue:(float)b/255.0f alpha:1.0f]
#define RGBA(r,g,b,a) [UIColor colorWithRed:(float)r/255.0f green:(float)g/255.0f blue:(float)b/255.0f alpha:a]
#define RGBValue(value) [UIColor colorWithRed:((float)((value & 0xFF0000) >> 16))/255.0 green:((float)((value & 0xFF00) >> 8))/255.0 blue:((float)(value & 0xFF))/255.0 alpha:1.0]
#define RGBAValue(value,a) [UIColor colorWithRed:((float)((value & 0xFF0000) >> 16))/255.0 green:((float)((value & 0xFF00) >> 8))/255.0 blue:((float)(value & 0xFF))/255.0 alpha:a] //a:透明度

#define PageColor RGBValue(0xF5F5F5)
#define kTitleColor RGBValue(0x030303)
#define kShadowColor RGBValue(0x24709C)
#define kBlueColor RGBValue(0x00A8FF)
#define kGreenColor RGBValue(0x7AD300)
#define kLightBlackColor [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8]
#define kLineColor RGBValue(0xEEEEEE)
#define kWhiteColor RGBValue(0xFFFFFF)
#define kBlackColor RGBValue(0x000000)
#define kBorderGrayColor RGBValue(0xCCCCCC)
#define TableViewDefaultBGColor RGBValue(0xfafafa) // 默认背景颜色
#define kSeparatorColor RGB(235,235,235) // 分割线颜色
#define kBlack55Color RGBValue(0x555555)
#define kGrayB5Color RGBValue(0xB5B5B5)

#ifdef DEBUG
#define KOnline NO

#else
#define KOnline YES
#endif

/**
 *  完美解决Xcode NSLog打印不全的宏
 */
#ifdef DEBUG
#define NSLog(...) printf("%f %s\n",[[NSDate date]timeIntervalSince1970],[[NSString stringWithFormat:__VA_ARGS__]UTF8String]);
#else
#define NSLog(format, ...)
#endif

#endif /* Public_h */
