//
//  TalkfunNewFunctionView.m
//  TalkfunSDKDemo
//
//  Created by 孙兆能 on 2016/12/14.
//  Copyright © 2016年 talk-fun. All rights reserved.
//

#import "TalkfunNewFunctionView.h"
#import "TalkfunGradientView.h"
//#import "UIScrollView+TalkfunScrollView.h"
#import "videoDefinition.h"

#define KIsiPhoneX  @available(iOS 11.0, *) && UIApplication.sharedApplication.keyWindow.safeAreaInsets.bottom > 0.0



@interface TalkfunNewFunctionView()
@property(nonatomic,strong)NSArray*array;


//定时器
@property (nonatomic,strong)   NSTimer *timer;

@property(nonatomic,assign)BOOL isPlay;

@property (weak, nonatomic) IBOutlet UIImageView *isPlayImageView;
@property(assign,nonatomic)BOOL isPlaybackMode;
@end
@implementation TalkfunNewFunctionView
- (NSTimer * )timer
{
    if (_timer ==nil) {
        _timer = [[NSTimer alloc]init];
        
    }
    return _timer;
}
+ (id)initView{
    TalkfunNewFunctionView * newFunctionView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil][0];
    TimeLabelShow = NO;
    return newFunctionView;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    if(KIsiPhoneX){
//
//        NSLog(@"是X");
        self.cameraBtn.hidden =YES;
        self.CameraBtn1.imageView.contentMode = 0;
    }else{
        self.CameraBtn1.hidden =YES;
//          NSLog(@"不是X");
        
    }
    
    self.smoothView.layer.cornerRadius = 5;
    self.backgroundColor = [UIColor clearColor];
    self.playBtn.hidden = YES;
    self.slider.hidden = YES;

    [_topView addLayer];
    [_bottomView addLayer];
//    self.fullScreenBtn.selected = NO;
    self.timeLabel.hidden = YES;
    self.totalTimeLabel.hidden = YES;
    
//    self.userInteractionEnabled = NO;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    
}



- (void)layoutSubviews{
    [super layoutSubviews];

    
    //如果是点播 才进入
    if( self.isPlaybackMode){
       //横屏的时候
        if(TimeLabelShow){
 
            self.totalWidth.constant = 70;
        }else{
            if ([[UIDevice currentDevice] userInterfaceIdiom] ==
                
                UIUserInterfaceIdiomPad){
                  self.totalWidth.constant = 70;
                
            } else{
                
                //总时间宽度
                self.totalWidth.constant = 0;
                
            }
            
           
            
        }
    }
 [self addSubview:self.slider];
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
    
    if (_sliderTapGestureBlock) {
        _sliderTapGestureBlock(self.slider.value);
    }
    [self sliderValueChange:self.slider];
}

- (void)sliderValueChange:(UISlider *)slider
{
    
//     NSLog(@"slider.value======>%f",slider.value);
    

    self.touch = NO;

    if(_sliderValueChangeBlock){
        _sliderValueChangeBlock(slider.value);
    }
    
//    self.playBtn.selected = NO;
    if (_timer != nil){//如果定时器已经添加,就不能再添加定时器,否则定时速度出错
        return;
    }
    _timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES];

    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];


}

- (void)sliderThumbTouch:(UISlider *)slider
{
    self.touch = YES;
    [self.timer invalidate];
    _timer = nil;
}

- (void)sliderThumbUnTouch:(UISlider *)slider
{

        self.touch = NO;
    
    if (self.sliderValueBlock) {
        self.sliderValueBlock(slider.value);
    }

    
    if (_timer != nil){//如果定时器已经添加,就不能再添加定时器,否则定时速度出错
        return;
    }
    _timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES];

     [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];

}

