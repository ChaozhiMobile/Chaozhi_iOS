//
//  AppDelegate+Push.h
//  ArtEast
//
//  Created by yibao on 16/9/26.
//  Copyright © 2016年 北京艺宝网络文化有限公司. All rights reserved.
//

/**
 *  激光推送类目
 *
 */

#import "AppDelegate.h"

@interface AppDelegate (Push)

-(void)registerPush:(UIApplication *)application options:(NSDictionary *)launchOptions;

@end
