//
//  XZHomeVC.h
//  Xuezhi
//
//  Created by Jason_zyl on 2019/7/28.
//  Copyright © 2019 Jason_hzb. All rights reserved.
//

#import "BaseVC.h"
#import "SDCycleScrollView.h"

NS_ASSUME_NONNULL_BEGIN

@interface XZHomeVC : BaseVC

@property (weak, nonatomic) IBOutlet UILabel *redPointLab;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet SDCycleScrollView *bannerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bannerH;
@property (weak, nonatomic) IBOutlet UIScrollView *courseScrollView;
@property (weak, nonatomic) IBOutlet UITableView *mainTabView;

@end

NS_ASSUME_NONNULL_END
