//
//  TalkfunGradientView.h
//  TalkfunSDKDemo
//
//  Created by 孙兆能 on 2016/12/14.
//  Copyright © 2016年 talk-fun. All rights reserved.
//

#import <UIKit/UIKit.h>
//#ifdef IB_DESIGNABLE
//IB_DESIGNABLE
//#endif

#ifndef IBInspectable
#define IBInspectable
#endif

@interface TalkfunGradientView : UIView

@property (nonatomic) IBInspectable CGPoint inputPoint0;
@property (nonatomic) IBInspectable CGPoint inputPoint1;

@property (nonatomic) IBInspectable UIColor *inputColor0;
@property (nonatomic) IBInspectable UIColor *inputColor1;

- (void)addLayer;

@end
