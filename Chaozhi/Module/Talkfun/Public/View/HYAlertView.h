//
//  HYAlertView.h
//  HYAlertViewDemo
//
//  Created by yanghaha on 15/10/12.
//  Copyright (c) 2015年 yanghaha. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, HYAlertViewStyle) {
    HYAlertViewStyleDefault = 0,
    HYAlertViewStyleSecureTextInput,
    HYAlertViewStylePlainTextInput,
    HYAlertViewStyleLoginAndPasswordInput
};

typedef void(^ClickEventBlock)(NSString *title  );
@interface HYAlertView : UIView

@property (nonatomic,strong) UILabel *msgLabel;
/**选项的名字 */
@property (nonatomic, strong) ClickEventBlock clickEventBlock;
//当前屏幕 的方向
@property(nonatomic,assign)BOOL  isOrientationLandscape ;
/**
 *消息字体大小(alertViewStyle为Default),否则为输入框字体大小
 **/
@property (nonatomic,strong) UIFont *messageFont;

@property (nonatomic) BOOL   seriesAlert;

@property (nonatomic) HYAlertViewStyle alertViewStyle;

/**
 *  @两个按钮纯文本显示（block回调方式）
 */
-(id)initWithTitle:(NSString *)title message:(NSString *)message buttonTitles:(NSString *)otherButtonTitles,... NS_REQUIRES_NIL_TERMINATION;

/**
 *  显示弹出框
 */
//-(void)showWithCompletion:(void (^)(HYAlertView *alertView ,NSInteger selectIndex))completeBlock;

-(void)showInView:(UIView *)baseView completion:(void (^)(HYAlertView *alertView ,NSInteger selectIndex))completeBlock;

/**
 *获取指定的textField
 **/
- (UITextField *)textFieldAtIndex:(NSInteger)textFieldIndex;

//选择 选择结果
- (void)presentViewController:(UIViewController*)ViewController  content:(NSString*)content  actionWithTitle:(NSString*)title;
@end
