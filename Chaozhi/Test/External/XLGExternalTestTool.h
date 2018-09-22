//
//  XLGExternalTestTool.h
//  SharenGo
//  Notes：外部测试按钮
//
//  Created by Jason on 2018/5/10.
//  Copyright © 2018年 小灵狗出行. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XLGExternalTestTool: UIButton

+ (instancetype)shareInstance;

@property (nonatomic, retain) UITextView *logTextViews;

@end
