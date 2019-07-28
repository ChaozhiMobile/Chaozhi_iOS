//
//  XZTabBarVC.m
//  Xuezhi
//
//  Created by Jason_zyl on 2019/7/28.
//  Copyright © 2019 Jason_hzb. All rights reserved.
//

#import "XZTabBarVC.h"
#import "BaseNC.h"

@interface XZTabBarVC ()

@end

@implementation XZTabBarVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createTabBar];
}

- (void)createTabBar {
    //视图数组
    NSArray *controllerArr = @[@"XZHomeVC",@"CZStudyVC",@"XZSelectCourseVC",@"CZMineVC"];
    //标题数组
    NSArray *titleArr = @[@"首页",@"学习",@"选课",@"我的"];
    //图片数组
    NSArray *picArr = @[@"icon_home_normal",@"icon_study_normal",@"icon_selectcourse_normal",@"icon_mine_normal"];
    
    //storyboard name 数组
    NSArray *storyArr = @[@"Xuezhi",@"Main",@"Xuezhi",@"Main"];
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    for(int i=0; i<picArr.count; i++) {
        UIViewController *controller = [[UIStoryboard storyboardWithName:storyArr[i] bundle:nil] instantiateViewControllerWithIdentifier:controllerArr[i]];
        controller.title = titleArr[i];
        
        BaseNC *nv = [[BaseNC alloc] initWithRootViewController:controller];
        nv.tabBarItem.title = titleArr[i];
        NSString *norName = picArr[i];
        nv.tabBarItem.image = [[UIImage imageNamed:norName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        nv.tabBarItem.selectedImage = [[UIImage imageNamed:[NSString stringWithFormat:@"%@",[norName stringByReplacingOccurrencesOfString:@"normal" withString:@"selected"]]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [array addObject:nv];
    }
    
    //设置字体的颜色和大小
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:AppThemeColor,NSFontAttributeName:[UIFont systemFontOfSize:10.5]} forState:UIControlStateSelected];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:kGrayB5Color,NSFontAttributeName:[UIFont systemFontOfSize:10.5]} forState:UIControlStateNormal];
    
    //改变tabBar的背景颜色
    UIView *barBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, kTabBarH)];
    barBgView.backgroundColor = [UIColor whiteColor];
    [self.tabBar insertSubview:barBgView atIndex:0];
    self.tabBar.opaque = YES;
    
    self.viewControllers = array;
}

@end
