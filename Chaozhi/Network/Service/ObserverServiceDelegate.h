//
//  ObserverServiceDelegate.h
//  Chaozhi
//  Notes：
//
//  Created by Jason_hzb on 2018/5/29.
//  Copyright © 2018年 小灵狗出行. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ActionType.h"

@protocol ObserverServiceDelegate <NSObject>

@optional
- (void)onSuccess:(id)data;
- (void)onSuccess:(id)data withType:(ActionType)type;
- (void)onFailure;
- (void)onFailureWithType:(ActionType)type;
- (void)onFailure:(NSString *)msg withType:(ActionType)type;
- (void)onSuccwithType:(ActionType)type withProgress:(CGFloat)Progress;

@end
