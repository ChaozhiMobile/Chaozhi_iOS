//
//  BottomLineView.m
//  SuperMarket
//
//  Created by hanzhanbing on 16/7/15.
//  Copyright © 2016年 柯南. All rights reserved.
//

#import "BottomLineView.h"

@implementation BottomLineView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [_lineColer CGColor]);
    CGContextFillRect(context, CGRectInset(rect, 1.0, 0));
}

@end
