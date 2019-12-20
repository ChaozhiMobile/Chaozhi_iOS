//
//  XZCourseListVC.m
//  Xuezhi
//
//  Created by Jason_zyl on 2019/12/20.
//  Copyright © 2019 Jason_hzb. All rights reserved.
//

#import "XZCourseListVC.h"
#import "XZCourseListCell.h"

@interface XZCourseListVC ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navBarH;
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;

@end

@implementation XZCourseListVC

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"全部课程";
    self.view.backgroundColor = kWhiteColor;
    _navBarH.constant = kNavBarH;
    _mainTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

#pragma mark - methods
- (IBAction)backAction:(id)sender {
    [super backAction];
}

#pragma mark - UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XZCourseListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XZCourseListCell"];
    cell.item = self.dataArr[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.selectBlock) {
        self.selectBlock(indexPath.row);
        [self backAction];
    }
}

@end
