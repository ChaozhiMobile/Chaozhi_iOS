//
//  TalkfunNetworkLines.m
//  TextfieldTest
//
//  Created by 孙兆能 on 2016/11/28.
//  Copyright © 2016年 孙兆能. All rights reserved.
//

#import "TalkfunNetworkLines.h"

@interface TalkfunNetworkLines ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerViewHeight;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;


@end

@implementation TalkfunNetworkLines

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.containerView.layer.cornerRadius = 5;
    self.containerView.layer.shadowOffset = CGSizeMake(0, 0);
    self.containerView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    self.containerView.layer.shadowRadius = 3;
    self.containerView.layer.shadowOpacity = 1;
}

- (void)setNetworkLinesArray:(NSArray *)networkLinesArray
{
    if (networkLinesArray) {
        
        _networkLinesArray = networkLinesArray;
        [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        CGFloat height = 270-172+networkLinesArray.count/2*50+networkLinesArray.count%2*50;
        if (height>270) {
            height = 270;
        }
        self.containerViewHeight.constant = height;
        self.scrollView.backgroundColor = [UIColor clearColor];
        self.containerView.backgroundColor = [UIColor whiteColor];
        
        for (int i = 0; i < networkLinesArray.count; i ++) {
            NSDictionary * dict = networkLinesArray[i];
            NSString * name = dict[@"name"];
            NSNumber * number = dict[@"current"];
            
            UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
            
            btn.layer.cornerRadius = 3;
            btn.layer.borderColor = [UIColor lightGrayColor].CGColor;
            btn.layer.borderWidth = 0.5;
            btn.frame = CGRectMake(i%2 * (CGRectGetWidth(self.scrollView.frame)/2+5), i/2 * (40 + 10), CGRectGetWidth(self.scrollView.frame)/2-5, 40);
            [btn setTitle:name forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:14];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(networkLineBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            btn.tag = 101+i;
            [self.scrollView addSubview:btn];
            
            if ([number isEqualToNumber:@(1)]) {
                btn.backgroundColor = [UIColor colorWithRed:226 / 255.0 green:237 / 255.0 blue:255 / 255.0 alpha:1];
                btn.layer.borderColor= [UIColor colorWithRed:66 / 255.0 green:133 / 255.0 blue:244 / 225.0 alpha:1].CGColor;
            }
        }
        self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.scrollView.frame), networkLinesArray.count/2*50 + networkLinesArray.count%2*50);
    }
    else
    {
        self.containerViewHeight.constant = 270-188+50;
    }
}

- (void)networkLineBtnClicked:(UIButton *)btn
{
    for (UIButton *button in self.scrollView.subviews) {
        button.backgroundColor = [UIColor clearColor];
        button.layer.borderColor = [UIColor lightGrayColor].CGColor;
    }
    btn.backgroundColor = [UIColor colorWithRed:226 / 255.0 green:237 / 255.0 blue:255 / 255.0 alpha:1];
    btn.layer.borderColor= [UIColor colorWithRed:66 / 255.0 green:133 / 255.0 blue:244 / 225.0 alpha:1].CGColor;
    
    if (self.networkLineBlock) {
        self.networkLineBlock(@(btn.tag-100));
    }
    
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 0.0;
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (IBAction)closeBtnClicked:(UIButton *)sender {
    
    if (self.superview) {
        [self removeFromSuperview];
    }
}

@end
