//
//  NIMSessionNotificationContentView.m
//  NIMKit
//
//  Created by chris on 15/3/9.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "NIMSessionNotificationContentView.h"
#import "NIMMessageModel.h"
#import "UIView+NIM.h"
#import "NIMKitUtil.h"
#import "UIImage+NIMKit.h"
#import "NIMKit.h"

@implementation NIMSessionNotificationContentView

- (instancetype)initSessionMessageContentView
{
    if (self = [super initSessionMessageContentView]) {
        _label = [[UITextView alloc] initWithFrame:CGRectZero];
//        _label.numberOfLines = 0;
        [self addSubview:_label];
    }
    return self;
}

- (void)refresh:(NIMMessageModel *)model
{
    [super refresh:model];
    
    NIMKitSetting *setting = [[NIMKit sharedKit].config setting:model.message];
    self.label.textColor = setting.textColor;
    self.label.font = setting.font;
    self.label.font = [UIFont systemFontOfSize:13];
    
    NSString *message = [NIMKitUtil messageTipContent:model.message];
    NSString *offline_send_tip = @"班主任不在线，您可以留言，或者联系其他老师";
    if ([message isEqualToString:offline_send_tip]) {
        NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:message];
        NSRange range = [[attributedStr string] rangeOfString:@"联系其他老师"];
        [attributedStr addAttribute:NSForegroundColorAttributeName
                              value:RGBValue(0x468CF2)
                              range:range];
        [attributedStr addAttribute:NSUnderlineStyleAttributeName value:@(NSUnderlineStyleSingle) range:range];
        [attributedStr addAttribute:NSLinkAttributeName value:@"联系其他老师" range:range];
        self.label.attributedText = attributedStr;
    } else {
        self.label.text = message;
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat padding = [NIMKit sharedKit].config.maxNotificationTipPadding;
    self.label.nim_size = [self.label sizeThatFits:CGSizeMake(self.nim_width - 2 * padding, CGFLOAT_MAX)];
    self.label.nim_centerX = self.nim_width * .5f;
    self.label.nim_centerY = self.nim_height * .5f;
    self.bubbleImageView.frame = CGRectInset(self.label.frame, -8, -4);
}

@end
