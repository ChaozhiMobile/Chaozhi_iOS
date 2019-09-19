//
//  TalkfunMessageView.h
//  TalkfunSDKDemo
//
//  Created by 孙兆能 on 2016/11/23.
//  Copyright © 2016年 talk-fun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TalkfunMessageView : UIView

@property (weak, nonatomic) IBOutlet UIButton *returnButton;
@property (weak, nonatomic) IBOutlet UIImageView *returnImageView;
@property (weak, nonatomic) IBOutlet UILabel *liveStatusLabel;
@property (weak, nonatomic) IBOutlet UIImageView *zhuboImageView;
@property (weak, nonatomic) IBOutlet UILabel *zhuboNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *renshuImageView;
@property (weak, nonatomic) IBOutlet UILabel *renshuLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *zhuboNameLabelWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *renshuLabelWidth;

- (void)roomInit:(id)obj;

@end
