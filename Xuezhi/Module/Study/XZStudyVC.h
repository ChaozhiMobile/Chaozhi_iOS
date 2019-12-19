//
//  XZStudyVC.h
//  Xuezhi
//
//  Created by Jason_zyl on 2019/12/19.
//  Copyright © 2019 Jason_hzb. All rights reserved.
//

#import "BaseVC.h"

@interface StudyCourseCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *studyCourseTitleLB;
@property (weak, nonatomic) IBOutlet UILabel *studycourseTimeLB;

@end

@interface XZStudyVC : BaseVC

@end
