//
//  XZHomeTabCell.m
//  Xuezhi
//
//  Created by Jason_zyl on 2019/8/1.
//  Copyright © 2019 Jason_hzb. All rights reserved.
//

#import "XZHomeTabCell.h"
#import "XLGCustomButton.h"

@implementation XZHomeTabCell

/** 畅销好课model */
- (void)setItem:(CourseItem *)item withView:(UIView *)view {
    
    UIImageView *imgView = [view viewWithTag:101];
    UILabel *nameLab = [view viewWithTag:102];
    UILabel *priceLab = [view viewWithTag:103];
    UIButton *commentBtn = [view viewWithTag:104];
    XLGCustomButton *clickBtn = [view viewWithTag:105];
    
    [imgView sd_setImageWithURL:[NSURL URLWithString:item.img] placeholderImage:[UIImage imageNamed:@"default_course"]];
    nameLab.text = item.name;
    priceLab.text = [NSString stringWithFormat:@"￥%@",item.price];
    [commentBtn setTitle:item.review_num forState:UIControlStateNormal];
    clickBtn.dataSource = item;
    [clickBtn addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - 畅销好课课程点击
- (void)clickAction:(XLGBaseButton *)btn {
    CourseItem *item = btn.dataSource;
    UINavigationController *nv = CZAppDelegate.tabVC.selectedViewController;
    [BaseWebVC showWithContro:nv.topViewController withUrlStr:[NSString stringWithFormat:@"%@%@",H5_StoreProduct,item.ID] withTitle:@"" isPresent:NO];
}

/** 公开课model */
- (void)setPublicItem:(HomeTryVideoItem *)publicItem {
    [self.thumbImgView sd_setImageWithURL:[NSURL URLWithString:publicItem.img] placeholderImage:nil];
    self.titleLab.text = publicItem.title;
    self.teacherName.text = publicItem.teacher;
}

/** 行业资讯model */
- (void)setNewsItem:(HomeNewsItem *)newsItem {
    [self.thumbImgView sd_setImageWithURL:[NSURL URLWithString:newsItem.img] placeholderImage:nil];
    self.titleLab.text = newsItem.title;
    self.timeLab.text = newsItem.ct;
    self.readCountLab.text = [NSString stringWithFormat:@"0人阅读"];
}

@end
