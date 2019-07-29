//
//  XZSelectCourseVC.m
//  Xuezhi
//
//  Created by Jason_zyl on 2019/7/28.
//  Copyright © 2019 Jason_hzb. All rights reserved.
//

#import "XZSelectCourseVC.h"

@interface XZSelectCourseVC ()

@end

@implementation XZSelectCourseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"选课";
    UIButton *sender = [self.view viewWithTag:100];
    [self titleClickAction:sender];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)titleClickAction:(UIButton *)sender {
    sender.selected = YES;
    [sender setTitleColor:AppThemeColor forState:UIControlStateSelected];
    for (NSInteger tag = 100; tag<103; tag++) {
        UIButton *btn = [self.view viewWithTag:tag];
        if (![btn isEqual:sender]) {
            btn.selected = NO;
        }
        [btn setTitleColor:AppThemeColor forState:UIControlStateSelected];
    }
    [sender.superview layoutIfNeeded];
    [UIView animateWithDuration:0.2 animations:^{
         self.lineViewLeft.constant = sender.left;
         [sender.superview layoutIfNeeded]; // Called on parent view
     }];

}
@end
