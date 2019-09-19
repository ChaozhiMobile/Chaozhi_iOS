//
//  evaluateController.m
//  LEEStarRating
//
//  Created by 莫瑞权 on 2018/8/14.
//  Copyright © 2018年 lee. All rights reserved.
//

#import "evaluateView.h"
#define UIColorFromRGB(r,g,b) [UIColor colorWithRed:(float)r/255.0 green:(float)g/255.0 blue:(float)b/255.0 alpha:1.0]
#import "TalkfunLEEStarRating.h"
@interface evaluateView ()<UITextViewDelegate,UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;

@property (weak, nonatomic) IBOutlet UIView *vc1;

@property (weak, nonatomic) IBOutlet UIView *one;
@property (weak, nonatomic) IBOutlet UIView *two;
@property (weak, nonatomic) IBOutlet UIView *three;
@property (weak, nonatomic) IBOutlet UITextView *textView;



@property (weak, nonatomic) IBOutlet UILabel *onetext;

@property (weak, nonatomic) IBOutlet UILabel *twoText;

@property (weak, nonatomic) IBOutlet UILabel *threText;

@property (weak, nonatomic) IBOutlet UILabel *leaveAmessageText;

@property (weak, nonatomic) IBOutlet UIButton *exitBtn;
@property(nonatomic,strong)UILabel*  label;

@property(nonatomic,strong)NSMutableDictionary*dict;
@end

@implementation evaluateView
- (BOOL)getIsIpad

{
    
    NSString *deviceType = [UIDevice currentDevice].model;
    
    
    
    if([deviceType isEqualToString:@"iPhone"]) {
        
        //iPhone
        
        return NO;
        
    }
    
    else if([deviceType isEqualToString:@"iPod touch"]) {
        
        //iPod Touch
        
        return NO;
        
    }
    
    else if([deviceType isEqualToString:@"iPad"]) {
        
        //iPad
        
        return YES;
        
    }
    
    return NO;
    
}

static BOOL TimeLabelShow = NO;
+ (id)initView{
    evaluateView * newFunctionView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil][0];
    TimeLabelShow = NO;
    return newFunctionView;
}
-(NSMutableDictionary*)dict
{
    if (_dict==nil) {
        _dict = [NSMutableDictionary dictionary];
    }
    return _dict;
}

- (void)layoutSubviews
{
  
//    dispatch_async(dispatch_get_main_queue(), ^{
           [super layoutSubviews];
   
    
        
    if ( self.label==nil) {
        

            self.onetext.font = [UIFont systemFontOfSize: 12.0];
            self.twoText.font = [UIFont systemFontOfSize: 12.0];
            self.threText.font = [UIFont systemFontOfSize: 12.0];
            self.leaveAmessageText.font = [UIFont systemFontOfSize: 14.0];

        UIColor *color2 =   UIColorFromRGB(97,188,230);
        self.submitBtn.backgroundColor = color2;
        self.submitBtn.imageView.backgroundColor = color2;
        
        UIColor *color =   UIColorFromRGB(194,202,210);
        UIColor *color1 =   UIColorFromRGB(255,255,255);
        UIColor *vc1color =   UIColorFromRGB(240,240,240);
        
        self.vc1.backgroundColor = vc1color;
        
        self.backgroundColor = color1;
        self.layer.cornerRadius = 8;
        
        self.vc1.layer.cornerRadius = 8;
        
        self.layer.borderColor = color.CGColor;
        self.textView.layer.cornerRadius = 6;
        self.textView.layer.borderWidth = 1;
        self.textView.layer.borderColor = color.CGColor;
        self.textView.backgroundColor = color1;
        
        self.submitBtn.layer.cornerRadius = 4;
        
        
        // 一定要调用super方法
        
        [self addRatingView:self.one fraction:30 tag:1];
        [self addRatingView:self.two fraction:30 tag:2];
        [self addRatingView:self.three fraction:40 tag:3];
        
        self.textView.delegate = self;
        self.label = [[UILabel alloc]initWithFrame:CGRectMake(6, 6, 200, 20)];
        self.label.enabled = NO;
        self.label.text = @"想对老师说点什么......";
        self.label.font =  [UIFont systemFontOfSize:14];
        self.label.textColor = [UIColor lightGrayColor];
        [self.textView addSubview:self.label];
    }
    
//    });
  
}

- (void)addRatingView:(UIView*)view  fraction:(NSInteger)fraction  tag:(NSInteger)tag{
    TalkfunLEEStarRating *ratingView = [[TalkfunLEEStarRating alloc] initWithFrame:CGRectMake(0,0,view.frame.size.width , view.frame.size.height) Count:5]; //初始化并设置frame和个数
//    ratingView.backgroundColor = [UIColor redColor];
    ratingView.height = view.frame.size.height;
    if ([self getIsIpad]) {
        ratingView.spacing = 16.0f; //间距
    }else{
         ratingView.spacing = 8; //间距
    }
   
    
    ratingView.checkedImage = [UIImage imageNamed:@"star_orange"]; //选中图片
    
    ratingView.uncheckedImage = [UIImage imageNamed:@"star_gray"]; //未选中图片
    
    ratingView.type = RatingTypeWhole; //评分类型
    
    ratingView.touchEnabled = YES; //是否启用点击评分 如果纯为展示则不需要设置
    //
    ratingView.slideEnabled = YES; //是否启用滑动评分 如果纯为展示则不需要设置
    //
    ratingView.maximumScore = fraction; //最大分数
    
    ratingView.minimumScore = 1; //最小分数
    ratingView.tag = tag;
    [view addSubview:ratingView];

    ratingView.currentScore = fraction;
    
    // 当前分数变更事件回调
    WeakSelf
    ratingView.currentScoreChangeBlock = ^(CGFloat score ,NSInteger tag){
        
        if (tag==2) {
            [weakSelf.dict setObject:@((NSInteger)score) forKey:@"contentScore"];//内容评分
        }else if (tag==1) {
            [weakSelf.dict setObject:@((NSInteger)score) forKey:@"methodScore"];//教学评分
        }else if (tag==3) {
            [weakSelf.dict setObject:@((NSInteger)score) forKey:@"effectScore"];//教学效果评分
        }
      
  
    };
    
  
    
}
- (IBAction)exit:(UIButton *)sender {

    if (self.exitBlock) {
        self.exitBlock(@{});
    }
}


//提交
- (IBAction)submit:(UIButton *)sender {
    
    if (self.currentScoreChangeBlock) {
        [self.dict setObject:self.textView.text?self.textView.text:@"" forKey:@"msg"];
        self.currentScoreChangeBlock(self.dict);
    }

}
- (void) textViewDidChange:(UITextView *)textView{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([textView.text length] == 0) {
            [self.label setHidden:NO];
        }else{
            [self.label setHidden:YES];
        }
        
    });
  
}


//}
@end
