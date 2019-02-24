//
//  MEViewModel.m
//  Health
//
//  Created by mingyue on 17/4/26.
//  Copyright © 2017年 huds. All rights reserved.
//

#import "MEViewModel.h"

@implementation MEViewModel

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    
    MEViewModel *viewModel = [super allocWithZone:zone];
    
    if (viewModel) {
        [viewModel me_initialize];
    }
    return viewModel;
}

// 用M初始化VM
- (instancetype)initWithModel:(id)model {
    
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)me_initialize {
    
}

@end
