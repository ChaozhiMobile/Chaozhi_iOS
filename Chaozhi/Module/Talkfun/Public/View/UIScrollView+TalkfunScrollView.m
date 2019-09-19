//
//  UIScrollView+TalkfunScrollView.m
//  TalkfunSDKDemo
//
//  Created by 孙兆能 on 2016/11/19.
//  Copyright © 2016年 talk-fun. All rights reserved.
//

#import "UIScrollView+TalkfunScrollView.h"

@implementation UIScrollView (TalkfunScrollView)

- (id)initScrollViewWithTarget:(id)target frame:(CGRect)frame
{
    self = [super init];
    if (self) {
        self = [[UIScrollView alloc] initWithFrame:frame];
        
        self.pagingEnabled                  = YES;
        self.backgroundColor                = [UIColor whiteColor];
        self.delegate                       = target;
        self.bounces                        = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator   = NO;
    }
    return self;
}
//- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
//    
//    
//    /*
//     直接拖动UISlider，此时touch时间在150ms以内，UIScrollView会认为是拖动自己，从而拦截了event，导致UISlider接受不到滑动的event。但是只要按住UISlider一会再拖动，此时此时touch时间超过150ms，因此滑动的event会发送到UISlider上。
//     */
//    UIView *view = [super hitTest:point withEvent:event];
//    
//    if([view isKindOfClass:[UISlider class]])
//    {
//        //如果响应view是UISlider,则scrollview禁止滑动
//        self.scrollEnabled = NO;
//    }
//    else
//    {   //如果不是,则恢复滑动
//        self.scrollEnabled = YES;
//    }
//    return view;
//}


@end
