//
//  BulletManager.h
//  MTGraphics
//
//  Created by 莫瑞权 on 2018/7/23.
//  Copyright © 2018年 MT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TalkFunTextLayer.h"
@interface BulletManager : NSObject

//初始化
//content  内容

//fontSize字体大小

//startingPoint  起点

- (TalkFunTextLayer *)withContent:(NSString *)content ontOfSize:(CGFloat)fontSize startingPoint:(CGPoint)point textColor:(UIColor *)Color ;

@end
