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
#import "NTESClientUtil.h"
#import "NTESSessionUtil.h"
#import "NTESLoginManager.h"
#import "NTESNotificationCenter.h"
#import "NTESSDKConfigDelegate.h"
#import "NTESPrivatizationManager.h"
#import "NTESBundleSetting.h"
#import "NTESSubscribeManager.h"
#import "NTESCustomAttachmentDecoder.h"
#import "NTESCellLayoutConfig.h"

NSString *NTESNotificationLogout = @"NTESNotificationLogout";

@interface AppDelegate ()<NIMLoginManagerDelegate>

@property (nonatomic,strong) NTESSDKConfigDelegate *sdkConfigDelegate;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [[DBManager shareManager] createDBAndTable];
    
    [self iapCheck]; //内购凭证服务器二次校验，防止漏单
    
    if ([AppChannel isEqualToString:@"1"]) { //超职
        [self registerUMeng]; //注册友盟
        [self registerIM]; //注册云信
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

#pragma mark - UITabBarControllerDelegate
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

#pragma mark - 键盘处理
- (void)processKeyBoard {
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    manager.enableAutoToolbar = NO;
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
    //日志开启
    [MobClick setLogEnabled:YES];
}

#pragma mark - 注册云信
- (void)registerIM {
    [self setupNIMSDK];
    [self setupServices];
    [self commonInitListenEvents];
    [self autoLogin];
}

//SDK初始化
- (void)setupNIMSDK {
    // 私有化配置检查
    [[NTESPrivatizationManager sharedInstance] setupPrivatization];
    
    //配置额外配置信息 （需要在注册 appkey 前完成
    self.sdkConfigDelegate = [[NTESSDKConfigDelegate alloc] init];
    [[NIMSDKConfig sharedConfig] setDelegate:self.sdkConfigDelegate];
    [[NIMSDKConfig sharedConfig] setShouldSyncUnreadCount:YES];
    [[NIMSDKConfig sharedConfig] setMaxAutoLoginRetryTimes:10];
    [[NIMSDKConfig sharedConfig] setMaximumLogDays:[[NTESBundleSetting sharedConfig] maximumLogDays]];
    [[NIMSDKConfig sharedConfig] setShouldCountTeamNotification:[[NTESBundleSetting sharedConfig] countTeamNotification]];
    [[NIMSDKConfig sharedConfig] setAnimatedImageThumbnailEnabled:[[NTESBundleSetting sharedConfig] animatedImageThumbnailEnabled]];
    [[NIMSDKConfig sharedConfig] setFetchAttachmentAutomaticallyAfterReceiving:[[NTESBundleSetting sharedConfig] autoFetchAttachment]];
    [[NIMSDKConfig sharedConfig] setFetchAttachmentAutomaticallyAfterReceivingInChatroom:[[NTESBundleSetting sharedConfig] autoFetchAttachment]];
    
    //多端登录时，告知其他端，这个端的登录类型，目前对于android的TV端，手表端使用。
    [[NIMSDKConfig sharedConfig] setCustomTag:[NSString stringWithFormat:@"%ld",(long)NIMLoginClientTypeiOS]];
    
    //appkey 是应用的标识，不同应用之间的数据（用户、消息、群组等）是完全隔离的。
    //如需打网易云信 Demo 包，请勿修改 appkey ，开发自己的应用时，请替换为自己的 appkey 。
    //并请对应更换 Demo 代码中的获取好友列表、个人信息等网易云信 SDK 未提供的接口。
    NSString *appKey        = @"96d485fd77d30186a806e443589191c7";
    NIMSDKOption *option    = [NIMSDKOption optionWithAppKey:appKey];
    option.apnsCername      = @"";
    option.pkCername        = @"";
    
    [[NIMSDK sharedSDK] registerWithOption:option];
    
    //注册自定义消息的解析器
    [NIMCustomObject registerCustomDecoder:[NTESCustomAttachmentDecoder new]];
    
    //注册 NIMKit 自定义排版配置
    [[NIMKit sharedKit] registerLayoutConfig:[NTESCellLayoutConfig new]];
    
    BOOL isUsingDemoAppKey = [[NIMSDK sharedSDK] isUsingDemoAppKey];
    [[NIMSDKConfig sharedConfig] setTeamReceiptEnabled:isUsingDemoAppKey];
    
    //场景配置
    NSDictionary *dict = @{@"nim_custom1":@1};
    NSMutableDictionary *dict1 = [NIMSDK sharedSDK].sceneDict;
    [NIMSDK sharedSDK].sceneDict = (NSMutableDictionary *)dict;
    NSMutableDictionary *dict2 = [NIMSDK sharedSDK].sceneDict;
    NSLog(@"%@,%@",dict1,dict2);
}

//云信服务
- (void)setupServices {
    [[NTESNotificationCenter sharedCenter] start];
    [[NTESSubscribeManager sharedManager] start];
}

//登录监听
- (void)commonInitListenEvents {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(logout:)
                                                 name:NTESNotificationLogout
                                               object:nil];
    [[[NIMSDK sharedSDK] loginManager] addDelegate:self];
}

