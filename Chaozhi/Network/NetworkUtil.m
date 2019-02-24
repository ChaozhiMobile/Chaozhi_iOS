//
//  NetworkUtil.m
//  SharenGo
//  Notes：
//
//  Created by Jason on 2018/5/9.
//  Copyright © 2018年 小灵狗出行. All rights reserved.
//

#import "NetworkUtil.h"

static NetworkUtil *_instance;

@implementation NetworkUtil

+ (NetworkUtil *)sharedInstance
{
    static dispatch_once_t predicate ;
    dispatch_once(&predicate , ^{
        _instance = [[NetworkUtil alloc] init];
    });
    return _instance;
}

- (void)listening {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    NSString *remoteHostName = @"www.apple.com";
    self.hostReachability = [Reachability reachabilityWithHostName:remoteHostName];
    [self.hostReachability startNotifier];
}

/*!
 * Called by Reachability whenever status changes.
 */
- (void)reachabilityChanged:(NSNotification *)note
{
    Reachability *reachability = [note object];
    NSParameterAssert([reachability isKindOfClass:[Reachability class]]);
    NetworkStatus netStatus = [reachability currentReachabilityStatus];
    
    switch (netStatus) {
        case NotReachable:{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"kNetDisAppear" object:nil];
            break;
        }
        case ReachableViaWWAN:{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"kNetAppear" object:nil];
            break;
        }
        case ReachableViaWiFi:{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"kNetAppear" object:nil];
            break;
        }
    }
}

+ (NetworkStatus)currentNetworkStatus {
    Reachability *reach = [Reachability reachabilityForInternetConnection];
    return [reach currentReachabilityStatus];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
}

@end
