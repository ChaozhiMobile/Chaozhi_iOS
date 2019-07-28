//
//  MEView.m
//  Health
//
//  Created by mingyue on 17/4/26.
//  Copyright © 2017年 huds. All rights reserved.
//

#import "MEView.h"

@implementation MEView

- (instancetype)init {
    self = [super init];
    if (self) {
        
        [self me_setupViews];
        [self me_bindViewModel];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self me_setupViews];
        [self me_bindViewModel];
    }
    return self;
}

- (instancetype)initWithViewModel:(id<MEViewModelProtocol>)viewModel {
    
    self = [super init];
    if (self) {
        
        [self me_setupViews];
        [self me_bindViewModel];
    }
    return self;
}

- (void)me_bindViewModel {
}

- (void)me_setupViews {
}

- (void)me_addReturnKeyBoard {
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    
//    [tap.rac_gestureSignal subscribeNext:^(id x) {
//        GetAppDelegate;
//        [appDelegate.window endEditing:YES];
//    }];
    
    [self addGestureRecognizer:tap];
}


@end
