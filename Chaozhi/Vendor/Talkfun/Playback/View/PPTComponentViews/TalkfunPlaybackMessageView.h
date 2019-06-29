//
//  TalkfunPlaybackMessageView.h
//  TalkfunSDKDemo
//
//  Created by 孙兆能 on 2016/11/29.
//  Copyright © 2016年 talk-fun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TalkfunPlaybackMessageView : UIView

@property (weak, nonatomic) IBOutlet UIButton *returnBtn;
@property (weak, nonatomic) IBOutlet UILabel *lessonTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *viewsNum;

- (void)liveInfo:(id)obj;

@end
