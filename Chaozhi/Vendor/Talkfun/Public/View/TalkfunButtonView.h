//
//  TalkfunButtonView.h
//  TalkfunSDKDemo
//
//  Created by 孙兆能 on 2016/11/23.
//  Copyright © 2016年 talk-fun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TalkfunNewButtonViewButton.h"
#import "TalkfunNewFunctionButton.h"
//@class TalkfunNewButtonViewButton;
@interface TalkfunButtonView : UIView
@property (weak, nonatomic) IBOutlet TalkfunNewButtonViewButton *chatBtn;
@property (weak, nonatomic) IBOutlet TalkfunNewButtonViewButton *askBtn;
@property (weak, nonatomic) IBOutlet TalkfunNewButtonViewButton *noticeBtn;
@property (weak, nonatomic) IBOutlet TalkfunNewButtonViewButton *albumBtn;
@property (weak, nonatomic) IBOutlet TalkfunNewFunctionButton *downloadBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *chatBtnWidth;
@property (weak, nonatomic) IBOutlet UIView *selectView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *selectViewLeadingSpace;
@property (nonatomic,strong) TalkfunNewButtonViewButton * selectBtn;
@property (weak, nonatomic) IBOutlet UIImageView *chatTipsView;
@property (weak, nonatomic) IBOutlet UIImageView *askTipsView;
@property (weak, nonatomic) IBOutlet UIImageView *noticeTipsView;
@property (nonatomic,assign,readonly) BOOL isPlayback;

+ (id)initView;
- (void)buttonsAddTarget:(id)target action:(SEL)action;
- (void)selectButton:(TalkfunNewButtonViewButton *)btn;
- (void)showTipsInButton:(TalkfunNewButtonViewButton *)btn;
- (void)isPlayback:(BOOL)isPlayback;
- (void)album:(BOOL)album;

@end
