//
//  AlbumCellTableViewCell.h
//  TalkfunSDKDemo
//
//  Created by moruiwei on 16/5/17.
//  Copyright © 2016年 talk-fun. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AlbumModel;
@interface AlbumCellTableViewCell : UITableViewCell
@property (nonatomic,strong) AlbumModel *Model;

@property (weak, nonatomic) IBOutlet UILabel *name;


@property (weak, nonatomic) IBOutlet UILabel *time;


@property (weak, nonatomic) IBOutlet UIImageView *iconView;



@property (nonatomic,assign) NSInteger  number;


@property (nonatomic,assign) BOOL rotated;

@property (nonatomic,strong) NSMutableArray * selectedArray;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *with;




@end
