//
//  AppDelegate+Push.m
//  ArtEast
//
//  Created by yibao on 16/9/26.
//  Copyright © 2016年 北京艺宝网络文化有限公司. All rights reserved.
//

#import "AppDelegate+Push.h"
#import <JPUSHService.h>
#import "BaseWebVC.h"

@implementation AppDelegate (Push)

-(void)registerPush:(UIApplication *)application options:(NSDictionary *)launchOptions
{
    [application registerForRemoteNotifications];
    UIUserNotificationType notificationTypes = UIUserNotificationTypeBadge |
    UIUserNotificationTypeSound |
    UIUserNotificationTypeAlert;
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:notificationTypes categories:nil];
    [application registerUserNotificationSettings:settings];
    
    //可以添加自定义categories【激光推送】
    [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                      UIUserNotificationTypeSound |
                                                      UIUserNotificationTypeAlert)
                                          categories:nil];
    
    NSString *pushAppKey = kPushKey;
    NSString *pushChanne = @"iOS";
    
    if (KOnline || [Utils getServer] == 1) {
        // 生产环境
        [JPUSHService setupWithOption:launchOptions appKey:pushAppKey channel:pushChanne apsForProduction:YES];
    } else {
        // 开发环境
        [JPUSHService setupWithOption:launchOptions appKey:pushAppKey channel:pushChanne apsForProduction:NO];
    }

    [JPUSHService setLogOFF]; //关闭日志
}
#pragma mark 极光推送

-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [JPUSHService registerDeviceToken:deviceToken];
    self.deviceToken = deviceToken;
}

// 注册deviceToken失败
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    NSLog(@"error -- %@",error);
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    [UIApplication sharedApplication].applicationIconBadgeNumber=0;
    [JPUSHService setBadge:0];
}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    [application registerForRemoteNotifications];
}

/*
 * 有些手机只走这个通道
 */
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [JPUSHService handleRemoteNotification:userInfo];
    [self didRecevieNotification:userInfo andState:application.applicationState];
}

/*
 * 正常通道
 */
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
    [self didRecevieNotification:userInfo andState:application.applicationState];
}

//处理收到的提醒
-(void)didRecevieNotification:(NSDictionary *)receiveNotifi andState:(UIApplicationState)state
{
    //双标题
//    {
//        _j_business : 1,
//        value : http://test-aci-api.chaozhiedu.com/api/user/teacher,
//        _j_uid : 22722674451,
//        _j_msgid : 67553998918834363,
//        type : h5_myteacher,
//        aps : {
//            alert : {
//                title : title,
//                body : hello 超职班主任消息96
//            },
//            badge : 2,
//            sound :
//        }
//    }
    
    //单标题
//    {
//        aps : {
//            alert : hello 超职班主任消息81,
//            badge : 1,
//            sound :
//        },
//        value : http://test-aci-api.chaozhiedu.com/api/user/teacher,
//        _j_uid : 22722674451,
//        _j_msgid : 3279450862,
//        type : h5_myteacher,
//        _j_business : 1
//    }
    NSLog(@"后台推送消息：%@",receiveNotifi);
    
    //在这里做消息处理...
    NSString *type=receiveNotifi[@"type"];
    NSString *value=receiveNotifi[@"value"];
    
    if (state == UIApplicationStateActive) { //前台运行
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"您有一条新的推送消息" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:([UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }])];
        [alertController addAction:([UIAlertAction actionWithTitle:@"查看" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self jumpAction:type andValue:value];
        }])];
        [self.window.rootViewController presentViewController:alertController animated:true completion:nil];
    } else { //后台运行或者程序没启动
        [self jumpAction:type andValue:value];
    }
}

//点击通知页面跳转处理
- (void)jumpAction:(NSString *)type andValue:(NSString *)value {
    
    if ([type isEqualToString:@"version"]) { //版本更新
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:value]]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:value]];
        }
    }
    
    if ([type isEqualToString:@"h5_myteacher"]) { //我的班主任
        if ([Utils isLoginWithJump:YES]) {
            NSString *url = [NSString stringWithFormat:@"%@?token=%@",value,[UserInfo share].token];
            [BaseWebVC showWithContro:self.window.rootViewController withUrlStr:url withTitle:@"我的班主任" isPresent:YES];
        }
    }
    
    if ([type isEqualToString:@"h5_message"]) { //我的消息
        if ([Utils isLoginWithJump:YES]) {
            [BaseWebVC showWithContro:self.window.rootViewController withUrlStr:value withTitle:@"我的消息" isPresent:YES];
        }
    }
}

@end
