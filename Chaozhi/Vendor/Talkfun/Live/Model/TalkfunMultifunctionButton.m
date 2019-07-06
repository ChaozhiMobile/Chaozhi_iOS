//
//  TalkfunXiaoBanToolButton.m
//  TalkfunSDKDemo
//
//  Created by 莫瑞权 on 2018/9/12.
//  Copyright © 2018年 Talkfun. All rights reserved.
//

#import "TalkfunMultifunctionButton.h"
#import "TalkfunMultifunctionTool.h"
#define ColorFromRGB(r,g,b) [UIColor colorWithRed:(float)r/255.0 green:(float)g/255.0 blue:(float)b/255.0 alpha:0.5]
@interface TalkfunMultifunctionButton ()<CAAnimationDelegate>
@property(nonatomic,strong)CALayer *  loadingLayer;
@property(nonatomic,strong)CAShapeLayer *  redDotLayer;

@end
@implementation TalkfunMultifunctionButton
//画红点点
- (void)drawRedDot
{
    if(self.redDotLayer==nil){
        CGRect frame = CGRectMake(0, 0,self.frame.size.width/6, self.frame.size.width/6);
        self.redDotLayer = [CAShapeLayer layer];
        // 指定frame，只是为了设置宽度和高度
        self.redDotLayer.frame = frame;
        // 设置居中显示
        self.redDotLayer.position = CGPointMake((self.frame.size.width/2)+(self.frame.size.width/2/2), ((self.frame.size.height/2)-(self.frame.size.height/2/2)));
        
        self.redDotLayer.fillColor = [UIColor redColor].CGColor;
        // 设置线宽
        self.redDotLayer.lineWidth = 1;
        // 设置线的颜色
        self.redDotLayer.strokeColor = [UIColor redColor].CGColor;
        // 使用UIBezierPath创建路径
        UIBezierPath *circlePath = [UIBezierPath bezierPathWithOvalInRect:frame];
        // 设置CAShapeLayer与UIBezierPath关联
        self.redDotLayer.path = circlePath.CGPath;
        self.redDotLayer.strokeStart = 0.0;
        self.redDotLayer.strokeEnd =   1.0;
        // 将CAShaperLayer放到某个层上显示
        [self.layer addSublayer:self.redDotLayer];
    }
    
}

//清除小红点
- (void)clearRedDot
{

    if (self.redDotLayer) {
        [self.redDotLayer removeFromSuperlayer];
        self.redDotLayer  = nil;
    }
   
}


- (void)rotationAnimation{
    
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    rotationAnimation.duration = 2;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = 1;
    rotationAnimation.delegate = self;
    [self.loadingLayer  addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}
// 画弧线
- (void)startDrawHalfCircle {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.loadingLayer==nil) {
            _loadingLayer = [CALayer layer];
            _loadingLayer.frame = CGRectMake(0, 0, self.frame.size.width , self.frame.size.height);
            
               UIColor *sendBorderColor =         [ TalkfunMultifunctionTool colorWithHexString:@"CCCCCC" alpha:1];
            _loadingLayer.backgroundColor = sendBorderColor.CGColor;
            [self.layer addSublayer:_loadingLayer ];
            
         
            
            //创建圆环
            CGRect frame = CGRectMake(0, 0, self.frame.size.height-2, self.frame.size.height-2);
            CAShapeLayer *circleLayer = [CAShapeLayer layer];
            // 指定frame，只是为了设置宽度和高度
            circleLayer.frame = frame;
            // 设置居中显示
            circleLayer.position = CGPointMake(self.frame.size.height/2, self.frame.size.height/2);
            // 设置填充颜色
            circleLayer.fillColor = [UIColor clearColor].CGColor;
            // 设置线宽
            circleLayer.lineWidth = 2;
            // 设置线的颜色
            circleLayer.strokeColor = [UIColor yellowColor].CGColor;
            // 使用UIBezierPath创建路径
            UIBezierPath *bezierPath = [UIBezierPath bezierPathWithOvalInRect:frame];
            // 设置CAShapeLayer与UIBezierPath关联
            circleLayer.path = bezierPath.CGPath;
            [_loadingLayer setMask:circleLayer];
            
            
            
            
            //颜色渐变
            NSMutableArray *colors = [NSMutableArray arrayWithObjects:(id)sendBorderColor.CGColor,(id)[ColorFromRGB(255, 255, 255) CGColor], nil];
            CAGradientLayer *gradientLayer = [CAGradientLayer layer];
            gradientLayer.shadowPath = bezierPath.CGPath;
            gradientLayer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height/2);
            gradientLayer.startPoint = CGPointMake(1, 0);
            gradientLayer.endPoint = CGPointMake(0, 0);
            [gradientLayer setColors:[NSArray arrayWithArray:colors]];
            
            NSMutableArray *colors1 = [NSMutableArray arrayWithObjects:(id)[ColorFromRGB(255, 255, 255) CGColor],(id)[[UIColor whiteColor] CGColor], nil];
            CAGradientLayer *gradientLayer1 = [CAGradientLayer layer];
            gradientLayer1.shadowPath = bezierPath.CGPath;
            gradientLayer1.frame = CGRectMake(0, self.frame.size.height/2, self.frame.size.width, self.frame.size.height/2);
            gradientLayer1.startPoint = CGPointMake(0, 1);
            gradientLayer1.endPoint = CGPointMake(1, 1);
            [gradientLayer1 setColors:[NSArray arrayWithArray:colors1]];
            [_loadingLayer addSublayer:gradientLayer]; //设置颜色渐变
            [_loadingLayer addSublayer:gradientLayer1];
            
            [self rotationAnimation];
        }
        
    });
    
}
- (void)stopDrawHalfCircle
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.loadingLayer) {
            [self.loadingLayer removeFromSuperlayer];
            self.loadingLayer  = nil;
        }
        
        
    });
   
}

//动画结束时调用
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if ( self.loadingLayer) {
         [self rotationAnimation];
    }
   
}
- (void)setBackButton
{
    CGFloat imageViewW = self.frame.size.width/2;
    CGFloat imageViewY =self.frame.size.height/2 -imageViewW/2;
    CGFloat imageViewX  = 0;
    self.imageView.frame = CGRectMake(imageViewX,imageViewY , imageViewW, imageViewW);
    self.imageView.backgroundColor = [UIColor clearColor];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
}


- (void)layoutSubviews
{
    // 先让父类布局子控件
    [super layoutSubviews];
    
    if (self.isBackButton ) {
        /****按钮 ****/
        CGFloat imageViewW = self.frame.size.width/2;
        CGFloat imageViewY =self.frame.size.height/2 -imageViewW/2;
        CGFloat imageViewX  = 0;
        self.imageView.frame = CGRectMake(imageViewX,imageViewY , imageViewW, imageViewW);
        self.imageView.backgroundColor = [UIColor clearColor];
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    }

}
@end
