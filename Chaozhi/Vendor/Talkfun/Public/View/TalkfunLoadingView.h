//
//  TalkfunLoadingView.h
//  TalkfunSDKDemo
//
//  Created by Sunzn on 2017/4/21.
//  Copyright © 2017年 Talkfun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TalkfunLoadingView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UILabel *courseNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *tipsBtn;

+ (id)initView;

- (void)configLogo:(NSString *)logoUrl courseName:(NSString *)name;

@end
