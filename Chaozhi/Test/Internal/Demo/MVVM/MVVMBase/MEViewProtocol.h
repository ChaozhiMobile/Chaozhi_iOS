//
//  MEViewProtocol.h
//  Health
//
//  Created by mingyue on 17/4/26.
//  Copyright © 2017年 huds. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MEViewModelProtocol;

@protocol MEViewProtocol <NSObject>

@optional

- (instancetype)initWithViewModel:(id <MEViewModelProtocol>)viewModel;

- (void)me_bindViewModel;
- (void)me_setupViews;
- (void)me_addReturnKeyBoard;

@end
