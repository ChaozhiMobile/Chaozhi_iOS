//
//  TalkfunLongTextfieldView.h
//  TalkfunSDKDemo
//
//  Created by 孙兆能 on 2016/12/19.
//  Copyright © 2016年 talk-fun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TalkfunLongTextfieldView : UIView
@property (weak, nonatomic) IBOutlet UITextField *tf;
@property (nonatomic,strong) UIButton * sendBtn;
@property (weak, nonatomic) IBOutlet UIButton *expressionBtn;

+ (id)initView;
- (void)expressionBtnSelected:(BOOL)selected;

@end
