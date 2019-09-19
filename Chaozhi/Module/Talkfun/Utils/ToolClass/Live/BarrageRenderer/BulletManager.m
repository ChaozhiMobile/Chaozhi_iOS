//
//  BulletManager.m
//  MTGraphics
//
//  Created by 莫瑞权 on 2018/7/23.
//  Copyright © 2018年 MT. All rights reserved.
//

#import "BulletManager.h"
@interface BulletManager()

//表情数组
@property(nonatomic,strong)NSArray *expressionArray;


@property(nonatomic,strong)TalkFunTextLayer *layer;

@property(nonatomic,strong)NSMutableDictionary *layerDict;
@end


@implementation BulletManager


- (NSArray *)expressionArray
{
    if(_expressionArray==nil){
        _expressionArray = @[@"[aha]",@"[hard]",@"[good]",@"[love]",@"[flower]",@"[cool]",@"[why]",@"[pitiful]",@"[amaz]",@"[bye]",@"[S_FLOWER]"];
    }
    return _expressionArray;
}


-(NSMutableDictionary *)layerDict
{
    if (_layerDict==nil) {
        _layerDict = [NSMutableDictionary dictionary];
    }
    return _layerDict;
}
- (NSMutableArray*)getexpressionArrayCopy:(NSString*)content
{
    NSMutableArray *expressionArrayCopy = [NSMutableArray array];
    
    for (NSString *name in self.expressionArray) {
        NSRange range11 = [content rangeOfString:name];
        
        if (range11.location == NSNotFound)
            
        {
            //  NSLog(@"未找到");
        }else {

            //存在的表情
            [expressionArrayCopy addObject:name];
        }
        
    }
    
    return expressionArrayCopy;
    
}


