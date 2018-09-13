//
//  XLGShowTipsVC.h
//  Chaozhi
//  Notes：
//
//  Created by MEyo on 2018/6/11.
//  Copyright © 2018年 小灵狗出行. All rights reserved.
//

#import "BaseVC.h"

@interface XLGShowTipsVC : BaseVC


/**
 提示界面

 @param title 导航条标题
 @param tips 提示语
 @param image 提示图片
 @return VC
 */
- (instancetype)initWithTitle:(NSString *)title tips:(NSString *)tips tipsImage:(UIImage *)image;

@end
