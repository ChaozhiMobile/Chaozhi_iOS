//
//  MyLotteryViewController.m
//  TalkfunSDKDemo
//
//  Created by talk－fun on 16/2/29.
//  Copyright © 2016年 talk-fun. All rights reserved.
//

#import "MyLotteryViewController.h"

@interface MyLotteryViewController ()


@end

@implementation MyLotteryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
      [super viewWillAppear:animated];
    self.view.alpha = 1.0;
}

- (void)refreshUIWithInfo:(NSDictionary *)info
{
//    NSArray * infoArr   = info[@"result"];

//    NSString * nickName = infoArr.firstObject[@"nickname"];
//    self.nameLabel.text = nickName;
    self.nameLabel.adjustsFontSizeToFitWidth=YES;
    
    self.nameLabel.minimumScaleFactor=0.5;
}


- (IBAction)deleteBtnClicked:(UIButton *)sender {
    
    [UIView animateWithDuration:0.5 animations:^{
        
        self.view.alpha = 0.0;
        
    } completion:^(BOOL finished) {
        
        [self.view removeFromSuperview];
        
    }];
    
}



@end
