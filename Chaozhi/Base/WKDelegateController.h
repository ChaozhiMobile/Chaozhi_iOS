//
//  WKDelegateController.h
//  Chaozhi
//  Notes：WebView基类辅助类
//
//  Created by Jason on 2018/5/7.
//  Copyright © 2018年 小灵狗出行. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@protocol WKDelegate <NSObject>

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message;

@end

@interface WKDelegateController : UIViewController <WKScriptMessageHandler>

@property (weak, nonatomic) id<WKDelegate> delegate;

@end
