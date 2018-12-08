//
//  CZStarView.h
//  Chaozhi
//
//  Created by Jason_zyl on 2018/12/8.
//  Copyright © 2018年 Jason_hzb. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CZStarView;

@protocol StarRatingViewDelegate <NSObject>

@optional
/**
 *  代理方法
 *
 *  @param view  星星视图
 *  @param score 当前分值
 */
-(void)starRatingView:(CZStarView *)view score:(CGFloat)score;

@end

@interface CZStarView : UIView

/**
 *  是否可以滑动评分  YES:可以  NO:不可以
 */
@property (nonatomic, assign) BOOL enable;
/**
 *  设置分值
 */
@property (nonatomic,assign)CGFloat score;

/**
 *  重写父类的init方法
 *
 *  @param frame                  星星控件的frame
 *  @param currentScore           当前的分值
 *  @param starRatingViewDelegate 代理
 *
 *  @return 星星控件
 */
- (instancetype)initWithFrame:(CGRect)frame currentScore:(CGFloat)currentScore delegate:(id)starRatingViewDelegate;


@property (nonatomic, weak) id <StarRatingViewDelegate> delegate;

@end
