//
//  ChapterTableViewCell.h
//  Talkfun_demo
//
//  Created by talk－fun on 15/12/25.
//  Copyright © 2015年 talk-fun. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ChapterModel;
@interface ChapterTableViewCell : UITableViewCell
@property (weak, nonatomic ) IBOutlet UIImageView    *thumb;
@property (weak, nonatomic ) IBOutlet UILabel        *course;
@property (weak, nonatomic ) IBOutlet UILabel        *page;
@property (weak, nonatomic ) IBOutlet UILabel        *chapter;


@property (nonatomic,assign) BOOL           rotated;
@property (nonatomic,strong) ChapterModel   *Model;
@property (nonatomic,assign) NSInteger      number;
@property (nonatomic,strong) NSMutableArray * selectedArray;


@end
