//
//  TalkfunNewFunctionView.h
//  TalkfunSDKDemo
//
//  Created by 孙兆能 on 2016/12/14.
//  Copyright © 2016年 talk-fun. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TalkfunGradientView;
@class TalkfunNewFunctionButton;
@interface TalkfunNewFunctionView : UIView

@property (nonatomic,copy) void (^definitionBlock)(NSString* definition);


@property (nonatomic,copy) void (^sliderValueBlock)(CGFloat sliderValue);
//过程中
@property (nonatomic,copy) void (^sliderValueChangeBlock)(CGFloat sliderValue);

//单击
@property (nonatomic,copy) void (^sliderTapGestureBlock)(CGFloat sliderValue);

//传设置的倍速
@property (nonatomic,copy) void (^playbackRateBlock)(CGFloat speed);

@property (weak, nonatomic) IBOutlet TalkfunGradientView *topView;
@property (weak, nonatomic) IBOutlet TalkfunGradientView *bottomView;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UIButton *cameraBtn;
@property (weak, nonatomic) IBOutlet UIButton *exchangeBtn;
@property (weak, nonatomic) IBOutlet UIButton *refreshBtn;
@property (weak, nonatomic) IBOutlet UIButton *networkBtn;
@property (weak, nonatomic) IBOutlet UIButton *danmuBtn;
@property (weak, nonatomic) IBOutlet UIButton *fullScreenBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *networkTrailingSpaceToFullScreen;
@property (weak, nonatomic) IBOutlet UIButton *playBtn;

@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (nonatomic,assign) BOOL touch;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalTimeLabel;

@property (weak, nonatomic) IBOutlet UIButton *CameraBtn1;

@property (weak, nonatomic) IBOutlet UIButton *smooth;
@property (weak, nonatomic) IBOutlet UIView *smoothView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *smoothYY;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *totalWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *smoothViewHIght;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *networkX;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sliderX;

+ (id)initView;
- (void)buttonsAddTarget:(id)target action:(SEL)action;
- (void)playbackMode:(BOOL)playbackMode;
- (void)play:(BOOL)play;
- (void)setDuration:(CGFloat)duration;
- (void)totalTimeLabelShow:(BOOL)show;



- (void)setDefaultStream:(NSDictionary*)dict;




- (void)setVideoDefinition:(NSArray*)array;

-(void)playbackRate;


@end
