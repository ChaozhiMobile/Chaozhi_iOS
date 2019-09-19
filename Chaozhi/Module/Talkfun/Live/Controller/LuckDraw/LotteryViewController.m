//
//  LotteryViewController.m
//  Talkfun_demo
//
//  Created by talk－fun on 16/1/20.
//  Copyright © 2016年 talk-fun. All rights reserved.
//

#import "LotteryViewController.h"
#import "LotteryCell.h"

@interface LotteryViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic ) IBOutlet UIImageView        *lotteryImageView;
@property (weak, nonatomic ) IBOutlet UILabel            *nameLabel;
@property (weak, nonatomic ) IBOutlet UIButton           *deleteBtn;
@property (weak, nonatomic ) IBOutlet UITableView        *tableView1;
@property (weak, nonatomic ) IBOutlet UITableView        *tableView2;
@property (weak, nonatomic ) IBOutlet UITableView        *tableView3;
@property (weak, nonatomic ) IBOutlet NSLayoutConstraint *imageHeightConstraint;
@property (nonatomic,strong) NSTimer            * timer;

@end

@implementation LotteryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    for (int i = 0; i < 3; i ++) {
        UITableView * tableView = (UITableView *)[self.view viewWithTag:100 + i];
        
        if (i == 1) {
            
            tableView.contentOffset = CGPointMake(0, 55 * 29);
            
        }
    }
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.timer = [NSTimer scheduledTimerWithTimeInterval:0.08 target:self selector:@selector(recursive) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    });
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.timer invalidate];
}

- (void)refreshUIWithInfo:(NSDictionary *)info
{
    if (!info) {
        self.deleteBtn.hidden               = YES;
        self.lotteryImageView.image         = [UIImage imageNamed:@"inLottery"];
        self.tableView1.hidden              = NO;
        self.tableView2.hidden              = NO;
        self.tableView3.hidden              = NO;
        self.nameLabel.hidden               = YES;
        self.imageHeightConstraint.constant = 181;
        
        //滚动
//        [self recursive];
        
    }
    else
    {
        
        self.deleteBtn.hidden                = NO;
        self.lotteryImageView.image         = [UIImage imageNamed:@"lottery"];
        self.tableView1.hidden               = YES;
        self.tableView2.hidden               = YES;
        self.tableView3.hidden               = YES;
        NSArray * infoArr                   = info[@"result"];

//        NSString * nickName                 = infoArr.firstObject[@"nickname"];
//        
//        
        
        
        NSString *nickname = @"";
        
        
        for (int i = 0; i<infoArr.count; i++) {
            
            NSDictionary *nameDict  = infoArr[i];
            nickname = [nickname stringByAppendingString:nameDict[@"nickname"]];
            if (i!=infoArr.count-1) {
                nickname = [nickname stringByAppendingString:@"、"];
            }
            
        }
        
        NSLog(@"%@",nickname);
        
        
        self.nameLabel.adjustsFontSizeToFitWidth=YES;
        
        self.nameLabel.minimumScaleFactor=0.5;
        self.nameLabel.text                 = nickname;
        self.nameLabel.hidden                = NO;
        self.imageHeightConstraint.constant = 220;
        
    }
    
}

- (void)recursive
{
    static int j = 1;
    for (int i = 0; i < 3; i ++) {
        
        UITableView * tableView = (UITableView *)[self.view viewWithTag:100 + i];
        
        if (i == 1) {
            
            [tableView setContentOffset:CGPointMake(0, 55 * (29 - j)) animated:YES];
            //                tableView.contentOffset = CGPointMake(0, 0);
        }
        else
        {
            [tableView setContentOffset:CGPointMake(0, 55 * j) animated:YES];
            //                tableView.contentOffset = CGPointMake(0, 55);
        }
    }
    j ++;
    if (j == 30) {
        j = 0;
    }
    
//    [UIView animateWithDuration:20 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//        
//        for (int i = 0; i < 3; i ++) {
//            UITableView * tableView = (UITableView *)[self.view viewWithTag:100 + i];
//            
//            if (i == 1) {
//                [tableView setContentOffset:CGPointMake(0, 0) animated:YES];
////                tableView.contentOffset = CGPointMake(0, 0);
//            }
//            else
//            {
//                [tableView setContentOffset:CGPointMake(0, 55 * 99) animated:YES];
////                tableView.contentOffset = CGPointMake(0, 55);
//            }
//        }
//        
//    } completion:^(BOOL finished) {
//        
//        for (int i = 0; i < 3; i ++) {
//            UITableView * tableView = (UITableView *)[self.view viewWithTag:100 + i];
//            
//            if (i == 1) {
//                tableView.contentOffset = CGPointMake(0, 55 * 99);
//            }
//            else
//            {
//                tableView.contentOffset = CGPointMake(0, 0);
//            }
//        }
//        
//        [self recursive];
//        
//    }];

}

- (IBAction)deleteBtnClicked:(UIButton *)sender {
    
    [UIView animateWithDuration:0.5 animations:^{
        
        self.view.alpha = 0.0;
        
    } completion:^(BOOL finished) {
        
        [self.view removeFromSuperview];
        
    }];
    
}

#pragma mark - tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LotteryCell * cell = [tableView dequeueReusableCellWithIdentifier:@"lottery"];
    
    if (!cell) {
        
        cell = [[NSBundle mainBundle] loadNibNamed:@"LotteryCell" owner:nil options:nil][0];
        
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}

- (void)dealloc
{
    
}

@end
