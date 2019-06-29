//
//  TalkfunFunctionView.h
//  TalkfunSDKDemo
//
//  Created by 孙兆能 on 2016/11/23.
//  Copyright © 2016年 talk-fun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TalkfunFunctionButton.h"

@interface TalkfunFunctionView : UIView

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topSpaceToExchangeBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *trailingSpaceToContainer;
@property (weak, nonatomic) IBOutlet TalkfunFunctionButton *fullScreenButton;
@property (weak, nonatomic) IBOutlet TalkfunFunctionButton *hideCameraButton;
@property (weak, nonatomic) IBOutlet UIButton *exchangeButton;
@property (weak, nonatomic) IBOutlet TalkfunFunctionButton *networkSelectButton;

- (void)buttonsAddTarget:(id)target action:(SEL)action;
- (void)liveStart:(BOOL)start;

@end
