//
//  XLGPaddingLabel.h
//  Chaozhi
//
//  Created by Jason_zyl on 2019/9/25.
//  Copyright © 2019 Jason_hzb. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
IB_DESIGNABLE

/**
 Adding margin to UILabel does not affect xib and masonry auto layout
 给UILabel添加内边距，支持xib和masonry的自动布局
 */
@interface XLGPaddingLabel : UILabel

///  圆角 默认3.0
@property (nonatomic, assign) IBInspectable CGFloat cornerRadius;
///  内边距 默认UIEdgeInsetsZero
@property (nonatomic, assign) UIEdgeInsets padding;

/**
 由于xib IBInspectable 不支持UIEdgeInsets， 故添加单独设置内边距属性，
 ！！！修改padding,会同步到 top_padding等4个属性变量
 */
@property (nonatomic, assign) IBInspectable CGFloat top_padding;
@property (nonatomic, assign) IBInspectable CGFloat left_padding;
@property (nonatomic, assign) IBInspectable CGFloat right_padding;
@property (nonatomic, assign) IBInspectable CGFloat bottom_padding;

@end

NS_ASSUME_NONNULL_END
