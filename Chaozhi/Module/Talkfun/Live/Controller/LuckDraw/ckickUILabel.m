//
//  ckickUILabel.m
//  TalkfunSDKDemo
//
//  Created by moruiwei on 17/3/23.
//  Copyright © 2017年 Talkfun. All rights reserved.
//

#import "ckickUILabel.h"

@implementation ckickUILabel

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"点击 了lab");
    
    if (self.myBlock) {
        self.myBlock(self.tag);
    }
}
@end
