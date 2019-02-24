//
//  NetworkUtil.h
//  SharenGo
//  Notes：网络监测工具类
//
//  Created by Jason on 2018/5/9.
//  Copyright © 2018年 小灵狗出行. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"

@interface NetworkUtil : NSObject

@property (nonatomic) Reachability *hostReachability;

/**
 *  判断当前网络状态
 *
 *  @return 网络状态
 */
+ (NetworkStatus)currentNetworkStatus;

/**
 *  网络实时监听
 */
- (void)listening;

+ (NetworkUtil *)sharedInstance;

@end
