//
//  ProgressLoadView.h
//  Chaozhi
//  Notes：仿网页加载进度条
//
//  Created by Jason_hzb on 2018/5/29.
//  Copyright © 2018年 小灵狗出行. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ProgressLoadViewBlock)(void);

@interface ProgressLoadView : UIView

+ (instancetype)shareLoadView;

- (void)startLoading;

- (void)startLoading:(BOOL) isCovered;

- (void)startLoading:(BOOL)isCovered withMonitor:(ProgressLoadViewBlock) delegate;

- (void)stopLoading:(BOOL)isSucc;

@end