- (TalkFunTextLayer *)withContent:(NSString *)content ontOfSize:(CGFloat)fontSize startingPoint:(CGPoint)point textColor:(UIColor *)Color 
{
  
    TalkFunTextLayer *layer = [[TalkFunTextLayer alloc]init];
    
    
    NSMutableArray *temp = [NSMutableArray array];
    NSString *str = [NSString stringWithFormat:@"%@",content];
    

   NSMutableArray *expressionArrayCopy =  [self getexpressionArrayCopy:content];
 
    for (int i = 0; i<expressionArrayCopy.count; i++) {
     NSString *  name =   expressionArrayCopy[i];
        
    NSMutableArray *value  =  [self getRangeStr:content findText:name];
        
    for (NSNumber *inx in value) {
        
        [temp addObject:inx];
        
        //记录表情出现的位置
        [self.layerDict setObject:name forKey:inx];
    }
        //将字符串中"表情" 全部替换成 @"   "
        str = [str stringByReplacingOccurrencesOfString :name withString:@"   "];

    }
   
    
    //所有表情出现的位置, //升序
    NSArray *result = [temp sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2];
        }];
    
   
    
 

    //1.文字
    TalkFunTextLayer *textLayer  =  [TalkFunTextLayer singleLinePathStandard:str withFont:fontSize withPosition:CGPointMake(point.x, point.y) textColor:Color];
    textLayer.name = @"名字";

   layer.contentWidth  = [TalkFunTextLayer getTextWidth:str ontOfSize:fontSize].width;

    [layer addSublayer:textLayer];

    //计算表情的所在的位置
    NSMutableArray * ar__2 =  [self getRangeStr:str findText: @"   "];
    
   
    for (int i= 0; i<result.count; i++) {
      NSNumber *inx =  result[i];
    
        if (self.layerDict[inx]) {
            
        NSString *value =   self.layerDict[inx];

   
        CGSize   size =  [self contentCellHeightWithText:content ontOfSize:fontSize];
            
         

          CGFloat width_1= 0;
            
            //防止越界
            if(i<ar__2.count){
                if (ar__2[i]) {
                    
                    NSNumber *inx_1 =ar__2[i];
                    NSString *name =   [str substringToIndex: [inx_1  integerValue] ];
                    CGSize size_1 = [TalkFunTextLayer getTextWidth:name ontOfSize:fontSize];
                    
                    width_1 = size_1.width;
                    
                }
            }
       
        //一个字的宽度
       CGSize  size_2 =     [TalkFunTextLayer getTextWidth:@"1" ontOfSize:fontSize];
            
            value = [value stringByReplacingOccurrencesOfString :@"[" withString:@""];
            value = [value stringByReplacingOccurrencesOfString :@"]" withString:@""];
             //2.画图片
            CALayer *IMageLayer =   [self getIMageLayer:value Frame:CGRectMake(width_1+(size_2.width/4), point.y, size.height , size.height )];

        [layer addSublayer:IMageLayer];
  
        }
        
        
    }
    

    return layer;
}
//文字宽度与高度
- (CGSize)contentCellHeightWithText:(NSString*)text ontOfSize:(CGFloat)Font
{
    NSDictionary *attrs11 = @{NSFontAttributeName : [UIFont boldSystemFontOfSize:Font]};
    CGSize attrsSize=[text sizeWithAttributes:attrs11];
    return attrsSize;
}
//绘制图片
- (CALayer*)getIMageLayer:(NSString *)imageName  Frame:(CGRect)frame
{
    
    CALayer*   myLayer = [CALayer layer];
    // 设置图层的内容
    myLayer.contents = (__bridge id _Nullable)([UIImage imageNamed:imageName].CGImage);
    // 设置阴影的颜色
    myLayer.shadowColor = [UIColor clearColor].CGColor;
    // 设置阴影的偏移
    //   myLayer.shadowOffset = CGSizeMake(15, 10);
    // 设置阴影的不透明度
    myLayer.shadowOpacity = 0.6;
    // 设置边角半径
    //    myLayer.cornerRadius = 15;
    // 设置裁剪
    myLayer.masksToBounds = YES;
    // 设置边框线的颜色
    myLayer.borderColor = [UIColor clearColor].CGColor;
    // 设置边框线条的宽度
    //    myLayer.borderWidth = 5.0;
    myLayer.frame = frame;
    myLayer.backgroundColor = [UIColor clearColor].CGColor;
    return myLayer;
}
#pragma mark - 获取这个字符串ASting中的所有abc的所在的index
- (NSMutableArray *)getRangeStr:(NSString *)text findText:(NSString *)findText
{
    
    NSMutableArray *arrayRanges = [NSMutableArray arrayWithCapacity:3];
    
    if (findText == nil && [findText isEqualToString:@""])
    {
        
        return nil;
        
    }
    
    NSRange rang = [text rangeOfString:findText]; //获取第一次出现的range
    
    if (rang.location != NSNotFound && rang.length != 0)
    {
        
        [arrayRanges addObject:[NSNumber numberWithInteger:rang.location]];//将第一次的加入到数组中
        
        NSRange rang1 = {0,0};
        
        NSInteger location = 0;
        
        NSInteger length = 0;
        
        for (int i = 0;; i++)
        {
            
            if (0 == i)
            {
                
                //去掉这个abc字符串
                location = rang.location + rang.length;
                
                length = text.length - rang.location - rang.length;
                
                rang1 = NSMakeRange(location, length);
                
            }
            else
            {
                
                location = rang1.location + rang1.length;
                
                length = text.length - rang1.location - rang1.length;
                
                rang1 = NSMakeRange(location, length);
                
            }
            
            //在一个range范围内查找另一个字符串的range
            
            rang1 = [text rangeOfString:findText options:NSCaseInsensitiveSearch range:rang1];
            
            if (rang1.location == NSNotFound && rang1.length == 0)
            {
                
                break;
                
            }
            else//添加符合条件的location进数组
                
                [arrayRanges addObject:[NSNumber numberWithInteger:rang1.location]];
            
        }
        
        return arrayRanges;
        
    }
    
    return nil;
    
}
@end
