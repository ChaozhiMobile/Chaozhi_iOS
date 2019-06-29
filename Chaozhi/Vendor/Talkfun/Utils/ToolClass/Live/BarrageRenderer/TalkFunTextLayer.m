//
//  TalkFunTextLayer.m
//  MTGraphics
//
//  Created by 莫瑞权 on 2018/7/21.
//  Copyright © 2018年 MT. All rights reserved.
//

#import "TalkFunTextLayer.h"

@interface TalkFunTextLayer ()<CAAnimationDelegate>
@end
@implementation TalkFunTextLayer

+(CGSize)getTextWidth:(NSString*)content ontOfSize:(CGFloat)Font
{
    // 设置字体
    UIFont *font =  [UIFont fontWithName:@"Euphemia UCAS" size:Font];
    
    //位置
    NSString *name =    [TalkFunTextLayer replaceUnicodeTest:content?content:@""];

    NSDictionary *attrs = @{NSFontAttributeName : font};
    //位置
    CGSize attrsSize=[name sizeWithAttributes:attrs];

    return attrsSize;
}
+ (TalkFunTextLayer *)singleLinePathStandard:(NSString *)text  withFont:(CGFloat)Font  withPosition:(CGPoint)position textColor:(UIColor *)textColor

{
    
    TalkFunTextLayer *textLayer = [TalkFunTextLayer layer];

    // 设置字体
    UIFont *font =  [UIFont fontWithName:@"Euphemia UCAS" size:Font];
    
    //位置
    NSString *name =    [TalkFunTextLayer replaceUnicodeTest:text?text:@""];
    
    

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
    textLayer.foregroundColor = textColor.CGColor;
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
    return textLayer;
}

+ (NSString *)replaceUnicodeTest:(NSString *)test

{// test为需要解码的字符串
    return test;
//    NSString *body = test;
//
//    NSMutableString *mutableStr = [[NSMutableString alloc] initWithCapacity:1];
//
//    NSScanner*scanner=[NSScanner scannerWithString:body];
//
//    [scanner setCaseSensitive:YES]; // yes 区分大小写
//
//    NSString *keyString01 = @"%";
//
//    NSRange range = [test rangeOfString:keyString01];
//    if (range.location == NSNotFound)
//    {
//
////        NSLog(@"test中没有找到");
//
//    }else {
//
//        return test;
//
//    }
//
//    int lastPos = 0;  int pos = 0;
//
//    while (lastPos < body.length) {
//
//        @autoreleasepool{
//
//            pos = [self indexOf:body andPre:keyString01 andStartLocation:lastPos];
//
//            if (pos == lastPos) {
//
//                // 转为unicode 编码 再解码
//
//                if ([body characterAtIndex:(pos + 1)] == 'u') {
//
//                    NSRange range = NSMakeRange(pos, 6);
//
//                    NSString *tempBody =[body substringWithRange:range];
//
//                    NSString *temp01 = [tempBody stringByReplacingOccurrencesOfString:@"%" withString:@"\\"];
//
//                    NSString *temp02 = [TalkFunTextLayer replaceUnicode:temp01]; // 转为中文
//
//                    //                NSLog(@"--%@",temp02);
//
//                    [mutableStr appendString:temp02];
//
//                    lastPos = pos + 6;
//
//                } else {
//
//                    NSRange range = NSMakeRange(pos, 3);
//
//                    NSString *tempBody =[body substringWithRange:range];
//
//                    NSString *temp01 = [tempBody stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//
//                    //                    NSLog(@"--%@",temp01);
//
//                    [mutableStr appendString:temp01];
//
//                    lastPos = pos + 3;
//
//                }
//
//            }else if (pos == -1) {
//
//                NSString *tempBody =[body substringFromIndex:lastPos];
//
//                [mutableStr appendFormat:@"%@",tempBody];
//
//                lastPos = (int)body.length;
//
//            }else {
//
//                NSRange range = NSMakeRange(lastPos, pos-lastPos);
//
//                NSString *tempBody =[body substringWithRange:range];
//
//                [mutableStr appendString:tempBody];
//
//                lastPos = pos;
//
//            }
//
//        }
//
//    }
//
//
//
//    return mutableStr;
//
}
+ (NSString *)replaceUnicode:(NSString *)msg

{
    
    NSString *tempStr1 = [msg stringByReplacingOccurrencesOfString:@"\\u" withString:@"\\U"];
    
    NSString *tempStr2 = [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\""];
    
    NSString *tempStr3 = [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF16StringEncoding];
    
  
    NSString* returnStr =  [NSPropertyListSerialization propertyListWithData:tempData options:NSPropertyListImmutable format:NULL error:NULL];
    

    
    return [returnStr stringByReplacingOccurrencesOfString:@"\\r\\n" withString:@"\n"];
    
    
  
    
}
// 查找有咩有百分号 并返回ta的位置
+ (int)indexOf:(NSString *)allStr andPre:(NSString *)pre andStartLocation:(int)StartLocation
{
    
    NSString *body = [allStr substringFromIndex:StartLocation];
    
    NSScanner*scanner=[NSScanner scannerWithString:body];
    
    NSString *keyString01 = pre;
    
    [scanner setCaseSensitive:YES]; // yes 区分大小写
    
    BOOL b = NO;
    
    int returnInt = 0;
    
    while (![scanner isAtEnd]) {
        
        b = [scanner scanString:keyString01 intoString:NULL];
        
        if(b) {
            
            returnInt = StartLocation + (int)scanner.scanLocation - 1;
            
            break;
            
        }

        scanner.scanLocation++;
        
    }
    
    if (!b) {
        
        returnInt = -1;
        
    }
    
    return returnInt;
    
    
    
}
- (void)startAnimation
{
    CAKeyframeAnimation * ani = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    ani.duration = 9.0;
    ani.removedOnCompletion = NO;
    ani.fillMode = kCAFillModeForwards;
//    速度控制函数数组
    ani.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//    self.Hide_X
    NSValue *value1= [NSValue   valueWithCGPoint:CGPointMake(self.Hide_X, 0)];
    NSValue *value5=[NSValue  valueWithCGPoint:CGPointMake(-self.contentWidth , 0)];
    ani.delegate = self;
    
    ani.values = @[value1, value5];
    
    [self addAnimation:ani forKey:@"PostionKeyframeValueAni"];
}


//动画开始时调用
/* Called when the animation begins its active duration. */

- (void)animationDidStart:(CAAnimation *)anim
{
    
}
//动画结束时调用
/* Called when the animation either completes its active duration or
 * is removed from the object it is attached to (i.e. the layer). 'flag'
 * is true if the animation reached the end of its active duration
 * without being removed. */

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    
    if (_myBlock) {
        if(self.Y_arr){
              _myBlock(self.Y_arr);
        }
      
    }
    //做完动画删除
    
    dispatch_async(dispatch_get_main_queue(), ^{
            [self removeFromSuperlayer];

    });

}
@end
