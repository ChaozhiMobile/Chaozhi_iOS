//
//  DownloadListTableViewCell.m
//  TalkfunSDKDemo
//
//  Created by 孙兆能 on 16/7/11.
//  Copyright © 2016年 talk-fun. All rights reserved.
//

#import "DownloadListTableViewCell.h"

@implementation DownloadListTableViewCell

// 修改TableViewCell在编辑模式下选中按钮的颜色
- (void)layoutSubviews
{
    [super layoutSubviews];
    for (UIControl *control in self.subviews) {
        if (![control isMemberOfClass:NSClassFromString(@"UITableViewCellEditControl")]){
            continue;
        }
        
        for (UIView *subView in control.subviews) {
            if (![subView isKindOfClass: [UIImageView class]]) {
                continue;
            }
            
            UIImageView *imageView = (UIImageView *)subView;
            if (self.selected) {
                // KVC修改
                [imageView setValue:AppThemeColor forKey:@"tintColor"];   // 选中时的颜色
            } else {
                [imageView setValue:kLineColor forKey:@"tintColor"]; // 未选中时的颜色(貌似没用？)
            }
        }
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//- (IBAction)btnClicked:(UIButton *)sender {
//    
//    if (self.btnClickBlock) {
//        self.btnClickBlock(sender);
//    }
//    
//}

@end
