//
//  TalkfunKuaiJinView.m
//  TalkfunSDKDemo
//
//  Created by Sunzn on 2017/1/22.
//  Copyright © 2017年 talk-fun. All rights reserved.
//

#import "TalkfunKuaiJinView.h"

@implementation TalkfunKuaiJinView

+ (id)initView{
    TalkfunKuaiJinView * kuaiJinView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil][0];
    return kuaiJinView;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    self.backgroundView.layer.cornerRadius = 4.0;
}

- (void)kuai:(CGFloat)duration timeLabel:(NSString *)timeLabel totalTimeLabel:(NSString *)totalTimeLabel{
    
    self.kuaiImageView.image = [UIImage imageNamed:duration>=0?@"快进":@"倒退"];
    self.timeLabelAndTotalTimeLabel.text = [NSString stringWithFormat:@"%@ / %@",timeLabel,totalTimeLabel];
    self.kuaiLabel.text = [NSString stringWithFormat:@"%@%d秒",duration>=0?@"+":@"",(int)duration];
}

@end
