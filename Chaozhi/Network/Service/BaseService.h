//
//  BaseService.h
//  Chaozhi
//  Notes：service基类
//
//  Created by Jason_hzb on 2018/5/29.
//  Copyright © 2018年 小灵狗出行. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ObserverServiceDelegate.h"
#import "SignKeyUtil.h"
#import "CommonRequest.h"
#import "UrlConfig.h"

@interface BaseService : NSObject

@property(nonatomic,weak) id<ObserverServiceDelegate> delegate;

- (void)onSuccMessage:(id)data withType:(ActionType)type;
- (void)onFailMessage:(NSString *)msg withType:(ActionType)type;
- (void)onSuccMessage:(id)data;
- (void)onFailMessage;
- (void)onFailMessageWithType:(ActionType)type;

@end
