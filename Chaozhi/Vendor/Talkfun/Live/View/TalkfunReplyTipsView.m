//
//  TalkfunReplyTipsView.m
//  TalkfunSDKDemo
//
//  Created by Sunzn on 2016/12/26.
//  Copyright © 2016年 talk-fun. All rights reserved.
//

#import "TalkfunReplyTipsView.h"
#import "TalkfunCloseButton.h"

@implementation TalkfunReplyTipsView

- (IBAction)closeButtonClicked:(TalkfunCloseButton *)sender {
    if (self.closeBtnBlock) {
        self.closeBtnBlock();
    }
}

@end
