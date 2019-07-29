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
@property (weak, nonatomic) IBOutlet UIView *titleLineView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineViewLeft;
- (IBAction)titleClickAction:(UIButton *)sender;

@end

NS_ASSUME_NONNULL_END
