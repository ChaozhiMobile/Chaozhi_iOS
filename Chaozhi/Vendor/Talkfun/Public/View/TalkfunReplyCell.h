//
//  TalkfunReplyCell.h
//  TalkfunSDKDemo
//
//  Created by Sunzn on 2017/2/5.
//  Copyright © 2017年 talk-fun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TalkfunReplyCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *roleLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameTimeLabel;
@property (weak, nonatomic) IBOutlet UITextView *content;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *roleLabelWidth;

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
- (void)configCell:(NSDictionary *)dict;

@end
