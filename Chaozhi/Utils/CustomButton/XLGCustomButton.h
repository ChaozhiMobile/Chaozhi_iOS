//
//  XLGCustomButton.h
//  SharenGo
//  Notes：自定义按钮 （文字在左边 图片在右边）
//
//  Created by yulu zeng on 2018/12/13.
//  Copyright © 2018年 小灵狗出行. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XLGBaseButton:UIButton
/** 按钮绑定的数据 */
@property (nonatomic,retain) id dataSource;
@end

@interface XLGCustomButton : XLGBaseButton

/** 选中和高亮合并为同一方法 */
- (void)setImage:(UIImage *)image;
/** 创建有主题色的阴影 */
- (id)initShadowButton;
@end

@interface XLGMyButton : XLGBaseButton
/** 是否选中 */
@property (nonatomic,assign) BOOL isSelect;
@end



NS_ASSUME_NONNULL_END
