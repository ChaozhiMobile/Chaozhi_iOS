//
//  TalkfunVideoControlView.h
//  TalkfunSDKDemo
//
//  Created by 孙兆能 on 2016/11/30.
//  Copyright © 2016年 talk-fun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TalkfunVideoControlView : UIView

@property (nonatomic,copy) void (^sliderValueBlock)(CGFloat sliderValue);
@property (weak, nonatomic) IBOutlet UIButton *playBtn;
@property (weak, nonatomic) IBOutlet UIImageView *playBtnImageView;
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (nonatomic,assign) BOOL touch;

@end
