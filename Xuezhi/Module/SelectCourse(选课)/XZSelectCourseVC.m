//
//  XZSelectCourseVC.m
//  Xuezhi
//
//  Created by Jason_zyl on 2019/7/28.
//  Copyright © 2019 Jason_hzb. All rights reserved.
//

#import "XZSelectCourseVC.h"

#define LineMaxCount 4.5

@interface XZSelectCourseVC ()
{
    NSArray *titleArr;
}
@end

@implementation XZSelectCourseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"选课";
    titleArr = @[@"教师资格证",@"教师招聘",@"公开课",@"教师资格证",@"教师招聘",@"公开课"];
    CGFloat viewW = WIDTH/(MIN(titleArr.count, LineMaxCount));
    CGFloat viewLeft = 0;
    for (NSInteger index = 0; index<titleArr.count; index++) {
        UIButton *sender = [[UIButton alloc]initWithFrame:CGRectMake(viewLeft, 0, viewW, 50)];
        viewLeft = sender.right;
        sender.titleLabel.font = [UIFont systemFontOfSize:14];
        [sender setTitle:titleArr[index] forState:UIControlStateNormal];
        [sender setTitleColor:kBlackColor forState:UIControlStateNormal];
        [sender setTitleColor:AppThemeColor forState:UIControlStateSelected];
        [sender addTarget:self action:@selector(titleClickAction:) forControlEvents:UIControlEventTouchUpInside];
        sender.tag = 1000+index;
        [_titleBgScrollView addSubview:sender];
    }
    _titleBgScrollView.contentSize = CGSizeMake(viewLeft, 0);
    _titleLineView = [[UIView alloc]initWithFrame:CGRectMake(0, 47, viewW, 3)];
    _titleLineView.backgroundColor = AppThemeColor;
    [_titleBgScrollView addSubview:_titleLineView];
    _mainTabView.tableFooterView = [[UIView alloc]init];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XZSelectCourseTabCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XZSelectCourseTabCell"];
    return cell;
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
    for (NSInteger tag = 0; tag<titleArr.count; tag++) {
        UIButton *btn = [self.view viewWithTag:tag+1000];
        if (![btn isEqual:sender]) {
            btn.selected = NO;
        }
        [btn setTitleColor:AppThemeColor forState:UIControlStateSelected];
    }
    [UIView animateWithDuration:0.3 animations:^{
        self.titleLineView.centerX = sender.centerX;
    }];
}
@end

@implementation XZSelectCourseTabCell

@end
