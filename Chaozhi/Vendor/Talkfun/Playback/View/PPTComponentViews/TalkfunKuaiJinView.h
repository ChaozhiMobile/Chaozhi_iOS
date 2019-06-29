//
//  TalkfunKuaiJinView.h
//  TalkfunSDKDemo
//
//  Created by Sunzn on 2017/1/22.
//  Copyright © 2017年 talk-fun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TalkfunKuaiJinView : UIView
@property (weak, nonatomic) IBOutlet UIView *backgroundView;
@property (weak, nonatomic) IBOutlet UIImageView *kuaiImageView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabelAndTotalTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *kuaiLabel;

+ (id)initView;
- (void)kuai:(CGFloat)duration timeLabel:(NSString *)timeLabel totalTimeLabel:(NSString *)totalTimeLabel;

@end
