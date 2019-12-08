//
//  CZHomeVC.h
//  Chaozhi
//
//  Created by Jason_zyl on 2018/9/22.
//  Copyright © 2018年 Jason_hzb. All rights reserved.
//

#import "BaseVC.h"

@interface CZHomeVC : BaseVC
@property (weak, nonatomic) IBOutlet UITableView *mainTabView;
@end

@interface CZHomeBaseCell : UITableViewCell
/** 数据源 */
@property (nonatomic,retain) id dataSource;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *contentLab;
@end

@interface CZHomeCourseCell : CZHomeBaseCell
@property (weak, nonatomic) IBOutlet UIView *leftView;
@property (weak, nonatomic) IBOutlet UIView *rightView;
@end

@interface CZHomePublicCell : CZHomeBaseCell
@property (weak, nonatomic) IBOutlet UIButton *tryListeningBtn;
@end

@interface CZHomeWeiKeCell : CZHomeBaseCell
@property (weak, nonatomic) IBOutlet UILabel *countLab;
@end

@interface CZHomeActivityCell : CZHomeBaseCell

@end

@interface CZHomeGoldTeacherCell : CZHomeBaseCell
@property (weak, nonatomic) IBOutlet UIScrollView *teacherScroView;
@end

@interface CZHomeNewsCell : CZHomeBaseCell
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@end

