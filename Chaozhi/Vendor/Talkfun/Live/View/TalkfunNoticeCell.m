//
//  TalkfunNoticeCell.m
//  TalkfunSDKDemo
//
//  Created by Sunzn on 2017/3/29.
//  Copyright © 2017年 Talkfun. All rights reserved.
//

#import "TalkfunNoticeCell.h"

@implementation TalkfunNoticeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
//    FFD085
    self.bg.backgroundColor = UIColorFromRGBHex(0xfff4d4);
    self.bg.layer.cornerRadius = 6;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
