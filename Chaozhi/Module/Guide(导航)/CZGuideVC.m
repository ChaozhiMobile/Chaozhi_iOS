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

@end

@implementation CZGuideVC

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navBar.hidden = YES;
    
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
            CGFloat btnW = autoScaleW(159);
            CGFloat btnH = autoScaleW(36);
            UIButton *enterBtn = [[UIButton alloc] initWithFrame:CGRectMake((WIDTH-btnW)/2, HEIGHT-btnH-autoScaleW(30)-kTabBarSafeH, btnW, btnH)];
            [enterBtn setTitle:@"立即体验" forState:UIControlStateNormal];
            [enterBtn setTitleColor:RGBValue(0xD0021B) forState:UIControlStateNormal];
            enterBtn.titleLabel.font = [UIFont systemFontOfSize:15];
            enterBtn.layer.borderColor = RGBValue(0xD0021B).CGColor;
            enterBtn.layer.borderWidth = autoScaleW(1);
            enterBtn.layer.cornerRadius = btnH/2;
            [enterBtn.layer setMasksToBounds:YES];
            [enterBtn addTarget:self action:@selector(enterAction) forControlEvents:UIControlEventTouchUpInside];
            [imgView addSubview:enterBtn];
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

// 立即体验
- (void)enterAction {
    [UIApplication sharedApplication].statusBarHidden = NO;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"FirstLG"];
    
    if (self.doneBlock) {
        self.doneBlock();
    }
}

#pragma mark - UIScrollViewDelegate协议
//减速滑动(Decelerating:使减速的)
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
//    int currentPage = fabs(scrollView.contentOffset.x)/WIDTH; //计算当前页
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
