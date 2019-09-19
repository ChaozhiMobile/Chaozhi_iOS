//
//  TalkfunWatermark.h
//  TalkfunSDKDemo
//
//  Created by 莫瑞权 on 2019/1/11.
//  Copyright © 2019年 Talkfun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TalkfunWatermark : NSObject

//设置水印
+ (CATextLayer *)singleLinePathStandard:(NSString *)text  withFont:(CGFloat)Font  withPosition:(CGPoint)position textColor:(UIColor *)textColor;
//获取水印内容
+ (NSDictionary*)getWatermarkName:(NSDictionary*)obj;
@end