- (void)buttonsAddTarget:(id)target action:(SEL)action{
    [self.backBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [self.cameraBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [self.CameraBtn1 addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    [self.exchangeBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [self.refreshBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [self.networkBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [self.danmuBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [self.fullScreenBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
     [self.smooth addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
   
}

- (void)playbackMode:(BOOL)playbackMode{
    self.isPlaybackMode = playbackMode;
    if (playbackMode) {
        self.playBtn.hidden = NO;
        self.isPlayImageView.hidden  = NO;
        self.playBtn.layer.cornerRadius = 25;
//        self.networkTrailingSpaceToFullScreen.constant = 0;

        self.smoothYY.constant = -200;

        self.playBtn.hidden = NO;
        self.slider.hidden = NO;

        self.timeLabel.hidden = NO;
        self.touch = NO;
        self.smooth.alpha = 1;
        [ self.smooth setTitle:@"1.0X" forState:UIControlStateNormal];
        self.smooth.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        
        UITapGestureRecognizer * sliderTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sliderTap:)];
        [self.slider addGestureRecognizer:sliderTap];
        self.slider.continuous = YES;
        self.slider.value = 0.0;
        self.slider.userInteractionEnabled = YES;
      
        
        [self.slider addTarget:self action:@selector(sliderValueChange:) forControlEvents:UIControlEventValueChanged];
        [self.slider addTarget:self action:@selector(sliderThumbTouch:) forControlEvents:UIControlEventTouchDown];
        [self.slider addTarget:self action:@selector(sliderThumbUnTouch:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
        [self.slider setThumbImage:[UIImage imageNamed:@"进度O"] forState:UIControlStateNormal];
        [self.slider setMinimumTrackImage:[UIImage imageNamed:@"进度2"] forState:UIControlStateNormal];
        [self.slider setMaximumTrackImage:[UIImage imageNamed:@"进度1"] forState:UIControlStateNormal];
        
        
    }
}

- (void)play:(BOOL)play{
    
//    if (self.isPlay==NO||play) {
//
    
    if (self.isPlay != play) {
        self.isPlay = play;
        [self.isPlayImageView setImage:[UIImage imageNamed:play?@"暂停1.png":@"播放1.png"] ];
        self.playBtn.selected = !play;
        
            if (_timer != nil){//如果定时器已经添加,就不能再添加定时器,否则定时速度出错
                return;
            }
            _timer = [NSTimer scheduledTimerWithTimeInterval:2.5 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES];

         [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];


    }
    
    //在播放
    if ( self.isPlay==YES&&self.hidden==NO) {
        if (_timer != nil){//如果定时器已经添加,就不能再添加定时器,否则定时速度出错
            return;
        }
        _timer = [NSTimer scheduledTimerWithTimeInterval:2.5 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES];

         [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];

    }
  
}
- (void)timeFireMethod
{
    if (self.timer) {
        [self.timer invalidate];
        _timer = nil;
        
    }
    if (self.isPlay) {
        self.hidden =YES;
    }
    
}
static BOOL TimeLabelShow = NO;
- (void)totalTimeLabelShow:(BOOL)show{
    TimeLabelShow = show;
    CGFloat duration = self.slider.maximumValue;
    self.totalTimeLabel.text = [self getTimeStr:duration];
    self.totalTimeLabel.hidden = !show;

}

- (void)setDuration:(CGFloat)duration{
    if (self.touch == NO && fabs(self.slider.value - duration) > 1.0) {
        [self.slider setValue:duration animated:YES];
    }
    

    self.timeLabel.text = [self getTimeStr:duration];
    CGFloat totalDuration = self.slider.maximumValue;
    self.totalTimeLabel.text = [self getTimeStr:totalDuration];
}

- (void)kuai:(CGFloat)duration hide:(BOOL)hide{
    
}

- (NSString *)getTimeStr:(CGFloat)duration{
    NSInteger hour   = duration / 3600;
    NSInteger minute = (duration - hour * 3600) / 60;
    NSInteger second = duration - minute * 60 - hour * 3600;
    return [NSString stringWithFormat:@"%02ld:%02ld:%02ld",(long)hour,(long)minute,(long)second];
}

- (void)setDefaultStream:(NSDictionary*)dict
{
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
//        NSLog(@"更新UI");
       
        
        if (dict[@"isSelected"]) {
            if ([dict[@"isSelected"] intValue]==1){
                
                
                //显示默认清晰度
                self.smooth.alpha = 1;
                
                [self.smooth  setTitle:dict[@"name"]?dict[@"name"]:@"" forState:UIControlStateNormal];
                
                
            }
        }else{
            //隐藏  默认清晰度
            self.smooth.alpha = 0;
        }
        
        
    });
    
    

    
}

- (void)setVideoDefinition:(NSArray*)array
{
    
    if (array) {
        
        
        //点出来 了,再点一下就隐藏
        if (self.smoothView.alpha == 1) {
            self.smoothView.alpha = 0;
            self.smoothYY.constant = -100;
            [self.smoothView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            return;
        }
        self.smoothView.alpha = 1;
        self.smoothViewHIght.constant = array.count*50;
        for (int i = 0; i<array.count; i++) {
            
            NSDictionary *dict = array[i];
            
            //有名字
            if (dict[@"name"]) {
                videoDefinition *btn111 = [[videoDefinition alloc]init];
                
                btn111.key = dict[@"key"]?dict[@"key"]:@"";

                [btn111 setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
                btn111.frame = CGRectMake(0, i*50, 50, 50);
                
                
                [btn111 setTitle:dict[@"name"] forState:UIControlStateNormal];
                
                btn111.titleLabel.font = [UIFont boldSystemFontOfSize:17];
                btn111.contentHorizontalAlignment = UIControlStateNormal;
                //默认项
                if ([dict[@"isSelected"] intValue]==1) {
                 [btn111 setTitleColor:[UIColor yellowColor]forState:UIControlStateNormal];
                }
                
                [btn111 addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
                [self.smoothView addSubview:btn111];
            }
           
        }
        
        
        [UIView animateWithDuration:0.5f animations:^{
            //动画
            self.smoothYY.constant = 0;
         
        }];

        
    }
  
    
  
}
-(void)playbackRate
{
    if(self.smoothView.alpha==0){
        self.smooth.hidden = NO;
    
        self.smooth.alpha = 1;
        self.smoothView.alpha = 1;
        self.smoothYY.constant = 0;
        
        
        NSMutableArray *array = [NSMutableArray array];
        
        
        [array addObject: @{@"speed":@"0.7",@"name":@"0.7X"}];
        [array addObject: @{@"speed":@"1.0",@"name":@"1.0X"}];
        [array addObject: @{@"speed":@"1.2",@"name":@"1.2X"}];
        [array addObject: @{@"speed":@"1.5",@"name":@"1.5X"}];
        for (int i = 0; i<array.count; i++) {
            videoDefinition *btn111 = [[videoDefinition alloc]init];
            NSDictionary*dict =   array[i];
            
            [btn111 setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
            btn111.frame = CGRectMake(0, i*self.smoothView.frame.size.height/array.count, 50, self.smoothView.frame.size.height/array.count);
            
    
            btn111.titleLabel.font = [UIFont boldSystemFontOfSize:14];
             btn111.speed = [dict[@"speed"] floatValue];
            //默认项
            if ([dict[@"name"]  isEqualToString:self.smooth.titleLabel.text]) {

                
                btn111.contentHorizontalAlignment = UIControlStateNormal;

                [btn111 setTitle:dict[@"name"] forState:UIControlStateNormal];

                [btn111 setTitleColor:[UIColor yellowColor]forState:UIControlStateNormal];
                
               
            }else{
                  btn111.contentHorizontalAlignment = UIControlStateNormal;
                  [btn111 setTitle: dict[@"name"] forState:UIControlStateNormal];
            }
            
            [btn111 addTarget:self action:@selector(playbackRateButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.smoothView addSubview:btn111];
        }
    }else{
        self.smoothView.alpha = 0;
        
        self.smoothYY.constant = -100;
   
        [self.smoothView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    
    
    
}

- (void)playbackRateButtonClick:(videoDefinition*)btn{
    //相同的 清晰度不用设置
    if(![self.smooth.titleLabel.text isEqualToString:btn.titleLabel.text ] ){
        
        if (self.playbackRateBlock) {
            self.playbackRateBlock(btn.speed);
        }
        
        [self.smooth  setTitle:btn.titleLabel.text forState:UIControlStateNormal];
        
    }
    
    self.smoothView.alpha = 0;
    
    self.smoothYY.constant = -100;
    
    
    [self.smoothView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
}

- (void)buttonClick:(videoDefinition*)btn{
    //相同的 清晰度不用设置
    if(![self.smooth.titleLabel.text isEqualToString:btn.titleLabel.text ] ){
        
        if (self.definitionBlock) {
              self.definitionBlock(btn.key);
        }
      
           [self.smooth  setTitle:btn.titleLabel.text forState:UIControlStateNormal];
        
    }
    
     self.smoothView.alpha = 0;
    
     self.smoothYY.constant = -100;

  [self.smoothView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
   
}

- (void)dealloc
{
    [self timeFireMethod];
}
@end
