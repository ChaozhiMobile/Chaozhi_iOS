//
//  MEView.h
//  Health
//
//  Created by mingyue on 17/4/26.
//  Copyright © 2017年 huds. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MEViewProtocol.h"


@interface MEView : UIView <MEViewProtocol>

- (instancetype)initWithViewModel:(id<MEViewModelProtocol>)viewModel;

@end
