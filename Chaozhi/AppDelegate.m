//
//  AppDelegate.m
//  Chaozhi
//
//  Created by Jason on 2018/5/2.
//  Copyright © 2018年 小灵狗出行. All rights reserved.
//

#import "AppDelegate.h"
#import "AppDelegate+Push.h"
#import "XZTabBarVC.h"
#import <IQKeyboardManager.h>
#import "NetworkUtil.h"
#import "CZGuideVC.h"
#import "UMMobClick/MobClick.h"
#import "DBManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [[DBManager shareManager] createDBAndTable];
    
    if ([AppChannel isEqualToString:@"1"]) { //超职
        [self iapCheck]; //内购凭证服务器二次校验，防止漏单
        [self registerUMeng]; //注册友盟
    }

    [Utils changeUserAgent]; //WKWebView UA初始化
    
    [self registerPush:application options:launchOptions]; //注册激光推送

    //监测网络
    [[NetworkUtil sharedInstance] listening];
    
    //键盘事件
    [self processKeyBoard];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = PageColor;

    //判断是否首次进入应用
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"FirstLG"])
    {
        //将CZGuideVC作为根视图控制器
        CZGuideVC *guideVC = [[CZGuideVC alloc] init];
        self.window.rootViewController = guideVC;
        
        //使用block获取点击图片事件
        [guideVC setDoneBlock:^(){
            NSLog(@"点击“进入”进入应用");
            //进入应用主界面
            self.window.rootViewController = [self setTabBarController];
        }];
    } else {
        self.window.rootViewController = [self setTabBarController];
    }
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

#pragma mark - 内购凭证校验
- (void)iapCheck {
    NSString *receipt = [CacheUtil getCacherWithKey:kIapCheck];
    if (![Utils isBlankString:receipt]) {
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                             receipt, @"receipt",
                             nil];
        [[NetworkManager sharedManager] postJSON:URL_IapPayCheck parameters:dic imageDataArr:nil imageName:nil  completion:^(id responseData, RequestState status, NSError *error) {
            
            if (status == Request_Success) {
                [Utils showToast:@"课程购买成功"];
                [CacheUtil saveCacher:kIapCheck withValue:@""];
            }
        }];
    }
}

#pragma mark - 注册友盟

- (void)registerUMeng {
    //初始化友盟统计
    UMConfigInstance.appKey = kUMKey;
    UMConfigInstance.channelId = @"App Store";
    [MobClick startWithConfigure:UMConfigInstance];//配置以上参数后调用此方法初始化SDK！
    
    //应用趋势分析(版本分布)
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
    
    //日志加密设置
    [MobClick setEncryptEnabled:YES]; //加密，默认为NO(不加密)
}

#pragma mark - 进入首页

- (UITabBarController *)setTabBarController {
    if ([AppChannel isEqualToString:@"1"]) { //超职
        //第一步：要获取单独控制器所在的UIStoryboard
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        //第二步：获取该控制器的Identifier并赋给你的单独控制器
        _tabVC = [story instantiateViewControllerWithIdentifier:@"TabBarController"];
    }
    if ([AppChannel isEqualToString:@"2"]) { //学智
        _tabVC = [[XZTabBarVC alloc] init];
    }
    _tabVC.delegate = self;
    
    return _tabVC;
}

- (void)processKeyBoard {
    
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    manager.enableAutoToolbar = NO;
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    
    //这里我判断的是当前点击的tabBarItem的标题
    NSString *tabBarTitle = viewController.tabBarItem.title;
    if ([tabBarTitle isEqualToString:@"我的"]
        || [tabBarTitle isEqualToString:@"学习"]
        ) {
        if ([Utils isLoginWithJump:YES]) {
            return YES;
        } else {
            return NO;
        }
    }
    else {
        return YES;
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
