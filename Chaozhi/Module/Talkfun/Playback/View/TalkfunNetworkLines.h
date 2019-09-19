//
//  TalkfunNetworkLines.h
//  TextfieldTest
//
//  Created by 孙兆能 on 2016/11/28.
//  Copyright © 2016年 孙兆能. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TalkfunNetworkLines : UIView

@property (nonatomic,copy) void (^networkLineBlock)(NSNumber *networkLineIndex);

@property (weak, nonatomic) IBOutlet UIView *containerView;

@property (nonatomic,strong) NSArray * networkLinesArray;

@end
