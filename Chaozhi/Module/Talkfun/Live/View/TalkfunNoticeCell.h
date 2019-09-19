//
//  TalkfunNoticeCell.h
//  TalkfunSDKDemo
//
//  Created by Sunzn on 2017/3/29.
//  Copyright © 2017年 Talkfun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "stopCopyTextView.h"

@interface TalkfunNoticeCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UIView *bg;
@property (weak, nonatomic) IBOutlet stopCopyTextView *contentTextView;



@end
