//
//  CZStudyVC.h
//  Chaozhi
//
//  Created by Jason_zyl on 2018/9/22.
//  Copyright © 2018年 Jason_hzb. All rights reserved.
//

#import "BaseVC.h"

@interface StudyCourseCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *studyCourseTitleLB;
@property (weak, nonatomic) IBOutlet UILabel *studycourseTimeLB;

@end

@interface CZStudyVC : BaseVC

@end