//自动登录
- (void)autoLogin {
    NTESLoginData *data = [[NTESLoginManager sharedManager] currentLoginData];
    NSString *account = [data account];
    NSString *token = [data token];
    //如果有缓存用户名密码推荐使用自动登录
    if ([account length] && [token length]) {
        NIMAutoLoginData *loginData = [[NIMAutoLoginData alloc] init];
        loginData.account = account;
        loginData.token = token;
        [[[NIMSDK sharedSDK] loginManager] autoLogin:loginData];
        [[NTESServiceManager sharedManager] start];
    }
}

- (void)userPreferencesConfig {
    [[NIMSDKConfig sharedConfig] setFetchAttachmentAutomaticallyAfterReceiving:[[NTESBundleSetting sharedConfig] autoFetchAttachment]];
    [[NIMSDKConfig sharedConfig] setFetchAttachmentAutomaticallyAfterReceivingInChatroom:[[NTESBundleSetting sharedConfig] autoFetchAttachment]];
    [[NIMSDKConfig sharedConfig] setFileQuickTransferEnabled:[[NTESBundleSetting sharedConfig] fileQuickTransferEnabled]];
    [NIMSDKConfig sharedConfig].audioSessionResetEnabled =  [[NTESBundleSetting sharedConfig] enableAudioSessionReset];
    [[NIMSDKConfig sharedConfig] setValue:@([[NTESBundleSetting sharedConfig] exceptionLogUploadEnabled]) forKey:@"exceptionOptimizationEnabled"];
}

#pragma mark - 注销
- (void)logout:(NSNotification *)note {
    [Utils logout:YES];
    [[NTESLoginManager sharedManager] setCurrentLoginData:nil];
    [[NTESServiceManager sharedManager] destory];
}

#pragma - NIMLoginManagerDelegate
- (void)onKick:(NIMKickReason)code clientType:(NIMLoginClientType)clientType {
    NSString *reason = @"你被踢下线";
    switch (code) {
        case NIMKickReasonByClient:
        case NIMKickReasonByClientManually:{
            NSString *clientName = [NTESClientUtil clientName:clientType];
            reason = clientName.length ? [NSString stringWithFormat:@"你的帐号被%@端踢出下线，请注意帐号信息安全",clientName] : @"你的帐号被踢出下线，请注意帐号信息安全";
            break;
        }
        case NIMKickReasonByServer:
            reason = @"你被服务器踢下线";
            break;
        default:
            break;
    }
    [[[NIMSDK sharedSDK] loginManager] logout:^(NSError *error) {
        [[NSNotificationCenter defaultCenter] postNotificationName:NTESNotificationLogout object:nil];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"下线通知" message:reason delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }];
}

- (void)onAutoLoginFailed:(NSError *)error {
    //只有连接发生严重错误才会走这个回调，在这个回调里应该登出，返回界面等待用户手动重新登录。
    NSLog(@"onAutoLoginFailed %zd",error.code);
    [self showAutoLoginErrorAlert:error];
}

#pragma mark - 登录错误回调
- (void)showAutoLoginErrorAlert:(NSError *)error
{
    NSString *message = [NTESSessionUtil formatAutoLoginMessage:error];
    UIAlertController *vc = [UIAlertController alertControllerWithTitle:@"自动登录失败"
                                                                message:message
                                                         preferredStyle:UIAlertControllerStyleAlert];
    
    if ([error.domain isEqualToString:NIMLocalErrorDomain] &&
        error.code == NIMLocalErrorCodeAutoLoginRetryLimit)
    {
        UIAlertAction *retryAction = [UIAlertAction actionWithTitle:@"重试"
                                                              style:UIAlertActionStyleCancel
                                                            handler:^(UIAlertAction * _Nonnull action) {
                                                                NTESLoginData *data = [[NTESLoginManager sharedManager] currentLoginData];
                                                                NSString *account = [data account];
                                                                NSString *token = [data token];
                                                                if ([account length] && [token length])
                                                                {
                                                                    NIMAutoLoginData *loginData = [[NIMAutoLoginData alloc] init];
                                                                    loginData.account = account;
                                                                    loginData.token = token;
                                                                    
                                                                    [[[NIMSDK sharedSDK] loginManager] autoLogin:loginData];
                                                                }
                                                            }];
        [vc addAction:retryAction];
    }
    
    UIAlertAction *logoutAction = [UIAlertAction actionWithTitle:@"注销"
                                                           style:UIAlertActionStyleDestructive
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                             [[[NIMSDK sharedSDK] loginManager] logout:^(NSError *error) {
                                                                 [[NSNotificationCenter defaultCenter] postNotificationName:NTESNotificationLogout object:nil];
                                                             }];
                                                         }];
    [vc addAction:logoutAction];
    
    [self.window.rootViewController presentViewController:vc
                                                 animated:YES
                                               completion:nil];
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
    [self userPreferencesConfig];
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[[NIMSDK sharedSDK] loginManager] removeDelegate:self];
}

@end
