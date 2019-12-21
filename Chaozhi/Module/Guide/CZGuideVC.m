//
//  CZGuideVC.m
//  Chaozhi
//
//  Created by zhanbing han on 2018/10/16.
//  Copyright © 2018年 Jason_hzb. All rights reserved.
//

#import "CZGuideVC.h"
#import "AppDelegate.h"

@interface CZGuideVC ()<UIScrollViewDelegate>

@property(nonatomic,strong) UIScrollView *scrollView;

@end

@implementation CZGuideVC

// 不支持转屏
- (BOOL)shouldAutorotate {
    return NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navBar.hidden = YES;
    
    NSArray *imageArr = @[@"Guide01", @"Guide02", @"Guide03", @"Guide04"];
    self.scrollView.contentSize = CGSizeMake(WIDTH * imageArr.count, HEIGHT);
    
    for (int i = 0; i< imageArr.count; i++) {
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH * i, 0, WIDTH, HEIGHT)];
        [imgView setImage:[UIImage imageNamed:imageArr[i]]];
        [imgView setContentMode:UIViewContentModeScaleToFill];
        imgView.clipsToBounds=YES;
        imgView.exclusiveTouch=YES;
        imgView.userInteractionEnabled = YES;
        [self.scrollView addSubview:imgView];
        if (i==3) {
            //进入按钮
            CGFloat btnW = autoScaleW(159);
            CGFloat btnH = autoScaleW(36);
            CGFloat offY = autoScaleW(30)+kTabBarSafeH;
            if ([AppChannel isEqualToString:@"1"]) { //超职
                offY = autoScaleH(40);
            }
            if ([AppChannel isEqualToString:@"2"]) { //学智
                offY = autoScaleH(80);
                if (IsIPAD) {
                    offY = autoScaleH(150);
                }
            }
            UIButton *enterBtn = [[UIButton alloc] initWithFrame:CGRectMake((WIDTH-btnW)/2, HEIGHT-btnH-offY, btnW, btnH)];
            [enterBtn setTitle:@"立即体验" forState:UIControlStateNormal];
            [enterBtn setTitleColor:AppThemeColor forState:UIControlStateNormal];
            enterBtn.titleLabel.font = [UIFont systemFontOfSize:15];
            enterBtn.layer.borderColor = AppThemeColor.CGColor;
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
