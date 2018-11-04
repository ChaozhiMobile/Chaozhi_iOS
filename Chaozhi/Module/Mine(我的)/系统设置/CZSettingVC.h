//
//  CZSettingVC.h
//  Chaozhi
//
//  Created by Jason_zyl on 2018/10/6.
//  Copyright © 2018年 Jason_hzb. All rights reserved.
//

#import "BaseVC.h"

@interface CZSettingVC : BaseVC

@property (weak, nonatomic) IBOutlet UISwitch *switchBtn;
@property (weak, nonatomic) IBOutlet UIView *aboutView;
@property (weak, nonatomic) IBOutlet UIView *changePswView;
@property (weak, nonatomic) IBOutlet UILabel *versionLab;
@property (weak, nonatomic) IBOutlet UIButton *callPhoneBtn;
- (IBAction)callPhoneAction:(UIButton *)sender;

@end
