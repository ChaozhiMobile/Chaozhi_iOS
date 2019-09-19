//
//  TalkfunNewChatTableViewCell.m
//  TalkfunSDKDemo
//
//  Created by Sunzn on 2017/1/24.
//  Copyright © 2017年 talk-fun. All rights reserved.
//

#import "TalkfunNewChatTableViewCell.h"
#import "PlaybackChatModel.h"
#import "MJExtension.h"
#import "UIImageView+WebCache.h"
@implementation TalkfunNewChatTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.roleLabel.clipsToBounds = YES;
     self.avatarImageView.clipsToBounds = YES;
}

- (void)configCell:(NSDictionary *)dict isPlayback:(BOOL)isPlayback;{
    if (isPlayback) {
        self.roleLabelWidth.constant = 0;
    }
    PlaybackChatModel * model = [PlaybackChatModel mj_objectWithKeyValues:dict];
    //=============== 如果是老师说的话 =================
    if ([model.role isEqualToString:TalkfunMemberRoleSpadmin]) {
        self.roleLabel.text = @"老师";
        self.roleLabelWidth.constant = 27;
        self.roleLabel.layer.cornerRadius = 3;
        self.roleLabel.backgroundColor = [UIColor redColor];
    }
    //=============== 如果是助教说的话 =================
    else if ([model.role isEqualToString:TalkfunMemberRoleAdmin])
    {
        self.roleLabel.text = @"助教";
        self.roleLabelWidth.constant = 27;
        self.roleLabel.layer.cornerRadius = 3;
        self.roleLabel.backgroundColor = [UIColor orangeColor];
    }
    else{
        self.roleLabelWidth.constant = 0;
    }
    self.avatarImageView.layer.cornerRadius = 10;
    
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:[UIImage imageNamed:@"占位图"] options:0];
    self.nameTimeLabel.textColor = LIGHTBLUECOLOR;
    self.nameTimeLabel.attributedText = [TalkfunUtils getUserNameAndTimeWith:dict playback:YES];
    NSDictionary * contentDict = [TalkfunUtils assembleAttributeString:model.msg boundingSize:CGSizeMake(ScreenSize.width-48, CGFLOAT_MAX) fontSize:13 shadow:NO];
    NSAttributedString * attr = contentDict[AttributeStr];
    NSMutableAttributedString * contentAttrStr = [[NSMutableAttributedString alloc] initWithAttributedString:attr];
    UIColor * contentColor = [UIColor whiteColor];
    if ([model.msg rangeOfString:@"送给老师：[S_FLOWER]"].location != NSNotFound) {
        contentColor = [UIColor lightGrayColor];
    }
    [contentAttrStr addAttribute:NSForegroundColorAttributeName value:contentColor range:NSMakeRange(0, attr.length)];
    self.content.attributedText = contentAttrStr;
    
    //cell的颜色
    self.backgroundColor =[UIColor clearColor];
    
    if ([self.selectedArray[self.number] integerValue] == 1) {
        self.backgroundColor = NEWBLUECOLOR;
//        self.backgroundColor = [UIColor colorWithRed:200 / 255.0 green:200 / 255.0 blue:200 / 255.0 alpha:1];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
