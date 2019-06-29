//
//  TalkfunGradientView.m
//  TalkfunSDKDemo
//
//  Created by 孙兆能 on 2016/12/14.
//  Copyright © 2016年 talk-fun. All rights reserved.
//

#import "TalkfunGradientView.h"

@implementation TalkfunGradientView

- (void)addLayer{
    
    CAGradientLayer *layer = [CAGradientLayer new];
    layer.colors = @[(__bridge id)_inputColor0.CGColor, (__bridge id)_inputColor1.CGColor];
    layer.startPoint = self.inputPoint0;
    layer.endPoint = self.inputPoint1;
    layer.frame = self.bounds;
    
    [self.layer addSublayer:layer];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self.layer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    [self addLayer];
}

@end
