//
//  AEIndicator.m
//  ArtEast
//
//  Created by yibao on 16/9/22.
//  Copyright © 2016年 北京艺宝网络文化有限公司. All rights reserved.
//

#import "AEIndicator.h"

static AEIndicator *indicator;

@implementation AEIndicator

+ (AEIndicator *)sharedIndicator {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        indicator = [[self alloc] init];
    });
    return indicator; 
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.frame = CGRectMake(WIDTH/2-50, HEIGHT/2-27.5, 100, 55);
        [[UIApplication sharedApplication].keyWindow addSubview:self];
        _isAnimating = NO;
        _loadtext = @"努力加载中...";
        
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(37.5,15,25,25)];
        [self addSubview:imageView];
        //设置动画帧
        imageView.animationImages=[NSArray arrayWithObjects: [UIImage imageNamed:@"ic_indicator_image_01"],
                                   [UIImage imageNamed:@"ic_indicator_image_02"],
                                   [UIImage imageNamed:@"ic_indicator_image_03"],
                                   [UIImage imageNamed:@"ic_indicator_image_04"],
                                   [UIImage imageNamed:@"ic_indicator_image_04"],
                                   [UIImage imageNamed:@"ic_indicator_image_05"],
                                   [UIImage imageNamed:@"ic_indicator_image_06"],
                                   [UIImage imageNamed:@"ic_indicator_image_07"],
                                   [UIImage imageNamed:@"ic_indicator_image_08"],
                                   [UIImage imageNamed:@"ic_indicator_image_09"],
                                   [UIImage imageNamed:@"ic_indicator_image_10"],
                                   [UIImage imageNamed:@"ic_indicator_image_11"],
                                   [UIImage imageNamed:@"ic_indicator_image_12"],
                                   nil ];
        
        Infolabel = [[UILabel alloc]initWithFrame:CGRectMake(10, self.height-20, self.width-10, 20)];
        Infolabel.backgroundColor = [UIColor clearColor];
        Infolabel.textAlignment = NSTextAlignmentCenter;
        Infolabel.textColor = [UIColor clearColor];
        Infolabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:Infolabel];
        self.layer.hidden = YES;
    }
    return self;
}

- (void)startAnimation
{
    _isAnimating = YES;
    self.layer.hidden = NO;
    [self doAnimation];
}

- (void)doAnimation{
    
    Infolabel.text = _loadtext;
    //设置动画总时间
    imageView.animationDuration=1.0;
    //设置重复次数,0表示不重复
    imageView.animationRepeatCount=0;
    //开始动画
    [imageView startAnimating];
}

- (void)stopAnimationWithLoadText:(NSString *)text withType:(BOOL)type;
{
    _isAnimating = NO;
    Infolabel.text = text;
    if(type){
        
        [UIView animateWithDuration:0.3f animations:^{
            self.alpha = 0;
        } completion:^(BOOL finished) {
            [imageView stopAnimating];
            self.layer.hidden = YES;
            self.alpha = 1;
        }];
    }else{
        [imageView stopAnimating];
        [imageView setImage:[UIImage imageNamed:@"ic_indicator_image_03"]];
    }
}

- (void)setLoadText:(NSString *)text;
{
    if(text){
        _loadtext = text;
    }
}

@end
