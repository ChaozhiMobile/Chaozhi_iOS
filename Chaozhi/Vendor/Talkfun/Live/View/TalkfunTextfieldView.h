//
//  TalkfunTextfieldView.h
//  TalkfunSDKDemo
//
//  Created by 孙兆能 on 2016/11/23.
//  Copyright © 2016年 talk-fun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TalkfunTextfieldView : UIView

@property (weak, nonatomic) IBOutlet UITextField *myTextField;

@property (nonatomic,strong) UIButton * flowerButton;
@property (nonatomic,strong) UIButton * sendButton;
@property (nonatomic,strong) UIButton * askButton;
@property (nonatomic,strong) UIImageView * flowerBubbleImageView;
@property (nonatomic,strong) UILabel * flowerNumLabel;
@property (nonatomic,strong) UIButton * expressionButton;
@property (nonatomic,strong) UIView * underlineView;
@property (nonatomic,strong) UIView * underlineView2;


- (void)createChatTFView:(id)target action:(SEL)action;
- (void)createAskTFView:(id)target action:(SEL)action;
- (void)createLongTFView:(id)target action:(SEL)action;
- (void)showSendButton:(BOOL)show;
- (void)askTFFrameChanged;
- (void)flowerBubble:(BOOL)show number:(NSString *)number;
- (void)flowerBubbleCornerImageViewShow:(BOOL)show;

@end
