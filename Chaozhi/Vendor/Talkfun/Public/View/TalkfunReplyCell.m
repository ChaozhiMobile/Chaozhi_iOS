//
//  TalkfunReplyCell.m
//  TalkfunSDKDemo
//
//  Created by Sunzn on 2017/2/5.
//  Copyright © 2017年 talk-fun. All rights reserved.
//

#import "TalkfunReplyCell.h"
#import "UIImageView+WebCache.h"
@implementation TalkfunReplyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.roleLabel.clipsToBounds = YES;
     self.avatarImageView.clipsToBounds = YES;
    
}

- (void)configCell:(NSDictionary *)dict{
    if ([dict[@"role"] isEqualToString:TalkfunMemberRoleSpadmin]) {
        self.roleLabel.text = @"老师";
        self.roleLabelWidth.constant = 27;
        self.roleLabel.layer.cornerRadius = 3;
        self.roleLabel.backgroundColor = [UIColor redColor];
    }
    //=============== 如果是助教说的话 =================
    else if ([dict[@"role"] isEqualToString:TalkfunMemberRoleAdmin])
    {
        self.roleLabel.text = @"助教";
        self.roleLabelWidth.constant = 27;
        self.roleLabel.layer.cornerRadius = 3;
        self.roleLabel.backgroundColor = [UIColor orangeColor];
    }else{
        self.roleLabelWidth.constant = 0;
    }
    self.avatarImageView.layer.cornerRadius = 10;
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:dict[@"avatar"]?dict[@"avatar"]:@""] placeholderImage:[UIImage imageNamed:@"占位图"] options:0];
    
    self.nameTimeLabel.textColor = LIGHTBLUECOLOR;
    self.nameTimeLabel.attributedText = [TalkfunUtils getUserNameAndTimeWith:dict playback:NO];
    NSString * content = dict[@"content"];
    NSDictionary * contentDict = [TalkfunUtils assembleAttributeString:content boundingSize:CGSizeMake(CGRectGetWidth(self.frame)-48, MAXFLOAT) fontSize:13 shadow:NO];
    NSAttributedString * attr = contentDict[AttributeStr];
    NSMutableAttributedString * contentAttrStr = [[NSMutableAttributedString alloc] initWithAttributedString:attr];
    UIColor * contentColor = [UIColor whiteColor];
    [contentAttrStr addAttribute:NSForegroundColorAttributeName value:contentColor range:NSMakeRange(0, attr.length)];
    [contentAttrStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:13] range:NSMakeRange(0, attr.length)];
    self.content.attributedText = contentAttrStr;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
