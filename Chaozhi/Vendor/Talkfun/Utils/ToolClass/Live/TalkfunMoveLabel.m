//
//  TalkfunMoveLabel.m
//  TalkfunSDKDemo
//
//  Created by 莫瑞权 on 2018/7/27.
//  Copyright © 2018年 Talkfun. All rights reserved.
//

#import "TalkfunMoveLabel.h"

@implementation TalkfunMoveLabel

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    
    
}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    
    
  
    // 拿到UITouch就能获取当前点
    UITouch *touch = [touches anyObject];
    // 获取当前点
    CGPoint curP = [touch locationInView:self];
    // 获取上一个点
    CGPoint preP = [touch previousLocationInView:self];
  
    // 获取手指y轴偏移量
    CGFloat offsetY = curP.y - preP.y;
    
    
    CGFloat    offsetX = curP.x - preP.x;

    
    
    if (self.frame.origin.x +offsetX>0   &&self.frame.origin.y+offsetY>0) {
         self.frame = CGRectMake(self.frame.origin.x +offsetX, self.frame.origin.y+offsetY, self.frame.size.width,  self.frame.size.height);
    }
    
   

}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    if (self.frame.origin.x<=0) {
          self.frame = CGRectMake(0, self.frame.origin.y, self.frame.size.width,  self.frame.size.height);
    }
    
    
    if (self.frame.origin.x>self.superview.frame.size.width -self.frame.size.width) {
         self.frame = CGRectMake(self.superview.frame.size.width -self.frame.size.width, self.frame.origin.y, self.frame.size.width,  self.frame.size.height);
    }
    
    
    
    
    
    if (self.frame.origin.y<=0) {
        self.frame = CGRectMake(self.frame.origin.x, 0, self.frame.size.width,  self.frame.size.height);
    }
    
    
    if (self.frame.origin.y>self.superview.frame.size.height -self.frame.size.height) {
        self.frame = CGRectMake(self.frame.origin.x,self.superview.frame.size.height -self.frame.size.height, self.frame.size.width,  self.frame.size.height);
    }
    
    
}


@end
