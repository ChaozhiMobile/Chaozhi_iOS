//
//  TalkfunNewTextfieldView.h
//  TalkfunSDKDemo
//
//  Created by 孙兆能 on 2016/12/19.
//  Copyright © 2016年 talk-fun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TalkfunNewTextfieldView : UIView

@property (nonatomic,strong) UIButton * flowerButton;
@property (nonatomic,strong) UIImageView * flowerImageView;
@property (nonatomic,strong) UIButton * sendButton;
@property (weak, nonatomic) IBOutlet UITextField *tf;
@property (nonatomic,strong) UIView * underlineView;
@property (nonatomic,strong) UIButton * expressionButton;
@property (nonatomic,strong) UIImageView * expressionImageView;
@property (nonatomic,strong) UIView * rightView;
@property (nonatomic,assign) BOOL hasFlower;

+ (id)initView;
- (void)createChatTFView:(id)target action:(SEL)action;
- (void)flower:(BOOL)flower  number:(NSInteger)number;
- (void)showSendButton:(BOOL)show;
- (void)expressionBtnSelected:(BOOL)selected;

@end
