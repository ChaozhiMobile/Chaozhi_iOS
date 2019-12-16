//
//  CZPopAdsView.m
//  Chaozhi
//
//  Created by Jason_zyl on 2019/12/7.
//  Copyright © 2019 Jason_hzb. All rights reserved.
//

#import "CZPopAdsView.h"
#import "NewPagedFlowView.h"
#import "PGIndexBannerSubiew.h"

@interface CZPopAdsView ()<NewPagedFlowViewDelegate>
/** 网络图片数组 */
@property (nonatomic, strong) NSMutableArray *imageArray;
@end

@implementation CZPopAdsView

- (instancetype)initWithImages:(NSMutableArray *)imageArray {
    self.imageArray = imageArray;
    CGRect frame = CGRectMake(0, 0, WIDTH, HEIGHT);
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.6];
        [[UIApplication sharedApplication].keyWindow addSubview:self];
        [self initView]; //初始化视图
        
        //默认显示动画
        self.alpha = 0;
        __weak typeof(self) weakSelf = self;
        [UIView animateWithDuration:0.5 animations:^{
            weakSelf.alpha = 1;
        }];
    }
    return self;
}

- (void)initView {
    NewPagedFlowView *pageFlowView = [[NewPagedFlowView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT/2)];
    pageFlowView.delegate = self;
    pageFlowView.minimumPageAlpha = 0.2;//非当前页的透明比例
    pageFlowView.leftRightMargin = 50;//左右间距
    pageFlowView.topBottomMargin = 100;//上下偏移
    pageFlowView.orginPageCount = self.imageArray.count;//原始页数
    pageFlowView.isOpenAutoScroll = YES;//是否开启自动滚动
    pageFlowView.autoTime = 3.0;//设置定时器秒数
    pageFlowView.isCarousel = YES;//是否开启无限轮播
    pageFlowView.orientation = NewPagedFlowViewOrientationHorizontal;//横向纵向
    pageFlowView.urlImageDataSource = self.imageArray;//传入网络数据
    pageFlowView.imgProportion = 4.0/3.0;//设置图片比例
    pageFlowView.cornerRadius = 8;//设置圆角
    pageFlowView.contentMode = UIViewContentModeScaleToFill;
    [pageFlowView reloadData];//设置完数据刷新数据
    pageFlowView.center = self.center;
    [self addSubview:pageFlowView];
    
    UIButton *closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, pageFlowView.bottom-autoScaleW(30), autoScaleW(35), autoScaleW(35))];
    closeBtn.centerX = self.centerX;
    [closeBtn setImage:[UIImage imageNamed:@"home_banner_close"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:closeBtn];
}

#pragma mark - 关闭
- (void)closeAction {
    if (self.closeBlock) {
        self.closeBlock();
    }
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark NewPagedFlowView Delegate
/** 点击了第几页 */
- (void)didSelectCell:(UIView *)subView withSubViewIndex:(NSInteger)subIndex {
    [self closeAction];
    if (self.clickBlock) {
        self.clickBlock(subIndex);
    }
}

/** 滚动到了第几页 */
- (void)didScrollToPage:(NSInteger)pageNumber inFlowView:(NewPagedFlowView *)flowView {
    
}

@end
