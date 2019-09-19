//
//  TalkfunNetworkStatusView.h
//  TalkfunSDKDemo
//
//  Created by 孙兆能 on 2016/11/23.
//  Copyright © 2016年 talk-fun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TalkfunNetworkStatusView : UIView

@property (weak, nonatomic) IBOutlet UIButton *networkStatusButton;
@property (weak, nonatomic) IBOutlet UILabel *networkCharactersLabel;
@property (weak, nonatomic) IBOutlet UILabel *networkSpeedLabel;
@property (weak, nonatomic) IBOutlet UIImageView *networkStatusImageView;
@property (nonatomic,assign) TalkfunNetworkStatus networkStatus;
- (void)networkStatusChange:(TalkfunNetworkStatus)networkStatus;
- (void)networkStatusViewHide:(BOOL)hide;

@end
