//
//  XLGTalkfunVC.m
//  Chaozhi
//
//  Created by Jason_zyl on 2019/6/24.
//  Copyright © 2019 Jason_hzb. All rights reserved.
//

#import "XLGTalkfunVC.h"
#import "TalkfunSDKLive.h"

@interface XLGTalkfunVC ()

@property (nonatomic,strong) TalkfunSDKLive * talkfunSDK;
//摄像头容器
@property (nonatomic,strong) UIView     * cameraView;
//ppt容器
@property (nonatomic,strong) UIView     * pptView;

@end

@implementation XLGTalkfunVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //属性字典
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    //1.实例化SDK（如果用的是accessKey则在access_token参数中传入）
    self.talkfunSDK = [[TalkfunSDKLive alloc] initWithAccessToken:self.token parameters:parameters];
    
    //通过accessKey实例化SDK
    //    self.talkfunSDK = [[TalkfunSDKLive alloc] initWithAccessKey:accessKey parameters:parameters];
    
    //进入后台是否暂停（默认是暂停）
    [self.talkfunSDK setPauseInBackground:YES];
    
    //ppt容器（4：3比例自适应）
    self.pptView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, WIDTH * 3 / 4)];
    [self.view addSubview:self.pptView];
    
    //2.把ppt容器给SDK（要显示ppt区域的必须部分）
    [self.talkfunSDK configurePPTContainerView:self.pptView];
    
    //cameraView容器（4：3比例自适应）
    self.cameraView = [[UIView alloc] initWithFrame:CGRectMake(WIDTH - 150, CGRectGetMaxY(self.pptView.frame) + 35, 150, 150 * 3 / 4)];
    
    //3.把ppt容器给SDK（要显示摄像头区域的必须部分）
    [self.talkfunSDK configureCameraContainerView:self.cameraView];
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
