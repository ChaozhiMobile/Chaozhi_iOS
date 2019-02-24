//
//  CZInfiniteVC.m
//  Chaozhi
//
//  Created by Jason_zyl on 2018/9/22.
//  Copyright © 2018年 Jason_hzb. All rights reserved.
//

#import "CZInfiniteVC.h"
#import <WebKit/WebKit.h>
#import "BaseWebVC.h"

@interface CZInfiniteVC ()
{
    NSString *_webUrl;
}
@end

@implementation CZInfiniteVC

- (void)viewDidLoad {
    
    _webUrl = [NSString stringWithFormat:@"%@%@",h5Url(),H5_Infinite];
    self.homeUrl = _webUrl;
    self.webTitle = @"无限";
    self.isPresent = NO;
    [super viewDidLoad];
    
    self.title = @"无限";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
