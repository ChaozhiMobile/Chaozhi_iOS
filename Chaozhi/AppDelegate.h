//
//  AppDelegate.h
//  Chaozhi
//
//  Created by Jason on 2018/5/2.
//  Copyright © 2018年 小灵狗出行. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "AFNetworking.h"

#define Key_UserInfo_Appid @"Key_UserInfo_Appid"
#define Key_UserInfo_User  @"Key_UserInfo_User"
#define Key_UserInfo_Pwd   @"Key_UserInfo_Pwd"
#define Key_UserInfo_Sig   @"Key_UserInfo_Sig"

#define sdkBusiId         12742

@interface AppDelegate : UIResponder <UIApplicationDelegate,UITabBarControllerDelegate>

@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, retain) UITabBarController *tabVC;
@property (nonatomic, assign) AFNetworkReachabilityStatus status;
@property (nonatomic, strong) NSData *deviceToken; //腾讯im

- (UIViewController *)getLoginController;
- (UITabBarController *)getMainController;

@end

