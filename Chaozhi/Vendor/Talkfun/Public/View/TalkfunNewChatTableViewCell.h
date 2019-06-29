//
//  TalkfunNewChatTableViewCell.h
//  TalkfunSDKDemo
//
//  Created by Sunzn on 2017/1/24.
//  Copyright © 2017年 talk-fun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TalkfunNewChatTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *roleLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *roleLabelWidth;
@property (weak, nonatomic) IBOutlet UILabel *nameTimeLabel;
@property (weak, nonatomic) IBOutlet UITextView *content;
//序号
@property (nonatomic,assign) NSInteger number;
@property (nonatomic,strong) NSMutableArray * selectedArray;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;

- (void)configCell:(NSDictionary *)dict isPlayback:(BOOL)isPlayback;

@end
