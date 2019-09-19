//
//  TalkfunAdvertView.m
//  TalkfunSDKDemo
//
//  Created by 莫瑞权 on 2019/8/17.
//  Copyright © 2019 Talkfun. All rights reserved.
//

#import "TalkfunAdvertView.h"
#import "TalkfunCourseManagement.h"
#define ButtonViewHeight 35
#define KIsiPhoneX  @available(iOS 11.0, *) && UIApplication.sharedApplication.keyWindow.safeAreaInsets.bottom > 0.0
@interface TalkfunAdvertView()
@property (nonatomic,strong)UIView *first ;
@property (nonatomic,strong)UILabel *skipLabel;//跳过片头

@property (nonatomic,strong)UILabel *S_Label;//S

@property (nonatomic,strong)UIView *splitLine;//分割线

@property (nonatomic,strong)UIImageView *backImage;



@property (nonatomic,strong)UILabel *first_S_Label;
@property (nonatomic,strong)UIView *firstSplitLine;
//@property (nonatomic,assign)BOOL firstAcquisition ;
@property (nonatomic,assign)BOOL skip;
@end
@implementation TalkfunAdvertView
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
       
        self.videoView = [[UIView alloc]init];
        [self addSubview:self.videoView];
        
        
        self.back = [[UIButton alloc] init];
        self.back.backgroundColor = [UIColor colorWithRed:17/255.0 green:43/255.0 blue:68/255.0 alpha:0.7];
        [self addSubview:self.back];
        
        self.backImage = [[UIImageView alloc] init];
        self.backImage.image = [UIImage imageNamed:@"小班返回"];
        [self.back addSubview:self.backImage];
      
        self.prompt = [[UIButton alloc] init];
      
        self.prompt.backgroundColor = [UIColor colorWithRed:17/255.0 green:43/255.0 blue:68/255.0 alpha:0.7];
        self.prompt.layer.cornerRadius = 17.5;
        [self addSubview:self.prompt];
        
        self.skipLabel = [[UILabel alloc] init];
        self.skipLabel.numberOfLines = 0;
        [self.prompt addSubview:self.skipLabel];
        
//        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"跳过片头" attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang SC" size: 16],NSForegroundColorAttributeName: [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0]}];
//
//        self.skipLabel.attributedText = string;
        self.skipLabel.text = @"跳过片头";
     
        self.skipLabel.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
        self.skipLabel.font = [UIFont fontWithName:@"PingFang SC" size: 16];
        //秒
        self.secondLabel = [[UILabel alloc] init];
       
        self.secondLabel.numberOfLines = 0;
        [self.prompt addSubview:self.secondLabel];
        


        self.secondLabel.font = [UIFont fontWithName:@"PingFang SC" size: 16];
        self.secondLabel.textColor = [UIColor colorWithRed:255/255.0 green:210/255.0 blue:30/255.0 alpha:1.0];
        //---
        //S
        self.S_Label = [[UILabel alloc] init];
       
        self.S_Label.numberOfLines = 0;
        [self.prompt addSubview:self.S_Label];
        

        
        
        self.S_Label.text = @"S";
        self.S_Label.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
        self.S_Label.font = [UIFont fontWithName:@"PingFang SC" size: 16];
        
        
        
        self.splitLine = [[UIView alloc] init];
        self.splitLine.frame = CGRectMake(271,45,0.5,15);
        self.splitLine.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
        [self.prompt addSubview:self.splitLine];
        
        
        
        
        self.first = [[UIView alloc] init];
        
        self.first.backgroundColor = [UIColor colorWithRed:17/255.0 green:43/255.0 blue:68/255.0 alpha:0.7];
        
        self.first.layer.cornerRadius = 17.5;
        [self addSubview:self.first];
        
        
        //秒
        self.firstSecondLabel = [[UILabel alloc] init];
        self.firstSecondLabel.text = @"00";
        self.firstSecondLabel.numberOfLines = 0;
        [self.first addSubview:self.firstSecondLabel];
        self.firstSecondLabel.font = [UIFont fontWithName:@"PingFang SC" size: 16];
        self.firstSecondLabel.textColor = [UIColor colorWithRed:255/255.0 green:210/255.0 blue:30/255.0 alpha:1.0];
        //---
        //S
        self.first_S_Label = [[UILabel alloc] init];
        
        self.first_S_Label.numberOfLines = 0;
        [self.first addSubview:self.first_S_Label];
        

        
        
        self.first_S_Label.text = @"S";
        self.first_S_Label.textColor =[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
        self.first_S_Label.font = [UIFont fontWithName:@"PingFang SC" size: 16];
        
        
        //分割线
        self.firstSplitLine = [[UIView alloc] init];
        self.firstSplitLine.frame = CGRectMake(271,45,0.5,15);
        self.firstSplitLine.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
        [self.first addSubview:self.firstSplitLine];
        
        self.fullScreen = [[UIButton alloc] init];
        [self.fullScreen setImage:[UIImage imageNamed:@"广告全屏"] forState:UIControlStateNormal];
        [self.fullScreen setImage:[UIImage imageNamed:@"广告缩放"] forState:UIControlStateSelected];
       
        self.fullScreen.backgroundColor = [UIColor colorWithRed:17/255.0 green:43/255.0 blue:68/255.0 alpha:1.0];
        [self addSubview:self.fullScreen];
        
        self.secondLabel.textAlignment = NSTextAlignmentRight;
        self.firstSecondLabel.textAlignment = NSTextAlignmentRight;
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat promptY= 0;
    if (KIsiPhoneX) {
       promptY = 34 +15;
    }else{
       
       promptY =[[UIApplication sharedApplication] statusBarFrame].size.height + 15;
    }
    
    self.videoView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height );
    
    
    self.back.frame = CGRectMake(15,promptY,35,35);
    self.back.layer.cornerRadius = 17.5;
    self.backImage.frame = CGRectMake((self.back.frame.size.width - 9.3)/2,(self.back.frame.size.height - 16)/2,9.3,16);
    
    self.prompt.frame = CGRectMake(self.frame.size.width - 150 -15,promptY,146,35);
    
  
    CGFloat W =  64 + 10 + 0.5 +  +10 + 0.5 + 10 +20;
    
    CGFloat skipLabelX = (self.prompt.frame.size.width - W)/2 + + 10 + 0.5 +  +10 + 0.5 + 10 +20;
    //跳过片头
    self.skipLabel.frame = CGRectMake(skipLabelX,0,70,self.prompt.frame.size.height);
    //分割线
    self.splitLine.frame = CGRectMake(self.skipLabel.frame.origin.x -10 -0.5, 10, 0.5, 15);
    
    self.S_Label.frame = CGRectMake(self.splitLine.frame.origin.x -10 -0.5 -10, 0,10,self.prompt.frame.size.height);
    self.secondLabel.frame = CGRectMake(self.S_Label.frame.origin.x -26,11,26,12.5);
    
    self.first.frame = CGRectMake(self.frame.size.width - 58 -15,promptY,58,35);
    CGFloat firstSecondLabelW = 26;
    self.first_S_Label.frame = CGRectMake( (self.first.frame.size.width - 10 - firstSecondLabelW)/2 + firstSecondLabelW,0,10,self.prompt.frame.size.height);
    self.firstSecondLabel.frame = CGRectMake(self.first_S_Label.frame.origin.x -firstSecondLabelW,11,firstSecondLabelW,12.5);
    
    
     self.fullScreen.frame = CGRectMake(self.frame.size.width - 35 -10,self.frame.size.height - 35 -10,35,35);
    self.fullScreen.layer.cornerRadius = 35/2;
}

