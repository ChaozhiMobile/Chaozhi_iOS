//
//  TalkfunScoreView.h
//  TalkfunSDKDemo
//
//  Created by 莫瑞权 on 2018/8/15.
//  Copyright © 2018年 Talkfun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "evaluateView.h"
@interface TalkfunScoreView : UIView

//@property(nonatomic,assign)NSInteger width;//l

@property(nonatomic,assign)CGRect evaluateFrame;
@property(nonatomic,assign)CGRect tempEvaluateFrame;//临时保存

@property (strong, nonatomic)evaluateView *evaluate;


@property (nonatomic , copy ) void (^currentScoreChangeBlock)(NSMutableDictionary*cict);

@property (nonatomic , copy ) void (^exitBlock)(NSDictionary*cict);
@end
