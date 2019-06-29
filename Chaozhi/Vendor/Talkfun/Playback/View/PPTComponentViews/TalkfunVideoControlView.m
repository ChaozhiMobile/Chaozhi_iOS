//
//  TalkfunVideoControlView.m
//  TalkfunSDKDemo
//
//  Created by 孙兆能 on 2016/11/30.
//  Copyright © 2016年 talk-fun. All rights reserved.
//

#import "TalkfunVideoControlView.h"

@implementation TalkfunVideoControlView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    UITapGestureRecognizer * sliderTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sliderTap:)];
    [self.slider addGestureRecognizer:sliderTap];
    self.slider.continuous = NO;
    [self.slider addGestureRecognizer:sliderTap];
    self.slider.value = 0.0;
    self.slider.userInteractionEnabled = NO;
    self.touch = NO;
    [self.slider addTarget:self action:@selector(sliderValueChange:) forControlEvents:UIControlEventValueChanged];
    [self.slider addTarget:self action:@selector(sliderThumbTouch:) forControlEvents:UIControlEventTouchDown];
    [self.slider addTarget:self action:@selector(sliderThumbUnTouch:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
}

- (void)sliderTap:(UITapGestureRecognizer *)sliderTap
{
    if (sliderTap.state == UIGestureRecognizerStateEnded) {
        if (!self.touch) {
            CGPoint location = [sliderTap locationInView:self.slider];
            float x = location.x;
            float r = x / self.slider.frame.size.width;
            float value = (self.slider.maximumValue - self.slider.minimumValue) * r;
            [self.slider setValue:value animated:YES];
        }
    }
    [self sliderValueChange:self.slider];
}

- (void)sliderValueChange:(UISlider *)slider
{
    WeakSelf
    if (self.sliderValueBlock) {
        self.sliderValueBlock(slider.value);
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        weakSelf.touch = NO;
    });
    self.playBtnImageView.image = [UIImage imageNamed:@"pause"];
    self.playBtn.selected = NO;
}

- (void)sliderThumbTouch:(UISlider *)slider
{
    self.touch = YES;
}

- (void)sliderThumbUnTouch:(UISlider *)slider
{
    WeakSelf
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        weakSelf.touch = NO;
    });
}

@end
