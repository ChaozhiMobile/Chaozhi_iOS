//
//  TalkfunSignViewController.m
//  TalkfunSDKDemo
//
//  Created by moruiwei on 2017/10/18.
//  Copyright © 2017年 Talkfun. All rights reserved.
//

#import "TalkfunSignViewController.h"

@interface TalkfunSignViewController ()
//定时器
@property (nonatomic,strong)   NSTimer *timer;

@property (weak, nonatomic) IBOutlet UILabel *durationLab;

//签到 倒计时
@property(nonatomic,assign)int duration;

@property(nonatomic,strong)NSString*signId;

//弹窗的VIew
@property (weak, nonatomic) IBOutlet UIView *window;

@property (weak, nonatomic) IBOutlet UIButton *signLab;
@property (weak, nonatomic) IBOutlet UIView *vc;

@end

@implementation TalkfunSignViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.window.layer.cornerRadius = 6;
    self.signLab.layer.cornerRadius = 6;
    self.vc.layer.cornerRadius = 6;
//    label.textAlignment = UITextAlignmentCenter;
    //
    //            CGFloat    width  = weakSelf.view.frame.size.width *0.65;
    //
    //            CGFloat    height = width*0.6;
    
    //            CGRectMake((weakSelf.view.frame.size.width -width)/2, (weakSelf.view.frame.size.height-height)/2, width, height);
    
    
}


- (void)refreshUIWithParams:(NSDictionary *)singnDict
{
    NSLog(@"singnDict==.%@",singnDict);
    //    data = {
    //        signId = "2967";
    //        time = "2017-10-18 16:41:41";
    //        nickname = "莫瑞权";
    //        role = "spadmin";
    //        duration = 60;
    //    };
    
    self.signId = singnDict[@"data"][@"signId"];
    [self.timer invalidate];
    self.timer  = nil;
    self.duration = [singnDict[@"data"][@"duration"] intValue];
    
    self.durationLab.text =  [NSString stringWithFormat:@"倒计时: %i 秒",self.duration];
    self.view.alpha = 1;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES];
   [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}
- (void)timeFireMethod
{
    
    if (self.duration>0) {
        
         self.duration  = self.duration -1;
          self.durationLab.text =  [NSString stringWithFormat:@"倒计时: %i 秒",self.duration];
        
        
    }else if(self.duration==0){
        
        self.durationLab.text =  [NSString stringWithFormat:@"倒计时: %i 秒",self.duration];
        
         [self.timer invalidate];
          self.timer  = nil;
         [self deleteClicked];
    }
   
    
  
}
//删除键按钮事件
- (IBAction)deleteBtnClicked:(UIButton *)sender
{
    [self deleteClicked];
    
}


- (void)deleteClicked
{

 
    if(self.timer){
        [self.timer invalidate];
        self.timer  = nil;
        self.duration = 0;
        self.durationLab.text =@"";
        
        [UIView animateWithDuration:0.5 animations:^{
            
            self.view.alpha = 0.0;
            
        } completion:^(BOOL finished) {
            
            //        [self.view removeFromSuperview];
            
        }];
    }else{
//        [self.timer invalidate];
//        self.timer  = nil;
//        self.duration = 0;
//        self.durationLab.text =@"";
    
        self.view.alpha = 0.0;
    }
    
}

- (IBAction)signBtnClick:(id)sender {
    
    //发签到请求

    
    
    if (_signIdBlock) {
        _signIdBlock(self.signId);
    }
    

    
//     [self deleteClicked];
    
}


@end
