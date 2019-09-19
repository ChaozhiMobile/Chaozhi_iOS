//
//  TalkfunNewQuestionCell.h
//  TalkfunSDKDemo
//
//  Created by Sunzn on 2017/2/5.
//  Copyright © 2017年 talk-fun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TalkfunNewQuestionCell : UITableViewCell<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *roleLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameTimeLabel;
@property (weak, nonatomic) IBOutlet UITextView *content;
@property (weak, nonatomic) IBOutlet UITableView *replyTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *roleLabelWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *replyTableViewHeight;
@property (nonatomic,assign) NSInteger number;
@property (nonatomic,strong) NSMutableArray * selectedArray;
@property (nonatomic,strong) NSMutableArray * dataSource;
@property (nonatomic,assign,readonly) BOOL isPlayback;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *xxxxx;

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
- (void)configCell:(NSDictionary *)dict isPlayback:(BOOL)isPlayback;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *teacherXXX;

@end
