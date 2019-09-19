//
//  UITextField+TalkfunTextField.h
//  TalkfunSDKDemo
//
//  Created by 孙兆能 on 2016/11/19.
//  Copyright © 2016年 talk-fun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (TalkfunTextField)

-(id)initWithTitle:(NSString *)title image:(UIImage *)image;

- (id)initChatTFWithFrame:(CGRect)frame;

- (id)initAskTFWithFrame:(CGRect)frame;

- (id)initLongTFWithFrame:(CGRect)frame;

@end
