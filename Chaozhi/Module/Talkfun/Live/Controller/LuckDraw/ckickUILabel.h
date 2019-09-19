//
//  ckickUILabel.h
//  TalkfunSDKDemo
//
//  Created by moruiwei on 17/3/23.
//  Copyright © 2017年 Talkfun. All rights reserved.
//

#import <UIKit/UIKit.h>
// name:block类型的别名
typedef void(^ckickUILabelBlock)(NSInteger tag);
@interface ckickUILabel : UILabel
@property (nonatomic, strong) ckickUILabelBlock myBlock;
@end
