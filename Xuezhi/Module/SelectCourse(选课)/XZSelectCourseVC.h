//
//  XZSelectCourseVC.h
//  Xuezhi
//
//  Created by Jason_zyl on 2019/7/28.
//  Copyright © 2019 Jason_hzb. All rights reserved.
//

#import "BaseVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface XZSelectCourseVC : BaseVC
@property (retain, nonatomic)  UIView *titleLineView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineViewLeft;
@property (weak, nonatomic) IBOutlet UIScrollView *titleBgScrollView;
@property (weak, nonatomic) IBOutlet UITableView *mainTabView;

- (IBAction)titleClickAction:(UIButton *)sender;
@end

@interface XZSelectCourseTabCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *thumbImgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *currentPriceLab;
@property (weak, nonatomic) IBOutlet UILabel *oldPriceLab;

@end

NS_ASSUME_NONNULL_END
