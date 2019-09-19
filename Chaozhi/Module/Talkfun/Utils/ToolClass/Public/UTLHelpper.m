//
//  UTLHelpper.m
//  测试网络2
//
//  Created by air on 15/7/17.
//  Copyright (c) 2015年 chl. All rights reserved.
//

#import "UTLHelpper.h"

@implementation UTLHelpper
+ (BOOL)NetWorkIsOK//检查网络是否可用
{
    if(
       ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus]
        != NotReachable)
       &&
       ([[Reachability reachabilityWithHostName:@"www.baidu.com"] currentReachabilityStatus]
        != NotReachable)
       ){
        return YES;
    }else{
        return NO;
    }
}
 
@end
