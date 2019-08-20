//
//  CZCommentView.h
//  Chaozhi
//
//  Created by zhanbing han on 2019/8/19.
//  Copyright © 2019 Jason_hzb. All rights reserved.
//

#import <UIKit/UIKit.h>



NS_ASSUME_NONNULL_BEGIN

@interface AnswerModel : BaseItem
/** title */
@property (nonatomic,copy) NSString *title;
/** <#object#> */
@property (nonatomic,retain) NSArray *tag;
@end

@interface  CommentDataModel: BaseItem
/** 0 */
@property (nonatomic,copy) NSString *is_review;
/** 0 */
@property (nonatomic,retain) NSDictionary *meta;
@end

@interface CZCommentView : UIView
/** 数据 */
@property (nonatomic,retain) id dataSource;
/** bgScrollView */
@property (nonatomic,retain) UIScrollView *bgScrollView;
/** 视图高度 */
@property (nonatomic,assign) CGFloat viewHeight;
/** <#object#> */
@property (nonatomic,copy) void (^submitBlock)(NSDictionary *resultDic);

/** 关闭视图 */
@property (nonatomic,copy) dispatch_block_t closeView;

- (void)showView;
- (void)hiddenView;

- (void)changeOrientation:(BOOL)isPortrait;

+ (CZCommentView *)sharedInstance;

#pragma mark - 创建带有星星的评价
/** 创建带有星星的评价 */
- (UIView *)createStarView:(id)data;

@end




NS_ASSUME_NONNULL_END
