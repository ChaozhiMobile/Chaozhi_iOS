//
//  CZAlertView.h
//  Chaozhi
//
//  Created by zhanbing han on 2019/6/10.
//  Copyright © 2019 Jason_hzb. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CZAlertView : UIView

/** <#object#> */
@property (nonatomic,assign) BOOL isRelease;

@property (nonatomic,copy) dispatch_block_t cancelBlock;
@property (nonatomic,copy) dispatch_block_t doneBlock;
@property (nonatomic,copy) dispatch_block_t urlClickBlock;
/**
 *  内容一行居中显示 多行则自动靠左显示  默认添加在当前控制上的视图
 *
 *  @param topTitle   标题
 *  @param textStr    弹框内容
 *  @param leftBtnTitle  左按钮文字
 *  @param rigthBtnTitle 右按钮文字
 *
 *  @return id
 */
- (id)initWithTitle:(NSString *)topTitle content:(NSString *)textStr leftButtonTitle:(NSString *)leftBtnTitle rightButtonTitle:(NSString *)rigthBtnTitle;

@end

NS_ASSUME_NONNULL_END
