//
//  VoteEndViewController.m
//  Talkfun_demo
//
//  Created by talk－fun on 16/1/26.
//  Copyright © 2016年 talk-fun. All rights reserved.
//

#import "VoteEndViewController.h"

@interface VoteEndViewController ()

@property (nonatomic,assign) NSInteger flag;

@end

@implementation VoteEndViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

//MARK:提交投票结果
- (void)refreshUIWithAfterCommitted
{
    self.flag = 3;
    
    self.successLabel.text = [NSString stringWithFormat:@"%@...03秒后自动关闭页面",self.message];
    dispatch_queue_t queue = dispatch_queue_create("vote", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_async(queue, ^{
        @synchronized(self) {
            NSOperationQueue * que = [NSOperationQueue mainQueue];
            
            for (; self.flag > 0;) {
                
                [que addOperationWithBlock:^{
                    self.successLabel.text = [NSString stringWithFormat:@"%@...%02ld秒后自动关闭页面",self.message,(long)self.flag];
                    self.flag --;
                }];
                sleep(1);
            }
            [que addOperationWithBlock:^{
                
                [UIView animateWithDuration:0.5 animations:^{
                    
                    self.view.alpha = 0.0;
                    
                } completion:^(BOOL finished) {
                    
                    [self.view removeFromSuperview];
                    
                }];
                
            }];
            return ;
        }
        
    });
    
}

- (IBAction)deleteBtnClicked:(UIButton *)sender {
    
    [UIView animateWithDuration:0.5 animations:^{
        
        self.view.alpha = 0.0;
        
    } completion:^(BOOL finished) {
        
        [self.view removeFromSuperview];
        
    }];
    
}

- (void)dealloc
{
    
}

@end
