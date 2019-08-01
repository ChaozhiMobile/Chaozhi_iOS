//
//  XZHomeTabCell.h
//  Xuezhi
//
//  Created by Jason_zyl on 2019/8/1.
//  Copyright © 2019 Jason_hzb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeInfoItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface XZHomeTabCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *leftView;
@property (weak, nonatomic) IBOutlet UIView *rightView;
@property (weak, nonatomic) IBOutlet UIImageView *thumbImgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *teacherName;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *readCountLab;

/** 畅销好课model */
- (void)setItem:(HomeFeatureProductItem *)item withView:(UIView *)view;
/** 公开课model */
@property (nonatomic,strong) HomeTryVideoItem *publicItem;
/** 行业资讯model */
@property (nonatomic,strong) HomeNewsItem *newsItem;

@end

NS_ASSUME_NONNULL_END
