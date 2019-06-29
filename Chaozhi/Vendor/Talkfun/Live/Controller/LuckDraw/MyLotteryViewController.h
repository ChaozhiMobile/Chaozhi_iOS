//
//  MyLotteryViewController.h
//  TalkfunSDKDemo
//
//  Created by talk－fun on 16/2/29.
//  Copyright © 2016年 talk-fun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyLotteryViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
- (void)refreshUIWithInfo:(NSDictionary *)info;

@end
