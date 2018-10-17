//
//  CZGuideVC.m
//  Chaozhi
//
//  Created by zhanbing han on 2018/10/16.
//  Copyright © 2018年 Jason_hzb. All rights reserved.
//

#import "CZGuideVC.h"

@interface CZGuideVC ()<UIScrollViewDelegate>

@property(nonatomic,strong) UIScrollView *scrollView;
@property(nonatomic,strong) UIImageView *slogonImg;

@end

@implementation CZGuideVC

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSArray *imageArr = @[@"Guide01", @"Guide02", @"Guide03", @"Guide04"];
    self.scrollView.contentSize = CGSizeMake(WIDTH * imageArr.count, HEIGHT);
    
    for (int i = 0; i< imageArr.count; i++) {
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH * i, 0, WIDTH, HEIGHT)];
        [imgView setImage:[UIImage imageNamed:imageArr[i]]];
        [imgView setContentMode:UIViewContentModeScaleAspectFill];
        imgView.clipsToBounds=YES;
        imgView.exclusiveTouch=YES;
        imgView.userInteractionEnabled = YES;
        [self.scrollView addSubview:imgView];
        if (i==3) {
            //进入按钮
            CGFloat btnW = 255*HEIGHT/667;
            CGFloat btnH = 45*HEIGHT/667;
            UIImageView *enterImg = [[UIImageView alloc] initWithFrame:CGRectMake((WIDTH-btnW)/2, HEIGHT-btnH*4, btnW, btnH)];
            enterImg.userInteractionEnabled = YES;
            enterImg.image = [UIImage imageNamed:@"EnterBtn"];
            [imgView addSubview:enterImg];
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
            [enterImg addGestureRecognizer:tap];
            
            //Slogon
            _slogonImg = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH/4, HEIGHT/2-100, WIDTH/2, 30*(WIDTH/2)/216)];
            _slogonImg.image = [UIImage imageNamed:@"Slogon"];
            _slogonImg.alpha = 0;
            [imgView addSubview:_slogonImg];
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    self.scrollView.pagingEnabled = YES;
    self.scrollView.bounces = NO;
    self.scrollView.delegate =self;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.scrollView];
}

- (void)tapClick:(UITapGestureRecognizer*)tap {
    [UIApplication sharedApplication].statusBarHidden = NO;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"FirstLG"];
    
    if (self.buttonBlock) {
        self.buttonBlock();
    }
}

#pragma mark - UIScrollViewDelegate协议
//减速滑动(Decelerating:使减速的)
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    int currentPage = fabs(scrollView.contentOffset.x)/WIDTH; //计算当前页
    
    if (currentPage==3) {
        [UIView animateWithDuration:2 animations:^{
            _slogonImg.alpha = 1;
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
