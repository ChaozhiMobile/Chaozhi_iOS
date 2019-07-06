//
//  TalkfunXiaoBanToolButton.h
//  TalkfunSDKDemo
//
//  Created by 莫瑞权 on 2018/9/12.
//  Copyright © 2018年 Talkfun. All rights reserved.
//

#import <UIKit/UIKit.h>
//status
@interface TalkfunMultifunctionButton : UIButton
@property(nonatomic,strong)UIView *widthView;
@property(nonatomic,assign)BOOL isBackButton;

//画红点点
- (void)drawRedDot;
//清除小红点
- (void)clearRedDot;
//转圈
- (void)startDrawHalfCircle;
//停止转圈
- (void)stopDrawHalfCircle;




@end
