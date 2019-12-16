//
//  CZPopAdsView.h
//  Chaozhi
//
//  Created by Jason_zyl on 2019/12/7.
//  Copyright © 2019 Jason_hzb. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^PopAdsClickBlock) (NSInteger index);

@interface CZPopAdsView : UIView

/** 广告点击Block */
@property (nonatomic,copy) PopAdsClickBlock clickBlock;
/** 关闭Block */
@property (nonatomic,copy) dispatch_block_t closeBlock;

- (instancetype)initWithImages:(NSMutableArray *)imageArray;

@end

NS_ASSUME_NONNULL_END
