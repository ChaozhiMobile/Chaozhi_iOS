//
//  BaseService.m
//  Chaozhi
//  Notes：
//
//  Created by Jason_hzb on 2018/5/29.
//  Copyright © 2018年 小灵狗出行. All rights reserved.
//

#import "BaseService.h"

@implementation BaseService

- (void)onFailMessage:(NSString *)msg withType:(ActionType)type{
    
    if ([self.delegate respondsToSelector:@selector(onFailure:withType:)]) {
        [self.delegate onFailure:msg withType:type];
    }
}

- (void)onSuccMessage:(id)data withType:(ActionType)type{
    
    if ([self.delegate respondsToSelector:@selector(onSuccess:withType:)]) {
        [self.delegate onSuccess:data withType:type];
    }
}

- (void)onSuccMessage:(id)data{
    
    if ([self.delegate respondsToSelector:@selector(onSuccess:)]) {
        [self.delegate onSuccess:data];
    }
}

- (void)onFailMessageWithType:(ActionType)type{
    
    if ([self.delegate respondsToSelector:@selector(onFailureWithType:)]) {
        [self.delegate onFailureWithType:type];
    }
}

- (void)onFailMessage{
    
    if ([self.delegate respondsToSelector:@selector(onFailure)]) {
        [self.delegate onFailure];
    }
}

@end
