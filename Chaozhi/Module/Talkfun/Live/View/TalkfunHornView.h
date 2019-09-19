//
//  TalkfunHornView.h
//  TalkfunSDKDemo
//
//  Created by 孙兆能 on 2016/11/23.
//  Copyright © 2016年 talk-fun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TalkfunHornView : UIView

@property (weak, nonatomic) IBOutlet UIButton *hornButton;
@property (weak, nonatomic) IBOutlet UILabel *rollLabel;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (nonatomic,copy) NSString * link;

- (void)rollLabelAddAnimation;
- (void)announceRoll:(id)obj;

@end
