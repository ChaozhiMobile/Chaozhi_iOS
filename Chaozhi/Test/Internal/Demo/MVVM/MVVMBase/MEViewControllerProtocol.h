//
//  MEViewControllerProtocol.h
//  Health
//
//  Created by mingyue on 17/4/26.
//  Copyright © 2017年 huds. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MEViewModelProtocol;

@protocol MEViewControllerProtocol <NSObject>

@optional

- (instancetype)initWithViewModel:(id <MEViewModelProtocol>)viewModel;

- (void)me_bindViewModel;
- (void)me_addSubviews;
- (void)me_layoutNavigation;
- (void)me_getNewData;

- (void)recoverKeyboard;

@end
