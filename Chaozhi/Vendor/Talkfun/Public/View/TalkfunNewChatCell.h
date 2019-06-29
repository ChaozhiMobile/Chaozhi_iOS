//
//  TalkfunNewChatCell.h
//  TalkfunSDKDemo
//
//  Created by Sunzn on 2017/1/24.
//  Copyright © 2017年 talk-fun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "stopCopyTextView.h"
@interface TalkfunNewChatCell : UITableViewCell<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *roleLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameTimeLabel;
@property (weak, nonatomic) IBOutlet stopCopyTextView *content;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UITextView *bgContent;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *roleLabelWidth;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;

@property (nonatomic,copy) void (^btnBlock) (BOOL,NSString *);

- (void)configCell:(NSDictionary *)dict;

@end
