//
//  TalkFunTextLayer.h
//  MTGraphics
//
//  Created by 莫瑞权 on 2018/7/21.
//  Copyright © 2018年 MT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface TalkFunTextLayer : CATextLayer


typedef void(^animationDidStopBlock)(NSMutableArray *Y_arr);

@property (nonatomic, strong) animationDidStopBlock myBlock;

@property(nonatomic,strong)NSMutableArray *Y_arr;//弹幕占用的Y值
@property(nonatomic,assign)CGFloat contentWidth;//内容宽度
@property(nonatomic,assign)CGFloat Hide_X; //左边的X




+ (TalkFunTextLayer *)singleLinePathStandard:(NSString *)text  withFont:(CGFloat)Font  withPosition:(CGPoint)position textColor:(UIColor *)textColor;


+ (NSString *)replaceUnicodeTest:(NSString *)test;

+(CGSize)getTextWidth:(NSString*)content ontOfSize:(CGFloat)Font;


- (void)startAnimation;





@end
