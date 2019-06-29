//
//  TalkfunGuidanceView.h
//  TalkfunSDKDemo
//
//  Created by Sunzn on 2017/2/10.
//  Copyright © 2017年 talk-fun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TalkfunGuidenceButton.h"

@interface TalkfunGuidanceView : UIView

- (id)initView;
@property (weak, nonatomic) IBOutlet TalkfunGuidenceButton *noMoreDisplayButton;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *useButtonCenterY;

@end
