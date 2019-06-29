//
//  TalkfunWatermark.m
//  TalkfunSDKDemo
//
//  Created by 莫瑞权 on 2019/1/11.
//  Copyright © 2019年 Talkfun. All rights reserved.
//

#import "TalkfunWatermark.h"
#define UIColorFromRGB(r,g,b) [UIColor colorWithRed:(float)r/255.0 green:(float)g/255.0 blue:(float)b/255.0 alpha:0.5]
@implementation TalkfunWatermark
+ (CATextLayer *)singleLinePathStandard:(NSString *)text  withFont:(CGFloat)Font  withPosition:(CGPoint)position textColor:(UIColor *)textColor

{
    
    CATextLayer *textLayer = [CATextLayer layer];
    
    // 设置字体
    UIFont *font =  [UIFont fontWithName:@"Euphemia UCAS" size:Font];
    
    //位置
    NSString *name =    text;
    
    
    
    NSDictionary *attrs = @{NSFontAttributeName : font};
    //位置
    CGSize attrsSize=[name sizeWithAttributes:attrs];
    
    CGFloat  hh = 0;
    
    if (Font<=20) {
        hh = 5;
    }
    
    textLayer.frame = CGRectMake(position.x, position.y, attrsSize.width, attrsSize.height +hh );
    
    textLayer.backgroundColor = [UIColor clearColor].CGColor;
    
    // 设置文字属性
    textLayer.foregroundColor = UIColorFromRGB(246,246,246).CGColor;
    textLayer.alignmentMode = kCAAlignmentLeft;
    textLayer.wrapped = NO;
    
    CFStringRef fontName = (__bridge CFStringRef)(font.fontName);
    CGFontRef fontRef = CGFontCreateWithFontName(fontName);
    textLayer.font = fontRef;
    textLayer.fontSize = font.pointSize;
    CGFontRelease(fontRef);
    
    // 选择文本
    textLayer.string = name;
    textLayer.contentsScale = [UIScreen mainScreen].scale;
    textLayer.shadowOpacity = 0.8;
    
    
    textLayer.shadowOffset = CGSizeMake(0, 1);
    textLayer.shadowRadius = 3.0;
    
    return textLayer;
}

+ (NSDictionary*)getWatermarkName:(NSDictionary*)obj
{
    
     NSString *watermarkName = @"";
    
     NSString *enable  = @"";
    
    if ([obj[@"roomInfo"] isKindOfClass:[NSDictionary class]]) {
        //水印的数据
        if ([obj[@"roomInfo"][@"mod_theftproof"]isKindOfClass:[NSDictionary class]]) {
            
            //
            NSDictionary *mod_theftproof_live = obj[@"roomInfo"][@"mod_theftproof"];
            
            if ([mod_theftproof_live[@"enable"] isKindOfClass:[NSString class ]]) {
               enable = mod_theftproof_live[@"enable"] ;
            }
            if ([mod_theftproof_live[@"enable"] isKindOfClass:[NSNumber class ]]) {
                
                NSNumber  *num = (NSNumber*) mod_theftproof_live[@"enable"];
                
                enable = [NSNumberFormatter localizedStringFromNumber:num numberStyle:NSNumberFormatterNoStyle];

            }
     
                //打开水印
            
                if ([obj[@"roomInfo"] isKindOfClass:[NSDictionary class] ]) {
                    
                    if (obj[@"roomInfo"][@"me"][@"xid"]) {
                        watermarkName =   obj[@"roomInfo"][@"me"][@"xid"];
                    }
                    if (obj[@"roomInfo"][@"me"][@"uid"]) {
                        watermarkName =   obj[@"roomInfo"][@"me"][@"uid"];
                    }
                
            }
            
        }
    }
    
    return @{@"watermarkName":watermarkName ,@"enable":enable};
}
@end
