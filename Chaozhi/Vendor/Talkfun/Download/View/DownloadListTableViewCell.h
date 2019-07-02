//
//  DownloadListTableViewCell.h
//  TalkfunSDKDemo
//
//  Created by 孙兆能 on 16/7/11.
//  Copyright © 2016年 talk-fun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DownloadListTableViewCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UIImageView *downloadImageView;
@property (weak, nonatomic) IBOutlet UILabel *fileName;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic) IBOutlet UIButton *controlBtn;
@property (weak, nonatomic) IBOutlet UILabel *progressLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalDuration;
@property (weak, nonatomic) IBOutlet UILabel *fileProgressLabel;
@property (weak, nonatomic) IBOutlet UIImageView *downloadBtnImageView;
@property (weak, nonatomic) IBOutlet UILabel *downloadBtnLabel;
@property (weak, nonatomic) IBOutlet UILabel *playLabel;

//@property (nonatomic,copy) void (^btnClickBlock)(UIButton * btn);

@end
