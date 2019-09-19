//
//  TalkfunReplyTipsView.h
//  TalkfunSDKDemo
//
//  Created by Sunzn on 2016/12/26.
//  Copyright © 2016年 talk-fun. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TalkfunCloseButton;
@interface TalkfunReplyTipsView : UIView
@property (nonatomic,copy) void (^closeBtnBlock)();
@property (weak, nonatomic) IBOutlet UIButton *tipsButton;
@property (weak, nonatomic) IBOutlet TalkfunCloseButton *closeButton;

@end
