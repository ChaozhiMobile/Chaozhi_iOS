//
//  XZSelectCourseTabCell.h
//  Xuezhi
//
//  Created by Jason_zyl on 2019/8/2.
//  Copyright © 2019 Jason_hzb. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XZSelectCourseTabCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *thumbImgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *currentPriceLab;
@property (weak, nonatomic) IBOutlet UILabel *oldPriceLab;

@end

NS_ASSUME_NONNULL_END
