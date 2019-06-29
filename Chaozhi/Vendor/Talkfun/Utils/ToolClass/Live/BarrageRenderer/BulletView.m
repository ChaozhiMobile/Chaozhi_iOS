//
//  BulletView.m
//  MTGraphics
//
//  Created by 莫瑞权 on 2018/7/24.
//  Copyright © 2018年 MT. All rights reserved.
//

#import "BulletView.h"
#import "BulletManager.h"
@interface BulletView ()

@property(nonatomic,strong)NSMutableDictionary *trackDict ;


@property(nonatomic,assign)CGFloat superlayerHeight;//记录设置过的高度
@end


@implementation BulletView

- (NSInteger)getBulletCount
{
    return self.layer.sublayers.count;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        //默认可以弹幕
        self.bulletSwitch = YES;
    }
    return self;
}

- (NSMutableDictionary * )trackDict
{
    if (_trackDict==nil) {
        _trackDict = [NSMutableDictionary dictionary];
        
    }
    return _trackDict;
}


- (void )initWithContent:(NSString *)content ontOfSize:(CGFloat)fontSize   textColor:(UIColor *)Color
{
    if (self.bulletSwitch==NO&&content) {
        return;
    }
          @synchronized(self){
    dispatch_async(dispatch_get_main_queue(), ^{
        //字体高度
        CGSize  size_2 =     [TalkFunTextLayer getTextWidth:@"高度" ontOfSize:fontSize];
        
        if ( self.superlayerHeight!=self.layer.superlayer.frame.size.height||size_2.height > self.trackDict.count) {
            self.superlayerHeight = self.layer.superlayer.frame.size.height;
            
            //屏幕旋转处理
            [self.trackDict removeAllObjects];
            
            for (NSInteger i = 0; i < self.layer.superlayer.frame.size.height -(size_2.height*1.2); i++) {
                
                
                
                if ((i%5)==0) {
                    
                    //                    NSLog(@"ssssss = %li",i);
                    [self.trackDict setObject:[NSString stringWithFormat:@"%li",i] forKey:[NSString stringWithFormat:@"%li",i]];
                }
                
            }
        }
        
        
        
        //牵引
        CGFloat  aa = self.trackDict.count - 1;
        NSArray *keys = [self.trackDict allKeys];
        //取出当前位置对应的key
        NSString *YYYY = keys[arc4random_uniform(aa)];
        
        
        //要删除的Y值
        NSMutableArray *Y_arr = [NSMutableArray array];
        
        for (NSInteger i = [YYYY integerValue]; i< [YYYY integerValue]+(size_2.height*2)  ; i++) {
            if ((i%5)==0) {
                [Y_arr addObject:[NSString stringWithFormat:@"%li",i]];
                
                [self.trackDict  removeObjectForKey:[NSString stringWithFormat:@"%li",i]];
                
            }
        }
        CGPoint point = CGPointMake(0, [YYYY integerValue]);
        
        
        //    NSLog(@"YYYYYY+++====>%lf",point.y);
        
        TalkFunTextLayer *textLayer =  [[[BulletManager alloc]init] withContent:content ontOfSize:fontSize startingPoint: point textColor:Color];
        [self.layer addSublayer: textLayer];
        //    [self.textLayerArray addObject:textLayer];
        
        
        textLayer.Y_arr = Y_arr;
        textLayer.Hide_X = self.layer.superlayer.frame.size.width;
        
        __weak typeof(self) weakSelf = self;
        textLayer.myBlock = ^(NSMutableArray *Y_arr){
            
            if (Y_arr) {
                for (NSString * YY in Y_arr) {
                    //旋转屏幕前的数据
                    if ([YY integerValue]<weakSelf.layer.superlayer.frame.size.height-(size_2.height*1.2)) {
                        [weakSelf.trackDict setObject:YY forKey:YY];
                    }
                    
                }
            }
            
        };
        //动画
        [textLayer startAnimation ];
        
        
    });
          }
}

//停止动画
- (void)stopAnimation
{
    for (TalkFunTextLayer * textLayer in self.layer.sublayers) {
        [textLayer removeAllAnimations];
    }
    self.trackDict = nil;

}

- (void)setBulletSwitch:(BOOL)bulletSwitch
{
    _bulletSwitch = bulletSwitch;
    
    if (bulletSwitch==NO) {
        [self stopAnimation ];
    }
}
@end

