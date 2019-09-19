//
//  NetworkDetector.h
//  TalkfunSDKDemo
//
//  Created by 孙兆能 on 16/8/4.
//  Copyright © 2016年 talk-fun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"

@interface NetworkDetector : NSObject

@property (nonatomic,copy) void (^networkChangeBlock)(NetworkStatus networkStatus);

- (void)networkcheck;

- (NetworkStatus)networkStatus;

@end
