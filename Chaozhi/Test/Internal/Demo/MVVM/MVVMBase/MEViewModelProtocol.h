//
//  MEViewModelProtocol.h
//  Health
//
//  Created by mingyue on 17/4/26.
//  Copyright © 2017年 huds. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    MEHeaderRefresh_HasMoreData = 1,
    MEHeaderRefresh_HasNoMoreData,
    MEFooterRefresh_HasMoreData,
    MEFooterRefresh_HasNoMoreData,
    MERefreshError,
    MERefreshUI,
} MERefreshDataStatus;

@protocol MEViewModelProtocol <NSObject>

- (void)me_initialize;

@end