- (void)advertisingPlayStart:(TalkfunADConfig*)model   playbackID:(NSString *)playbackID
{
    NSInteger duration = model.duration;
        
    self.skip =  [TalkfunCourseManagement skipAdvertising:[playbackID integerValue]];
  
    //已经看完第一次广告,但是后台配置(isSkip)是不能跳过广告,所以不能跳过广告
    if(model.isSkip==NO){
        self.skip = NO;
    }
   
    
    if (duration<10) {
        if (self.skip) {
            
        self.secondLabel.text = [@"0" stringByAppendingString:[NSString stringWithFormat:@"%li",(long)duration]];
          
        self.first.hidden = YES;
          
            
        }else{
            
            self.firstSecondLabel.text = [@"0" stringByAppendingString:[NSString stringWithFormat:@"%li",(long)duration]];
            
            self.prompt.hidden = YES;
          
        }
        
        
    }else{
        if (self.skip) {
            self.secondLabel.text = [NSString stringWithFormat:@"%li",(long)duration];
           
          self.first.hidden = YES;
           
        }else{
            self.firstSecondLabel.text = [NSString stringWithFormat:@"%li",(long)duration];
           
                self.prompt.hidden = YES;
           
        }
        
    }
}

//广告倒计时
- (void)setSecond:(NSInteger)duration   playbackID:(NSString *)playbackID
{

    if (duration<10) {
        if (self.skip) {
             self.secondLabel.text = [@"0" stringByAppendingString:[NSString stringWithFormat:@"%li",(long)duration]];
           
            
        }else{
             self.firstSecondLabel.text = [@"0" stringByAppendingString:[NSString stringWithFormat:@"%li",(long)duration]];
         
        }
       
    }else{
          if (self.skip) {
            self.secondLabel.text = [NSString stringWithFormat:@"%li",(long)duration];
            
          }else{
                self.firstSecondLabel.text = [NSString stringWithFormat:@"%li",(long)duration];
              
          }
      
    }
  
    
}
//广告播放完成
- (void)advertisingPlaybackCompleted:(NSString*)playbackID
{
    //保存可以跳过
    [TalkfunCourseManagement saveSkip:[playbackID integerValue]];
    self.hidden = YES;
    self.skip   = NO;
}
@end
