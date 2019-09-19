//
//  barrageSwitch.m
//  TalkfunSDKDemo
//
//  Created by moruiwei on 16/11/15.
//  Copyright © 2016年 talk-fun. All rights reserved.
//

#import "barrageSwitch.h"
@interface barrageSwitch()

@end
@implementation barrageSwitch


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        
    self.barrage  = [[UILabel alloc]init];
      
  
    self.barrage .textColor = [UIColor colorWithRed:150 / 255.0 green:150 / 255.0 blue:150 / 255.0 alpha:1] ;
     self.barrage .font = [UIFont boldSystemFontOfSize:15];
        
        self.barrage .textAlignment = NSTextAlignmentLeft;
        [self addSubview:self.barrage ];
    }
    return self;
}
-(CGFloat)getWidthWithTitle:(NSString *)title font:(UIFont *)font {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 1000, 0)];
    label.text = title;
    label.font = font;
    [label sizeToFit];
    return label.frame.size.width;
}


- (void)layoutSubviews
{
   
    

    self.barrage.text = @"弹";

    
   
self.transform = CGAffineTransformMakeScale(0.75, 0.75);
    // 一定要调用super方法
    [super layoutSubviews];
}

@end
