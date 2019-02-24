//
//  XLGAlertView.h
//  SharenGo
//  Notes：封装提醒对话框
//
//  Created by Jason_hzb on 2018/5/29.
//  Copyright © 2018年 小灵狗出行. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XLGAlertView : UIView

@property (nonatomic,copy) dispatch_block_t cancelBlock;
@property (nonatomic,copy) dispatch_block_t doneBlock;
@property (nonatomic, copy) dispatch_block_t dismissBlock; //点击左右按钮都会触发该消失的block

@property (nonatomic,copy) NSString *topTitle;
@property (nonatomic,copy) NSString *version;
@property (nonatomic,retain) NSString *textStr;
@property (nonatomic,copy) NSString *leftTitle;
@property (nonatomic,copy) NSString *rigthTitle;
/**  message */
@property (nonatomic,retain) UILabel *contentLab;
/** 正确or错误 */
@property (nonatomic,assign) BOOL isSucc;
@property (nonatomic,assign) AShowAnimationStyle animationStyle;

/**
 *  不隐藏，默认为NO。设置为YES时点击按钮alertView不会消失（适合在强制升级时使用）
 */
@property (nonatomic,assign)BOOL dontDissmiss;

/**
 *  构造方法
 *
 *  @param topTitle   标题
 *  @param textStr    弹框内容
 *  @param leftBtnTitle  左按钮文字
 *  @param rigthBtnTitle 右按钮文字
 *
 *  @return id
 */
- (id)initWithTitle:(NSString *)topTitle content:(NSString *)textStr leftButtonTitle:(NSString *)leftBtnTitle rightButtonTitle:(NSString *)rigthBtnTitle;


/**
 初始化带有成功或者失败的弹框

 @param isSucc YES 成功弹框
 @param textStr 内容
 @param leftBtnTitle 左按钮文字
 @param rigthBtnTitle 右按钮文字
 @return id
 */
- (id)initWithSucc:(BOOL)isSucc content:(NSString *)textStr leftButtonTitle:(NSString *)leftBtnTitle rightButtonTitle:(NSString *)rigthBtnTitle;


@end
