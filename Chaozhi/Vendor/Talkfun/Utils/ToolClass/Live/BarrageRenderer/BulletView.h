//
//  BulletView.h
//  MTGraphics
//
//  Created by 莫瑞权 on 2018/7/24.
//  Copyright © 2018年 MT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BulletView : UIView


//弹幕开关  //默认为YES

@property(nonatomic,assign)BOOL bulletSwitch;

//屏幕上的所有弹幕数
- (NSInteger)getBulletCount;


//content        内容
//fontSize       字体大小
//Color          字体颜色
- (void)initWithContent:(NSString *)content ontOfSize:(CGFloat)fontSize  textColor:(UIColor *)Color;


//清空所有弹幕
- (void)stopAnimation;

@end
