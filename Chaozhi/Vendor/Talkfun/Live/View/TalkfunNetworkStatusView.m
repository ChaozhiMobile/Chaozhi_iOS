//
//  TalkfunNetworkStatusView.m
//  TalkfunSDKDemo
//
//  Created by 孙兆能 on 2016/11/23.
//  Copyright © 2016年 talk-fun. All rights reserved.
//

#import "TalkfunNetworkStatusView.h"

@implementation TalkfunNetworkStatusView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.networkStatusButton.layer.cornerRadius = 5;
    self.networkStatus = TalkfunNetworkStatusGeneral;
    self.networkStatusButton.backgroundColor = YELLOWCOLOR;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (self.frame.size.width < 100) {
        self.networkSpeedLabel.hidden = YES;
        self.networkCharactersLabel.hidden = YES;
        self.networkStatusButton.backgroundColor = [UIColor clearColor];
    }
    else
    {
        self.networkSpeedLabel.hidden = NO;
        self.networkCharactersLabel.hidden = NO;
        if (self.networkStatus==TalkfunNetworkStatusBad) {
            self.networkStatusButton.backgroundColor = REDCOLOR;
        }
        else if (self.networkStatus==TalkfunNetworkStatusGeneral)
        {
            self.networkStatusButton.backgroundColor = YELLOWCOLOR;
        }
        else
        {
            self.networkStatusButton.backgroundColor = GREENCOLOR;
        }
    }
}

- (void)networkStatusChange:(TalkfunNetworkStatus)networkStatus
{
    self.networkStatus = networkStatus;
    if (networkStatus==TalkfunNetworkStatusGeneral) {
        self.networkSpeedLabel.textColor = FONTYELLOWCOLOR;
        self.networkStatusImageView.image = [UIImage imageNamed:@"generalStatus"];
        self.networkCharactersLabel.text = @"网络一般";
        self.networkStatusButton.backgroundColor = YELLOWCOLOR;
        self.hidden = NO;
    }
    else if (networkStatus==TalkfunNetworkStatusBad)
    {
        self.networkStatusImageView.image = [UIImage imageNamed:@"badStatus"];
        self.networkSpeedLabel.textColor = FONTREDCOLOR;
        self.networkCharactersLabel.text = @"网络较差";
        self.networkStatusButton.backgroundColor = REDCOLOR;
        self.hidden = NO;
    }else{
        self.hidden = YES;
    }
}

- (void)networkStatusViewHide:(BOOL)hide
{
    self.hidden = hide;
}

@end
