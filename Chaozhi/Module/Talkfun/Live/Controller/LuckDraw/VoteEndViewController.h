//
//  VoteEndViewController.h
//  Talkfun_demo
//
//  Created by talk－fun on 16/1/26.
//  Copyright © 2016年 talk-fun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VoteEndViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel  *voteTitle;
@property (nonatomic,copy ) NSString * message;
@property (weak, nonatomic) IBOutlet UILabel  *successLabel;
@property (weak, nonatomic) IBOutlet UIImageView *statusImageView;

- (void)refreshUIWithAfterCommitted;

@end
