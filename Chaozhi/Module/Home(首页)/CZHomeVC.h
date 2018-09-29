//
//  CZHomeVC.h
//  Chaozhi
//
//  Created by Jason_zyl on 2018/9/22.
//  Copyright © 2018年 Jason_hzb. All rights reserved.
//

#import "BaseVC.h"

@interface DayNewTabCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *dayNewIconImgView;
@property (weak, nonatomic) IBOutlet UILabel *dayNewTitleLB;
@property (weak, nonatomic) IBOutlet UILabel *dayNewContentLB;

@end

@interface CZHomeVC : BaseVC

@end
