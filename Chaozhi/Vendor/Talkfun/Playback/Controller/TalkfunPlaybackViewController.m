//
//  TalkfunPlaybackViewController.m
//  TalkfunSDKDemo
//
//  Created by 孙兆能 on 2016/11/28.
//  Copyright © 2016年 talk-fun. All rights reserved.
//

#import "TalkfunPlaybackViewController.h"
//#import "TalkfunSDK.h"
#import "UIScrollView+TalkfunScrollView.h"
#import "UIView+TalkfunView.h"
//#import "NetworkDetector.h"
#import "TalkfunNetworkLines.h"
#import "BaseTableViewController.h"
#import "TalkfunButtonView.h"
#import "TalkfunNewFunctionView.h"
#import "TalkfunKuaiJinView.h"
#import "HYAlertView.h"
#import "UIImageView+WebCache.h"
#import "TalkfunLoadingView.h"
#import "TalkfunWatermark.h"
#import "TalkfunCourseManagement.h"
#import "TalkfunModulation.h"
#import "BulletView.h"
#import "TalkfunAdvertView.h"
#define ButtonViewHeight 35
#define KIsiPhoneX  @available(iOS 11.0, *) && UIApplication.sharedApplication.keyWindow.safeAreaInsets.bottom > 0.0
#import "DBManager.h"
#import "CZCommentView.h"

@interface TalkfunPlaybackViewController ()<UIScrollViewDelegate,TalkfunSDKPlaybackDelegate,UIAlertViewDelegate,UIGestureRecognizerDelegate>

//SDK
@property (nonatomic,strong) TalkfunSDKPlayback * talkfunSDK;
//@property (nonatomic,strong) UIView * pptBottomView;
@property (nonatomic,strong) UIView * pptView;
@property (nonatomic,strong) UIView * cameraView;
//桌面分享(可选、默认pptView为desktopShareView)
@property (nonatomic,strong) UIView * desktopShareView;
//下载管理对象
@property (nonatomic,strong) TalkfunDownloadManager * downloadManager;
//网络监测对象
//@property (nonatomic,strong) NetworkDetector * networkDetector;

//ppt信息及按钮
@property (nonatomic,strong) TalkfunNewFunctionView * pptsFunctionView;
@property (nonatomic,strong) TalkfunKuaiJinView * kuaiJinView;

//scrollView及其上面的东西
@property (nonatomic,strong) UIScrollView * scrollView;
@property (nonatomic,strong) UIView * shadowView;

//btnView
@property (nonatomic,strong) TalkfunButtonView * buttonView;

//其它
//tableView的数量
@property (nonatomic,assign) NSInteger tableViewNum;
//是否切换了容器
@property (nonatomic,assign) BOOL isExchanged;
//是否已经开始
@property (nonatomic,assign) BOOL unStart;
//记录播放时长
@property (nonatomic,assign) CGFloat liveLong;
//btnNames
@property (nonatomic,strong) NSMutableArray * btnNames;
//原始pptframe
@property (nonatomic,assign) CGRect originPPTFrame;
//横竖屏
@property (nonatomic,assign) BOOL isOrientationLandscape;
//是否是iPad且自动旋转
@property (nonatomic,assign) BOOL iPadAutoRotate;
@property (nonatomic,strong)HYAlertView *alertView ;
@property (nonatomic,strong) TalkfunLoadingView * loadingView;
//记录摄像头是否全屏
@property (nonatomic,assign) BOOL isCameraFullScreen;

//视频窗口上的菊花
@property (nonatomic,strong) UIActivityIndicatorView * activityIndicator;
//进场动画是否显示
@property(nonatomic,assign)BOOL isLoading;

//是否是桌面分享
@property (nonatomic,assign)BOOL isDesktop;
@property (nonatomic,strong)UIAlertView *alertView_1;
@property (nonatomic,strong)NSDictionary *nameDict;
@property (strong, nonatomic)CATextLayer *layer;//水印
@property (nonatomic,strong) NSTimer * layerTimer;
@property (nonatomic,assign)CGFloat playDuration;//播放了多少秒
@property (nonatomic,strong)TalkfunModulation* modulation ;//系统音量调节
@property (nonatomic, assign) float lastVolume; // 上一次调节音量时的音量大小

//弹幕
@property (nonatomic,strong) BulletView * barrageRender;
@property(nonatomic,strong)NSMutableArray*playbackChat;//所有聊天数据
@property(nonatomic,assign)NSInteger direction ;//5//还同记录方向
@property (nonatomic,assign) int  origin;//触屏原点
@property(nonatomic,assign)BOOL scrollViewWillBegin;
@property (nonatomic,strong) TalkfunAdvertView *advertView;//广告视图

/** 评价视图 */
@property (nonatomic,retain) CZCommentView *commentView;
/** 是否评价 YES已评价 */
@property (nonatomic,assign) BOOL is_review;

@end

@implementation TalkfunPlaybackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isPanForbid = YES; //禁用侧滑返回
    
    if ([[DBManager shareManager] existVideo:self.videoItem]) {
        self.downloadCompleted = YES;
    }
    
    self.view.backgroundColor = [UIColor blackColor];
    [APPLICATION setStatusBarHidden:YES];
    self.isOrientationLandscape = NO;
    self.iPadAutoRotate = YES;
    self.isCameraFullScreen = NO;
    self.unStart = YES;
    
    //开始
    [self getAccessToken];
    [self createUI];
    //sdk的监听回调
    [self registerEventListener];
    [self addGesture];
    
    if ([self.videoItem.type isEqualToString:@"2"]) { //超职、直播/回放
        [self initCommentView];
        [self getLiveCommentInfo]; //获取直播评论信息
    }
}

- (void)initCommentView {
    _commentView = [[CZCommentView alloc] initWithFrame:CGRectZero];;
    [self.view addSubview:_commentView];
    __weak typeof(self) weakSelf = self;
    _commentView.submitBlock = ^(NSDictionary * _Nonnull resultDic) {
        NSDictionary *dic = @{@"product_id":weakSelf.videoItem.product_id,
                              @"live_id":weakSelf.videoItem.live_id,
                              @"star":resultDic[@"star"],
                              @"tag":resultDic[@"tag"]
                              };
        [[NetworkManager sharedManager] postJSON:URL_LiveReview parameters:dic completion:^(id responseData, RequestState status, NSError *error) {
            if (status == Request_Success) {
                [Utils showToast:@"感谢您的评价！"];
                [weakSelf.commentView hiddenView];
                /** 欢拓自带退出方法 */
                NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
                [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
                
                [TalkfunCourseManagement setPlay:[weakSelf.playbackID  integerValue] progress:weakSelf.playDuration];
                
                [[NSNotificationCenter defaultCenter] removeObserver:weakSelf];
                
                [weakSelf.view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
                if (weakSelf.isOrientationLandscape) {
                    [UIApplication sharedApplication].statusBarOrientation = UIInterfaceOrientationPortrait;
                }
                [weakSelf.talkfunSDK destroy];
                [weakSelf timerInvalidate];
                QUITCONTROLLER(weakSelf)
            }
        }];
    };
}

#pragma mark - 直播评价

/** 获取直播评论信息 */
- (void)getLiveCommentInfo {
    __weak typeof(self) weakSelf = self;
    NSDictionary *dic = @{@"product_id":self.videoItem.product_id,@"live_id":self.videoItem.live_id};
    [[NetworkManager sharedManager] postJSON:URL_LiveReviewInfo parameters:dic completion:^(id responseData, RequestState status, NSError *error) {
        if (status == Request_Success) {
            if ([responseData isKindOfClass:[NSDictionary class]]) {
                if ([[responseData valueForKey:@"is_review"] integerValue] == 0) {
                    weakSelf.is_review = NO;
                    weakSelf.commentView.dataSource = responseData;
                } else {
                    weakSelf.is_review = YES;
                }
            }
        }
    }];
}

#pragma mark StatusBarHidden

- (BOOL)prefersStatusBarHidden{
    return YES;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self addLoadingView];
    self.navBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self uploadProgress]; //上传视频进度到后台
}

#pragma mark - ***上传视频进度到后台***
- (void)uploadProgress {
    if ([self.videoItem.product_id isEqualToString:@"0"]) { //首页公开课不上传进度
        return;
    }
    self.videoItem.time = [NSString stringWithFormat:@"%d",(int)self.playDuration];
    self.videoItem.total_time = [NSString stringWithFormat:@"%d",(int)self.liveLong];
    NSDictionary *dic = @{@"type":self.videoItem.type,@"product_id":self.videoItem.product_id,@"live_id":self.videoItem.live_id,@"time":self.videoItem.time,@"total_time":self.videoItem.total_time};
    [[NetworkManager sharedManager] postJSON:URL_LiveProgress parameters:dic imageDataArr:nil imageName:nil completion:^(id responseData, RequestState status, NSError *error) {
        if (status == Request_Success) {
            
        }
    }];
}

- (void)addLoadingView{
    
    if (self.isLoading) {
        return;
    }
    [self.view addSubview:self.loadingView];
    //    [self.loadingView configLogo:self.res[@"data"][@"logo"] courseName:self.res[@"data"][@"title"]];
    NSDictionary*Course = [TalkfunCourseManagement getLogoUrl:[self.playbackID integerValue]];
    
    if (Course.count>0) {
        
        [self.loadingView configLogo:Course[@"url"] courseName:Course[@"title"]];
    }else{
        
        [self.loadingView configLogo:self.res[@"data"][@"logo"]courseName:self.res[@"data"][@"title"]];
        //缓存用户数据
        [TalkfunCourseManagement saveLogoUrl:self.res[@"data"][@"logo"] roomId:[self.playbackID integerValue] title:self.res[@"data"][@"title"]];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.loadingView removeFromSuperview];
        self.loadingView = nil;
        self.isLoading = YES;
    });
}

#pragma mark - 实例化talkfunSDK
- (void)getAccessToken
{
    NSString * token = nil;
    if (_res) {
        
        token = _res[@"data"][@"access_token"];
        if (token && ![token isEqualToString:@""]) {
            [self configViewWithAccessToken:token];
        }
    }else if(self.access_token){
        [self configViewWithAccessToken:self.access_token];
    }
    else
    {
        //        [self configViewWithAccessToken:nil];
        
        WeakSelf
        [self.view toast:@"token不能为空" position:ToastPosition];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            QUITCONTROLLER(weakSelf)
        });
    }
}

//SDK初始化基本东西
- (void)configViewWithAccessToken:(NSString *)access_token
{
    //属性字典
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    //可选设置（离线播放必备）
    NSString * playbackID = self.res[TalkfunPlaybackID];
    parameters[TalkfunPlaybackID] = playbackID;
    
    //1.实例化SDK
    self.talkfunSDK = [[TalkfunSDKPlayback alloc] initWithAccessToken:access_token parameters:parameters];
    self.talkfunSDK.delegate = self;
    //    是否开启自动的线路选择
    //    self.talkfunSDK.autoSelectNetwork = NO;
    
    //进入后台是否暂停（默认是暂停）
    [self.talkfunSDK setPauseInBackground:YES];
    
    //ppt容器（4：3比例自适应）
    
    self.pptView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenSize.width, self.view.frame.size.width * 3 / 4.0)];
    self.pptView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.pptView];
    
    //2.把ppt容器给SDK（要显示ppt区域的必须部分）
    [self.talkfunSDK configurePPTContainerView:self.pptView];
    
    //cameraView容器
    self.cameraView = [[UIView alloc] initWithFrame:CGRectMake(ScreenSize.width - 150, CGRectGetMaxY(self.pptView.frame) + 35, 150, 150 * 3 / 4.0)];
    if (IsIPAD) {
        self.cameraView .frame = CGRectMake(ScreenSize.width * 0.7, CGRectGetMaxY(self.pptView.frame) + 35, ScreenSize.width * 0.3, ScreenSize.width * 0.3 * 3 / 4.0);
    }
    self.cameraView .backgroundColor = [UIColor blackColor];
    //首先把容器隐藏
    self.cameraView .hidden = YES;
    
    //3.把ppt容器给SDK（要显示摄像头区域的必须部分）
    [self.talkfunSDK configureCameraContainerView:self.cameraView];
    
    //    //桌面分享(可选、默认pptView为desktopShareView)
    //    self.desktopShareView = ({
    //        UIView * view = [[UIView alloc] initWithFrame:self.pptView.frame];
    //        [self.talkfunSDK configureDesktopContainerView:view];
    //        view;
    //    });
}

- (void)createUI
{
    [self createPPTsButton];
    [self createScrollView];
    [self.view addSubview:self.buttonView];
    
    //隐藏下载按键
    if(self.downloadCompleted==YES){
        self.buttonView.downloadBtn.hidden = YES;
        self.pptsFunctionView.networkBtn.hidden = YES;
        self.pptsFunctionView.networkX.constant = 0;
    }
    [self.view addSubview:self.cameraView];
    
    if ([self.videoItem.type isEqualToString:@"2"]) { //回放加片头
        //广告片头
        self.advertView = [[TalkfunAdvertView alloc] initWithFrame:CGRectMake(0, 0, ScreenSize.width, ScreenSize.height )];
        self.advertView.hidden = YES;
        self.advertView.backgroundColor =  [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1];;
        [self.view addSubview:self.advertView];
        [self.talkfunSDK setADVideoContainer:self.advertView.videoView];
        [self.advertView.back addTarget:self action:@selector(backClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.advertView.prompt addTarget:self action:@selector(promptClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.advertView.fullScreen addTarget:self action:@selector(fullScreenClick:) forControlEvents:UIControlEventTouchUpInside];
    }
}

#pragma mark - PPT上的功能按钮
- (void)createPPTsButton{
    [self.pptView addSubview:self.pptsFunctionView];
    if (IsIPAD) {
        [self.pptsFunctionView totalTimeLabelShow:YES];
    }
}

- (void)createScrollView
{
    [self.view addSubview:self.shadowView];
    [self.view addSubview:self.scrollView];
    
    /*=================加tableView===================*/
    NSArray * tableViewNameArray = @[@"ChatViewController",
                                     @"QuestionViewController",
                                     @"ChapterViewController",
                                     @"AlbumViewController"];
    self.tableViewNum = tableViewNameArray.count;
    self.scrollView.contentSize = CGSizeMake((self.tableViewNum-1)*CGRectGetWidth(self.scrollView.frame), CGRectGetHeight(self.scrollView.frame));
    WeakSelf
    for (int i = 0; i < tableViewNameArray.count; i ++) {
        Class className = NSClassFromString(tableViewNameArray[i]);
        BaseTableViewController * tableVC = [[className alloc] init];
        tableVC.view.frame = CGRectMake(i*CGRectGetWidth(self.scrollView.frame), 0, CGRectGetWidth(self.scrollView.frame), CGRectGetHeight(self.scrollView.frame));
        tableVC.view.tag = 300+i;
        [self.scrollView addSubview:tableVC.view];
        [self addChildViewController:tableVC];
        
        if (i == 2) {
            tableVC.setDurationBlock = ^(CGFloat duration){
                [weakSelf seek:duration];
            };
        }else if (i == 3){
            tableVC.setAlbumBlock = ^(NSString *access_token){
                [weakSelf.talkfunSDK configureAccessToken:access_token playbackID:nil];
                weakSelf.pptsFunctionView.slider.value = 0;
            };
        }
        tableVC.view.backgroundColor = DARKBLUECOLOR;
    }
    self.scrollView.contentOffset = CGPointMake(CGRectGetWidth(self.scrollView.frame)*2, 0);
    self.buttonView.selectViewLeadingSpace.constant = self.buttonView.chatBtnWidth.constant * 2;
}

#pragma mark - 监听事件
- (void)registerEventListener{
    
    WeakSelf
    
    [self.talkfunSDK on:TALKFUN_EVENT_ROOM_INIT callback:^(id obj) {
        
        weakSelf.nameDict =   [TalkfunWatermark getWatermarkName:obj];
        NSLog(@"水印的名字====>%@",weakSelf.nameDict);
        [weakSelf addWatermarkLayer];
        //读取播放进度
        
        NSInteger second  = [TalkfunCourseManagement getPlayProgress:[weakSelf.playbackID integerValue]];
        
        if(second > 0){
            //快进到这里
            [weakSelf.talkfunSDK seek:second];
        }
        //配置 提问与聊天
        [weakSelf mod_playbackinfo_playback:obj];
    }];
    
    //TODO:摄像头开
    [self.talkfunSDK on:TALKFUN_EVENT_CAMERA_SHOW callback:^(id obj) {
        if (weakSelf.pptsFunctionView.cameraBtn.selected) {
            return ;
        }
        weakSelf.cameraView.hidden = NO;
        if (IsIPAD&&[UIApplication sharedApplication].statusBarOrientation!=UIInterfaceOrientationPortrait&&weakSelf.pptsFunctionView.fullScreenBtn.selected==NO) {
            [weakSelf reloadScrollView:NO];
        }
        if (KIsiPhoneX) {
            [weakSelf.pptsFunctionView.CameraBtn1 setImage:[UIImage imageNamed:@"开启摄像头"] forState:UIControlStateNormal];
        }else{
            [weakSelf.pptsFunctionView.cameraBtn setImage:[UIImage imageNamed:@"开启摄像头"] forState:UIControlStateNormal];
        }
    }];
    //TODO:摄像头关
    [self.talkfunSDK on:TALKFUN_EVENT_CAMERA_HIDE callback:^(id obj) {
        
        if (weakSelf.talkfunSDK.liveMode != TalkfunLiveModeDesktop) {
            weakSelf.cameraView.hidden = YES;
        }else{
            if (weakSelf.isExchanged) {
                [weakSelf.talkfunSDK exchangePPTAndCameraContainer];
                weakSelf.isExchanged = NO;
            }
            weakSelf.cameraView.hidden = NO;
        }
        if (IsIPAD&&[UIApplication sharedApplication].statusBarOrientation!=UIInterfaceOrientationPortrait&&weakSelf.pptsFunctionView.fullScreenBtn.selected==NO) {
            [weakSelf reloadScrollView:YES];
        }
        if (KIsiPhoneX) {
            [weakSelf.pptsFunctionView.CameraBtn1 setImage:[UIImage imageNamed:@"关闭摄像头"] forState:UIControlStateNormal];
        }else{
            [weakSelf.pptsFunctionView.cameraBtn setImage:[UIImage imageNamed:@"关闭摄像头"] forState:UIControlStateNormal];
        }
    }];
    //视频切换
    [self.talkfunSDK on:TALKFUN_EVENT_MODE_CHANGE callback:^(id obj) {
        TalkfunLiveMode mode = [obj[@"currentMode"] intValue];
        TalkfunLiveMode mode2 = [obj[@"beforeMode"] intValue];
        
        if (mode != mode2) {
            UILabel * lab = [(UILabel *)weakSelf.view viewWithTag:222];
            if (lab) {
                return ;
            }
            UILabel * tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMinY(weakSelf.pptsFunctionView.frame)+50, 100, 30)];
            tipsLabel.text = @"切换中...";
            tipsLabel.textColor = [UIColor whiteColor];
            tipsLabel.backgroundColor = [UIColor redColor];
            tipsLabel.textAlignment = NSTextAlignmentCenter;
            tipsLabel.font = [UIFont systemFontOfSize:14];
            tipsLabel.tag = 222;
            [weakSelf.pptView addSubview:tipsLabel];
        }
    }];
    //TODO:当时视频播放的时候的回调
    [self.talkfunSDK on:TALKFUN_EVENT_PLAY callback:^(id obj) {
        //        [weakSelf.loadingView removeFromSuperview];
        //        weakSelf.loadingView = nil;
        weakSelf.unStart = NO;
        [weakSelf.pptsFunctionView play:YES];
        weakSelf.pptsFunctionView.slider.userInteractionEnabled = YES;
        
        UILabel * tipsLabel = [weakSelf.pptView viewWithTag:222];
        [tipsLabel removeFromSuperview];
        tipsLabel = nil;
    }];
    //TODO:回放开始
    [self.talkfunSDK on:TALKFUN_EVENT_VOD_START callback:^(id obj) {
        weakSelf.unStart = NO;
        [weakSelf.pptsFunctionView play:YES];
    }];
    //TODO:回放完毕
    [self.talkfunSDK on:TALKFUN_EVENT_VOD_STOP callback:^(id obj) {
        weakSelf.unStart = YES;
        [weakSelf.pptsFunctionView play:NO];
        if (weakSelf.btnNames.count > 3) {
            //[[NSNotificationCenter defaultCenter] postNotificationName:@"VodStop" object:nil];
        }
        [self uploadProgress]; //上传视频进度到后台
    }];
    //TODO:监测视频播放进度
    [self.talkfunSDK on:TALKFUN_EVENT_VOD_DURATION callback:^(id obj) {
        CGFloat duration = [obj floatValue];
        //获取弹幕然后弹出来
        [weakSelf getBarrageRenderL:duration];
        weakSelf.playDuration = duration;
        [weakSelf.pptsFunctionView setDuration:duration];
        for (int i = 0; i < 3; i ++) {
            //            if (i == 0) {
            UIView * tableView = (UIView *)[weakSelf.scrollView viewWithTag:300 + i];
            id tableViewV = tableView.nextResponder;
            BaseTableViewController * tableViewVC = tableViewV;
            [tableViewVC refreshUIWithDuration:duration];
        }
    }];
    
    //TODO:视频总长度监听
    [self.talkfunSDK on:TALKFUN_EVENT_VOD_INFO callback:^(id obj) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"deleteData" object:nil];
        weakSelf.liveLong = [obj[@"duration"] integerValue];
        weakSelf.pptsFunctionView.slider.maximumValue = weakSelf.liveLong;
        
        NSMutableArray *album = obj[@"album"];
        if ([album isKindOfClass:[NSNull class]]||album.count==0) {
            //专辑隐藏
            //            UIButton * btn = (UIButton *)[weakSelf.btnView viewWithTag:103];
            //            btn.hidden = YES;
            [weakSelf.buttonView album:NO];
            [weakSelf.btnNames removeObject:@"专辑"];
        }else{
            //            UIButton * btn = (UIButton *)[weakSelf.btnView viewWithTag:103];
            //            btn.hidden =NO;
            [weakSelf.buttonView album:YES];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"GetPlayAlbum" object:nil userInfo:@{@"mess":obj}];
            if (![weakSelf.btnNames containsObject:@"专辑"]) {
                [weakSelf.btnNames addObject:@"专辑"];
            }
            weakSelf.scrollView.contentSize = CGSizeMake(CGRectGetWidth(weakSelf.scrollView.frame) * weakSelf.btnNames.count, CGRectGetHeight(weakSelf.scrollView.frame));
        }
    }];
    //TODO:问答数据
    [self.talkfunSDK on:TALKFUN_EVENT_VOD_QUESTION_APPEND callback:^(id obj) {
        if (obj && [obj isKindOfClass:[NSArray class]]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"playbackAsk" object:nil userInfo:@{@"mess":obj}];
        }
    }];
    //TODO:聊天数据
    [self.talkfunSDK on:TALKFUN_EVENT_VOD_MESSAGE_APPEND callback:^(id obj) {
        [weakSelf addPlaybackChat:obj];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"playbackChat" object:nil userInfo:@{@"mess":obj}];
    }];
    //TODO:章节数据
    [self.talkfunSDK on:TALKFUN_EVENT_VOD_CHAPTER_LIST callback:^(id obj) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"chapterList" object:nil userInfo:@{@"mess":obj}];
    }];
    
    //TODO:广播
    [self.talkfunSDK on:TALKFUN_EVENT_BROADCAST callback:^(id obj) {
        NSLog(@"打印广播====>%@",obj);
        //        [weakSelf broadcast:obj];
    }];
    
    //当前页的frame
    //    [self.talkfunSDK on:TALKFUN_EVENT_WHITEOARD_PAGE_FRAME callback:^(id obj) {
    //
    //        if ([obj[@"frame"] isKindOfClass:[NSString class]]) {
    //            //字符串转换回frame
    //            //            CGRect frame =  CGRectFromString(obj[@"frame"]);
    //
    //            NSLog(@"回放的当前页的frame%@",obj[@"frame"]);
    //
    //
    //        }
    //    }];
    //=================== 监听键盘 ====================
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardDidShow:) name:UIKeyboardWillShowNotification object:nil];
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardDidHide:) name:UIKeyboardWillHideNotification object:nil];
    //=================== 监听进入后台 ====================
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onUIApplicationDidEnterBackgroundNotification:)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
    //=================== SDK发出的错误 ==================
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(errorNotification:) name:TalkfunErrorNotification object:nil];
    
    //    if (IsIPAD) {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationChanged:) name:UIDeviceOrientationDidChangeNotification object:nil];
    //    }
}

- (void)errorNotification:(NSNotification *)notification {
    NSDictionary * userInfo = notification.userInfo;
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:[NSString stringWithFormat:@"%@",[self dictionaryToJson:userInfo]] delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        alertView.alertViewStyle = UIAlertViewStyleDefault;
        [alertView show];
        
    });
}

- (NSString*)dictionaryToJson:(NSDictionary *)dic {
    if ([dic isKindOfClass:[NSDictionary class]]) {
        NSError *parseError = nil;
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
        
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    } else {
        return @"";
    }
}

#pragma mark - 按钮点击事件
- (void)pptsButtonClicked:(UIButton *)button
{
    //返回按钮
    if (button == self.pptsFunctionView.backBtn) {
        if (self.is_review == NO
            && [self.videoItem.type isEqualToString:@"2"]
            && self.playDuration>=30*60) { //超职、回放/直播
            [self.commentView showView];
        } else {
            HYAlertView *alertView = [[HYAlertView alloc] initWithTitle:@"提示" message:@"确定要退出吗" buttonTitles:@"取消", @"确定", nil];
            self.alertView = alertView;
            alertView.alertViewStyle = HYAlertViewStyleDefault;
            
#pragma mark - ---超职修改
            alertView.isOrientationLandscape = NO;
#pragma mark - 超职修改---
            
            WeakSelf
            [alertView showInView:self.view completion:^(HYAlertView *alertView, NSInteger selectIndex) {
                if (selectIndex == 1) {
                    NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
                    [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
                    
                    [TalkfunCourseManagement setPlay:[weakSelf.playbackID  integerValue] progress:weakSelf.playDuration];
                    
                    [[NSNotificationCenter defaultCenter] removeObserver:weakSelf];
                    
                    [weakSelf.view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
                    if (weakSelf.isOrientationLandscape) {
                        [UIApplication sharedApplication].statusBarOrientation = UIInterfaceOrientationPortrait;
                    }
                    [weakSelf.talkfunSDK destroy];
                    [weakSelf timerInvalidate];
                    QUITCONTROLLER(weakSelf)
                }
            }];
        }
    }
    //全屏按钮
    else if (button == self.pptsFunctionView.fullScreenBtn){
        
        if (!button.selected && [UIApplication sharedApplication].statusBarOrientation != UIInterfaceOrientationPortrait) {
            [self manualFullScreen:YES];
        }else if (button.selected == YES && fromLandscape == YES){
            [self manualFullScreen:NO];
        }else{
            self.iPadAutoRotate = NO;
            [self fullScreen];
        }
    }
    //隐藏camera按钮
    else if (button.tag == 201){
        if (self.unStart||self.talkfunSDK.liveMode==TalkfunLiveModeDesktop) {
            return;
        }
        button.selected = !button.selected;
        if (self.isExchanged) {
            [self.talkfunSDK exchangePPTAndCameraContainer];
        }
        if (button.selected) {
            self.cameraView.hidden = YES;
            [button setImage:[UIImage imageNamed:@"关闭摄像头"] forState:UIControlStateNormal];
        }else{
            self.cameraView.hidden = NO;
            [button setImage:[UIImage imageNamed:@"开启摄像头"] forState:UIControlStateNormal];
        }
        if (IsIPAD && [UIApplication sharedApplication].statusBarOrientation != UIInterfaceOrientationPortrait && !self.pptsFunctionView.fullScreenBtn.selected) {
            [self reloadScrollView:button.selected];
        }
    }
    //切换ppt和camera
    else if (button == self.pptsFunctionView.exchangeBtn){
        if (self.cameraView.hidden||self.talkfunSDK.liveMode==TalkfunLiveModeDesktop) {
            return;
        }
        [self.talkfunSDK exchangePPTAndCameraContainer];
        
        self.isExchanged = !self.isExchanged;
        
        [self updateChrysanthemum];
    }
    //网络选择按钮
    else if (button == self.pptsFunctionView.networkBtn){
        UIView * view = [[UIApplication sharedApplication].keyWindow viewWithTag:123];
        if (!view) {
            //TODO:线路选择
            
            WeakSelf
            [self.talkfunSDK getNetworkList:^(id result) {
                
                if ([result[@"code"] intValue] == TalkfunCodeSuccess) {
                    TalkfunNetworkLines * networkLinesView = [[NSBundle mainBundle] loadNibNamed:@"TalkfunNetworkLines" owner:nil options:nil][0];
                    networkLinesView.tag = 123;
                    networkLinesView.networkLinesArray = result[@"data"][@"operators"];
                    
                    networkLinesView.frame = CGRectMake(0, 0, ScreenSize.width, ScreenSize.height);
                    
                    //设置线路
                    networkLinesView.networkLineBlock = ^(NSNumber * networkLineIndex){
                        [weakSelf.talkfunSDK setNetworkLine:networkLineIndex];
                        
                    };
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [weakSelf.view addSubview:networkLinesView];
                    });
                    
                }else{
                    NSLog(@"获取列表失败");
                    NSLog(@"%@",result);
                }
            }];
        }
    }
    //刷新按钮
    else if (button == self.pptsFunctionView.refreshBtn){
        [self refresh];
        self.isExchanged = NO;
        //倍速播放
    } else if (button == self.pptsFunctionView.smooth){
        
        [self.pptsFunctionView   playbackRate];
    }else if (button == self.pptsFunctionView.danmuBtn){
        
        button.selected = !button.selected;
        if (!button.selected) {
            [button setImage:[UIImage imageNamed:@"开启弹幕"] forState:UIControlStateNormal];
            
            self.barrageRender.bulletSwitch = YES;
        }else{
            [button setImage:[UIImage imageNamed:@"关闭弹幕"] forState:UIControlStateNormal];
            
            self.barrageRender.bulletSwitch = NO;
        }
    }
}
- (void)refresh{
    /*
     if (APPLICATION.statusBarOrientation == UIInterfaceOrientationLandscapeRight) {
     [self orientationPortrait];
     }
     [self.talkfunSDK destroy];
     self.talkfunSDK = nil;
     self.buttonView = nil;
     self.pptsFunctionView = nil;
     self.isExchanged = NO;
     [self.view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
     [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
     [self.scrollView removeFromSuperview];
     self.scrollView = nil;
     [[NSNotificationCenter defaultCenter] removeObserver:self];
     for (UIViewController * vc in self.childViewControllers) {
     [vc willMoveToParentViewController:nil];
     [vc removeFromParentViewController];
     }
     [self viewDidLoad];
     [self viewWillAppear:YES];
     [self viewDidAppear:YES];
     */
    [self.talkfunSDK reload];
}
- (void)playBtnClicked:(UIButton *)button
{
    if (button.selected) {
        [self.talkfunSDK play];
    }else{
        [self.talkfunSDK pause];
    }
    [self.pptsFunctionView play:button.selected];
}
- (void)btnViewButtonsClicked:(UIButton *)button
{
    if (button != self.buttonView.downloadBtn) {
        [self.buttonView selectButton:(TalkfunNewButtonViewButton *)button];
        [self.scrollView setContentOffset:CGPointMake(self.scrollView.frame.size.width * (button.tag - 500), 0) animated:NO];
    }else{
        
        if (![Utils isLoginWithJump:NO]) {
            [Utils showToast:@"请先登录后下载"];
            return;
        }
        
        BOOL contains = [self.downloadManager containsPlaybackID:self.playbackID];
        if (contains) {
            [[DBManager shareManager] insertVideo:self.videoItem];
            [self.view downloadToast:@"该回放已下载，请到我的下载中查看" position:CGPointMake(ScreenSize.width - 70, CGRectGetMaxY(self.buttonView.frame)-5+19)];
            return;
        }
        
        if ([Utils currentNetworkStatus] == NotReachable) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"网络已断开" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
                alertView.alertViewStyle = UIAlertViewStyleDefault;
                [alertView show];
            });
            
        }
        else if ([Utils currentNetworkStatus] == ReachableViaWWAN) {
            
            
            //        if ([self.networkDetector networkStatus] != 1) {
            [self networkAlertShow];
        }else
        {
            NSString * token = _res[@"data"][@"access_token"];
            [self.downloadManager appendDownloadWithAccessToken:token playbackID:self.playbackID title:nil];
            [self.downloadManager startDownload:self.playbackID];
            [[DBManager shareManager] insertVideo:self.videoItem];
            PERFORM_IN_MAIN_QUEUE([self.view toast:@"已开始下载，请到我的下载中查看" position:ToastPosition];)
        }
    }
}

- (void)reloadScrollView:(BOOL)cameraHide{
    [UIView animateWithDuration:0.25 animations:^{
        CGRect buttonViewFrame = self.buttonView.frame;
        buttonViewFrame.origin.y = cameraHide?0:CGRectGetMaxY(self.cameraView.frame);
        self.buttonView.frame = buttonViewFrame;
        [self.buttonView selectButton:self.buttonView.selectBtn];
        
        //修改scrollView的frame和contentSize
        self.scrollView.frame = CGRectMake(CGRectGetMaxX(self.pptView.frame), CGRectGetMaxY(self.buttonView.frame), self.view.bounds.size.width - CGRectGetMaxX(self.pptView.frame), self.view.bounds.size.height - CGRectGetMaxY(self.buttonView.frame));
        self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.scrollView.frame) * self.btnNames.count, CGRectGetHeight(self.scrollView.frame));
        self.shadowView.frame = self.scrollView.frame;
    }];
}
static BOOL fromLandscape = NO;
- (void)manualFullScreen:(BOOL)fullScreen{
    fromLandscape = fullScreen;
    [UIView animateWithDuration:0.25 animations:^{
        self.buttonView.hidden = fullScreen;
        self.scrollView.hidden = fullScreen;
        self.shadowView.hidden = fullScreen;
        
        self.pptView.frame = fullScreen?CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height):CGRectMake(0, 0, self.view.bounds.size.width * 7 / 10, self.view.bounds.size.height);
        
        //修改摄像头的frame
        self.cameraView.transform = CGAffineTransformIdentity;
        self.cameraView.frame = !fullScreen?CGRectMake(CGRectGetMaxX(self.pptView.frame), 0, CGRectGetWidth(self.view.bounds)-CGRectGetWidth(self.pptView.frame), (ScreenSize.width-CGRectGetWidth(self.pptView.frame))*3.0/4.0):CGRectMake(CGRectGetMaxX(self.pptView.frame) - CGRectGetHeight(self.view.bounds)*3.0/10.0, CGRectGetMaxY(self.pptView.frame)-50-(CGRectGetHeight(self.view.bounds)*3.0/10.0)*3.0/4.0, CGRectGetHeight(self.view.bounds)*3.0/10.0, (CGRectGetHeight(self.view.bounds)*3.0/10.0)*3.0/4.0);
        
        self.buttonView.frame = CGRectMake(CGRectGetMaxX(self.pptView.frame), self.cameraView.hidden?0:CGRectGetMaxY(self.cameraView.frame), ScreenSize.width-CGRectGetWidth(self.pptView.frame), ButtonViewHeight);
    }];
    self.pptsFunctionView.fullScreenBtn.selected = fullScreen;
    [self.pptsFunctionView.fullScreenBtn setImage:[UIImage imageNamed:fullScreen?@"退出全屏":@"全屏"] forState:UIControlStateNormal];
}

- (void)fullScreen {
    [self.view endEditing:YES];
    if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait) {
#pragma mark - ---超职修改
        NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeRight];
        [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
#pragma mark - 超职修改---
        self.pptsFunctionView.fullScreenBtn.selected = YES;
        [self.pptsFunctionView.fullScreenBtn setImage:[UIImage imageNamed:@"退出全屏"] forState:UIControlStateNormal];
        [self orientationLandscape];
    }else{
#pragma mark - ---超职修改
        NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
        [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
#pragma mark - 超职修改---
        self.pptsFunctionView.fullScreenBtn.selected = NO;
        [self.pptsFunctionView.fullScreenBtn setImage:[UIImage imageNamed:@"全屏"] forState:UIControlStateNormal];
        [self orientationPortrait];
    }
    self.iPadAutoRotate = YES;
    //隐藏下载按键
    if(self.downloadCompleted==YES){
        self.buttonView.downloadBtn.hidden = YES;
        self.pptsFunctionView.networkBtn.hidden = YES;
        self.pptsFunctionView.networkX.constant = 0;
    }
}

#pragma mark - 竖屏的适配
- (void)orientationPortrait {
    if (self.isOrientationLandscape) {
        CGFloat duration = [UIApplication sharedApplication].statusBarOrientationAnimationDuration;
        [UIView animateWithDuration:duration animations:^{
            [APPLICATION setStatusBarOrientation:UIInterfaceOrientationPortrait animated:YES];
        }];
    }
    [APPLICATION setStatusBarHidden:YES];
    self.view.bounds = CGRectMake(0, 0, ScreenSize.width, ScreenSize.height);
    [self orientationPortrait:YES];
    [self updateChrysanthemum];
}

- (void)deviceOrientationChanged:(NSNotification *)notification{
    [self.view endEditing:YES];
    [_commentView changeLayout];
    if ([UIDevice currentDevice].orientation == 3 && !self.isOrientationLandscape) {
        [self orientationLandscape];
    }else if ([UIDevice currentDevice].orientation==1 && self.isOrientationLandscape){
        [self orientationPortrait];
    }
}

- (void)orientationPortrait:(BOOL)portrait{
    @synchronized (self) {
        self.isOrientationLandscape = !portrait;
        
        self.pptView.frame = portrait?CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.width * 3 / 4):IsIPAD&&self.iPadAutoRotate?CGRectMake(0, 0, self.view.bounds.size.width * 7 / 10, self.view.bounds.size.height):CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
        
        if (IsIPAD) {
            self.cameraView.frame = portrait?CGRectMake(ScreenSize.width * 0.7, CGRectGetMaxY(self.pptView.frame) + 35, ScreenSize.width*0.3, ScreenSize.width*0.3*3.0/4.0):self.iPadAutoRotate?CGRectMake(CGRectGetMaxX(self.pptView.frame), 0, CGRectGetWidth(self.view.bounds)-CGRectGetWidth(self.pptView.frame), (ScreenSize.width-CGRectGetWidth(self.pptView.frame))*3.0/4.0):CGRectMake(CGRectGetMaxX(self.pptView.frame) - CGRectGetHeight(self.view.bounds)*3.0/10.0, CGRectGetMaxY(self.pptView.frame)-50-(CGRectGetHeight(self.view.bounds)*3.0/10.0)*3.0/4.0, CGRectGetHeight(self.view.bounds)*3.0/10.0, (CGRectGetHeight(self.view.bounds)*3.0/10.0)*3.0/4.0);
        }else{
            CGRect frame = self.cameraView.frame;
            frame.origin = portrait?CGPointMake(ScreenSize.width - 150, CGRectGetMaxY(self.pptView.frame) + 35):CGPointMake(CGRectGetMaxX(self.pptView.frame) - self.cameraView.frame.size.width, CGRectGetMaxY(self.pptView.frame)-50-CGRectGetHeight(frame));
            self.cameraView.frame = frame;
            [self.pptsFunctionView totalTimeLabelShow:!portrait];
        }
        self.buttonView.frame = portrait?CGRectMake(0, CGRectGetMaxY(self.pptView.frame), ScreenSize.width, ButtonViewHeight):CGRectMake(CGRectGetMaxX(self.pptView.frame), self.cameraView.hidden?0:CGRectGetMaxY(self.cameraView.frame), ScreenSize.width-CGRectGetWidth(self.pptView.frame), ButtonViewHeight);
        self.buttonView.downloadBtn.hidden = !portrait;
        CGFloat btnWidth = getButtonWidth(YES);
        if (CGRectGetWidth(self.buttonView.frame) < (btnWidth * self.btnNames.count)) {
            btnWidth = CGRectGetWidth(self.buttonView.frame) / (self.btnNames.count*1.0);
        }
        self.buttonView.chatBtnWidth.constant = btnWidth;
        
        self.scrollView.frame = portrait?CGRectMake(0, CGRectGetMaxY(self.pptView.frame) + ButtonViewHeight, ScreenSize.width, ScreenSize.height - CGRectGetMaxY(self.pptView.frame) - ButtonViewHeight):CGRectMake(CGRectGetMaxX(self.pptView.frame), CGRectGetMaxY(self.buttonView.frame), self.view.bounds.size.width - CGRectGetMaxX(self.pptView.frame), self.view.bounds.size.height - CGRectGetMaxY(self.buttonView.frame));
        self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.scrollView.frame) * self.btnNames.count, CGRectGetHeight(self.scrollView.frame));
        self.scrollView.contentOffset = CGPointMake(self.scrollView.frame.size.width * 2, 0);
        self.buttonView.selectViewLeadingSpace.constant = self.buttonView.chatBtnWidth.constant*2;
        
        for (int i = 0; i < self.tableViewNum; i ++) {
            UIView * tableView                    = (UIView *)[self.scrollView viewWithTag:300 + i];
            id tableViewV                         = tableView.nextResponder;
            BaseTableViewController * tableViewVC = tableViewV;
            tableViewVC.rotated                   = !portrait;
            tableView.frame                       = CGRectMake(i * self.scrollView.frame.size.width, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height);
            if (i == 0 || i == 1) {
                [tableViewVC recalculateCellHeight];
            }else
            [tableViewVC.tableView reloadData];
        }
        
        self.shadowView.frame = self.scrollView.frame;
        if (!IsIPAD||!self.iPadAutoRotate) {
            self.buttonView.hidden = !portrait;
            self.scrollView.hidden = !portrait;
            self.shadowView.hidden = !portrait;
        }
        self.originPPTFrame = self.pptView.frame;
    }
    
    [self updateChrysanthemum];
}

#pragma mark - 横屏的适配
- (void)orientationLandscape {
    if (!self.isOrientationLandscape) {
        [APPLICATION setStatusBarHidden:YES];
        CGFloat duration = [UIApplication sharedApplication].statusBarOrientationAnimationDuration;
        [UIView animateWithDuration:duration animations:^{
            [APPLICATION setStatusBarOrientation:UIInterfaceOrientationLandscapeRight animated:YES];
        }];
    }
    self.view.bounds = CGRectMake(0, 0, ScreenSize.width, ScreenSize.height);
    [self orientationPortrait:NO];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer*)gestureRecognizer shouldReceiveTouch:(UITouch*)touch {
    
    if([touch.view isKindOfClass:[UISlider class]])
    
    return NO;
    
    else
    
    return YES;
}

#pragma mark - 加手势
- (void)addGesture
{
    //ppt加手势
    UITapGestureRecognizer * pptTapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pptTapGR:)];
    pptTapGR.delegate= self;
    [self.pptView addGestureRecognizer:pptTapGR];
    
    UITapGestureRecognizer * pptDoubleTapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pptDoubleTapGR:)];
    pptDoubleTapGR.numberOfTapsRequired = 2;
    pptDoubleTapGR.delegate= self;
    [self.pptView addGestureRecognizer:pptDoubleTapGR];
    
    UIPanGestureRecognizer * pptPanGR = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pptPanGR:)];
    pptPanGR.delegate= self;
    [self.pptView addGestureRecognizer:pptPanGR];
    
    [pptTapGR requireGestureRecognizerToFail:pptPanGR];
    
    //摄像头加手势
    UIPanGestureRecognizer *panGR = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(objectDidDragged:)];
    panGR.maximumNumberOfTouches = 2;
    [self.cameraView addGestureRecognizer:panGR];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    //    tap.numberOfTapsRequired = 2;
    [self.cameraView addGestureRecognizer:tap];
    //
    self.originPPTFrame = self.pptView.frame;
    //摄像头缩放
    //UIPinchGestureRecognizer * pinchGR = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchGR:)];
    //[self.cameraView addGestureRecognizer:pinchGR];
}

/** 判断手势方向  */
- (NSInteger)commitTranslation:(CGPoint)translation {
    //负数变正数
    CGFloat absX = fabs(translation.x);
    //负数变正数
    CGFloat absY = fabs(translation.y);
    
    if (absX > absY ) {
        //        if (translation.x<0) {//向左滑动
        //        }else{//向右滑动
        //        }
        return 1;
    }
    
    return 3;
}

/** 判断手势方向  */
- (void)volumeAdjustment:(CGPoint)curP {
    
    NSInteger Y = 0;
    if (curP.y>0) {
        Y =   curP.y -   self.origin;
    }else{
        Y  =  abs((int)curP.y - self.origin);
    }
    
    if (Y >10) {
        
        self.origin = curP.y;
        
        if(curP.y>0){
            if(self.lastVolume>0){
                self.lastVolume = self.lastVolume - 0.08;
                //设置音量
                [self.modulation bfSetVolume:self.lastVolume];
            }
        }else{
            //             NSLog(@"上");
            if(self.lastVolume<1){
                self.lastVolume = self.lastVolume + 0.08;
                //设置音量
                [self.modulation bfSetVolume:self.lastVolume];
            }
        }
    }
}

#pragma mark 快进快退手势
- (void)pptPanGR:(UIPanGestureRecognizer *)pptPanGR{
    CGFloat const divSpeed = 4;
    static BOOL isValue = YES;
    if (pptPanGR.state == UIGestureRecognizerStateBegan) {
        //原点
        self.origin = 0;
        //第一次点击,设置默认值
        self.direction = 5;
        self.lastVolume = [self.modulation bfGetCurrentVolume];
        
        CGPoint location = [pptPanGR locationInView:self.pptView];
        if (!self.pptsFunctionView.hidden && (location.y<50||location.y>CGRectGetHeight(self.pptView.frame)-50)) {
            isValue = NO;
            return;
        }
    }else if (pptPanGR.state == UIGestureRecognizerStateChanged) {
        if (!isValue) {
            return;
        }
        
        //第一次判断,
        if ( self.direction == 5) {
            
            //判断方向
            self.direction  =    [self commitTranslation:[pptPanGR translationInView:self.view]];
        }
        //左右
        if (self.direction==3) {
            [self volumeAdjustment:[pptPanGR translationInView:self.view]];
        }
        
        //上下
        if (self.direction==1) {
            CGPoint offset = [pptPanGR translationInView:self.pptView];
            //NSLog(@"offfset:%@",NSStringFromCGPoint(offset));
            CGFloat X = offset.x;
            CGFloat kuai = X/divSpeed;
            CGFloat duration = self.pptsFunctionView.slider.value + kuai;
            if (duration > self.liveLong) {
                kuai = self.liveLong-self.pptsFunctionView.slider.value;
            }else if (kuai < 0 && self.pptsFunctionView.slider.value < fabs(kuai)){
                kuai = self.pptsFunctionView.slider.value;
            }
            //        NSLog(@"进度秒数======>%f",duration);
            self.playDuration = duration;
            self.pptsFunctionView.timeLabel.text = [self getTimeStr:duration];
            
            [self.kuaiJinView kuai:kuai timeLabel:self.pptsFunctionView.timeLabel.text totalTimeLabel:self.pptsFunctionView.totalTimeLabel.text];
        }
    } else if (pptPanGR.state == UIGestureRecognizerStateEnded){
        //初始化
        
        if (!isValue) {
            self.direction = 5;
            isValue = YES;
            return;
        }
        
        if (self.direction == 1) {
            self.direction = 5;
            CGPoint offset = [pptPanGR translationInView:self.pptView];
            //NSLog(@"offfset:%@",NSStringFromCGPoint(offset));
            CGFloat X = offset.x;
            CGFloat duration = self.pptsFunctionView.slider.value + X/divSpeed;
            if (duration > self.liveLong) {
                duration = self.liveLong;
            }else if (duration < 0){
                duration = 0;
            }
            if (fabs(X/divSpeed)>=1.0) {
                [self seek:duration];
            }
            [self.kuaiJinView removeFromSuperview];
            self.kuaiJinView = nil;
        }
    }
}

- (NSString *)getTimeStr:(CGFloat)duration {
    NSInteger hour   = duration / 3600;
    NSInteger minute = (duration - hour * 3600) / 60;
    NSInteger second = duration - minute * 60 - hour * 3600;
    return [NSString stringWithFormat:@"%02ld:%02ld:%02ld",(long)hour,(long)minute,(long)second];
}

- (void)tap:(UITapGestureRecognizer *)tap
{
    //收键盘
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    
    static CGAffineTransform transform;
    static CGRect frame;
    __weak typeof(self) weakSelf = self;
    if (self.isCameraFullScreen == NO) {
        self.isCameraFullScreen = YES;
        //先保存原来的transform
        transform = self.cameraView.transform;
        
        //先保存原来cameraView的frame的大小
        frame = self.cameraView.frame;
        //设为黑色和全屏
        //self.cameraView.backgroundColor = [UIColor blackColor];
        
        [UIView animateWithDuration:0.5 animations:^{
            weakSelf.cameraView.transform = CGAffineTransformIdentity;
            weakSelf.cameraView.frame = CGRectMake(0, 0, ScreenSize.width, ScreenSize.height);
            [self updateChrysanthemum];
        }];
    }
    else
    {
        self.isCameraFullScreen = NO;
        //设为原来的颜色和原来的frame
        //weakSelf.cameraView.backgroundColor = [UIColor clearColor];
        [UIView animateWithDuration:0.5 animations:^{
            weakSelf.cameraView.frame = frame;
            [self updateChrysanthemum];
        } completion:^(BOOL finished) {
            //设为原来的颜色和原来的frame
            //            weakSelf.cameraView.backgroundColor = [UIColor clearColor];
        }];
    }
}

- (void)pptTapGR:(UITapGestureRecognizer *)pptTapGR
{
    //    if (self.pptView.frame.size.height != self.originPPTFrame.size.height || self.pptView.frame.size.width != self.originPPTFrame.size.width) {
    //        return;
    //    }
    self.pptsFunctionView.hidden = !self.pptsFunctionView.hidden;
}

- (void)pptDoubleTapGR:(UITapGestureRecognizer *)pptDoubleTapGR
{
    if (pptDoubleTapGR.state == UIGestureRecognizerStateEnded) {
        CGPoint location = [pptDoubleTapGR locationInView:self.pptView];
        if (!self.pptsFunctionView.hidden && (location.y<50||location.y>CGRectGetHeight(self.pptView.frame)-50)) {
            return;
        }
    }
    if (!self.pptsFunctionView.fullScreenBtn.selected && [UIApplication sharedApplication].statusBarOrientation != UIInterfaceOrientationPortrait) {
        [self manualFullScreen:YES];
    }else if (self.pptsFunctionView.fullScreenBtn.selected == YES && fromLandscape == YES){
        [self manualFullScreen:NO];
    }else{
        self.iPadAutoRotate = NO;
        [self fullScreen];
    }
}

- (void)pinchGR:(UIPinchGestureRecognizer *)pinchGR
{
    if (self.isCameraFullScreen == YES) {
        return;
    }
    CGFloat scale = pinchGR.scale;
    static CGFloat lastScale = 1;
    if (pinchGR.state == UIGestureRecognizerStateBegan) {
        lastScale = 1;
    }
    CGFloat cameraViewX = self.cameraView.frame.origin.x;
    CGFloat cameraViewY = self.cameraView.frame.origin.y;
    CGFloat cameraViewW = self.cameraView.frame.size.width;
    CGFloat cameraViewH = self.cameraView.frame.size.height;
    
    if (scale > 1 && (cameraViewX < 0 || (cameraViewX + cameraViewW) > self.view.bounds.size.width || cameraViewY < 0 || (cameraViewY + cameraViewH) > self.view.bounds.size.height)) {
        return;
    }
    
    self.cameraView.transform = CGAffineTransformScale(self.cameraView.transform, scale/lastScale, scale/lastScale);
    lastScale = scale;
}

- (void)objectDidDragged:(UIPanGestureRecognizer *)sender
{
    if ([UIApplication sharedApplication].statusBarOrientation != UIInterfaceOrientationPortrait && self.pptsFunctionView.fullScreenBtn.selected == NO) {
        return;
    }
    if (sender.state == UIGestureRecognizerStateChanged) {
        //注意，这里取得的参照坐标系是该对象的上层View的坐标。
        CGPoint offset        = [sender translationInView:self.cameraView];
        UIView * draggableObj = self.cameraView;
        CGFloat finalX        = draggableObj.center.x + offset.x;
        CGFloat finalY        = draggableObj.center.y + offset.y;
        CGFloat minX          = self.cameraView.frame.size.width / 2.0;
        CGFloat maxX          = self.view.bounds.size.width - (self.cameraView.frame.size.width / 2.0);
        CGFloat minY          = self.cameraView.frame.size.height / 2;
        CGFloat maxY          = self.view.bounds.size.height - (self.cameraView.frame.size.height / 2.0);
        
        if(finalX < minX){
            finalX = minX;
        }else if(finalX > maxX){
            finalX = maxX;
        }
        if(finalY < minY){
            finalY = minY;
        }else if(finalY > maxY){
            finalY = maxY;
        }
        //通过计算偏移量来设定draggableObj的新坐
        draggableObj.center = CGPointMake(finalX, finalY);
        //初始化sender中的坐标位置。如果不初始化，移动坐标会一直积累起来。
        [sender setTranslation:CGPointMake(0, 0) inView:self.cameraView];
    }
}

- (void)seek:(CGFloat)duration{
    [self.talkfunSDK seek:duration];
    //    [self.pptsFunctionView play:YES];
    self.playDuration = duration;
    [self.pptsFunctionView setDuration:duration];
    //清空当前的所有弹幕
    [self.barrageRender stopAnimation];
}

#pragma mark - scrollView 代理方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSInteger num = round((scrollView.contentOffset.x) / self.scrollView.frame.size.width);
    //        if (point.x > 0) {// 向左滚动
    CGPoint point = [scrollView.panGestureRecognizer translationInView:self.view];
    
    if (self.buttonView.chatBtn.hidden&&self.buttonView.askBtn.hidden&&self.scrollViewWillBegin) {
        self.scrollView.contentOffset = CGPointMake(self.view.frame.size.width*2, 0);
        return;
    }else
    //左
    if (num == 1 &&self.buttonView.chatBtn.hidden == YES&&point.x > 0&&self.scrollViewWillBegin) {
        self.scrollView.contentOffset = CGPointMake(self.view.frame.size.width, 0);
        return;
        
        //右
    }else if (num == 0 &&self.buttonView.askBtn.hidden == YES&&point.x < 0&&self.scrollViewWillBegin) {
        self.scrollView.contentOffset = CGPointMake(self.view.frame.size.width*2, 0);
        return;
        //左
    }else if (num == 2 &&self.buttonView.askBtn.hidden == YES&&point.x > 0&&self.scrollViewWillBegin) {
        self.scrollView.contentOffset = CGPointMake(0, 0);
        return;
    }else if (num == 2 &&self.buttonView.chatBtn.hidden&&self.buttonView.askBtn.hidden) {
        self.scrollView.contentOffset = CGPointMake(self.view.frame.size.width*2, 0);
        return;
    }
    else{
        
    }
    
    self.scrollView.clipsToBounds = YES;
    if (self.scrollView == scrollView) {
        NSInteger num = round((scrollView.contentOffset.x) / self.scrollView.frame.size.width);
        TalkfunNewButtonViewButton * btn = [self.buttonView viewWithTag:500+num];
        [self.buttonView selectButton:btn];
        if (scrollView.contentOffset.x > self.scrollView.frame.size.width * (self.tableViewNum - 1)) {
            self.scrollView.contentOffset = CGPointMake(self.scrollView.frame.size.width * (self.tableViewNum - 1), 0) ;
        }
        if (CGRectGetWidth(self.scrollView.frame)) {
            //            self.buttonView.selectViewLeadingSpace.constant = scrollView.contentOffset.x * (CGRectGetWidth(btn.frame) / CGRectGetWidth(self.scrollView.frame));
        }
    }
}

//网络提示
- (void)networkAlertShow
{
    WeakSelf
    NSString * token = _res[@"data"][@"access_token"];
    [self.view alertStyle:UIAlertControllerStyleAlert title:@"提示" message:@"确定使用蜂窝流量下载?" action:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf.downloadManager appendDownloadWithAccessToken:token?token:weakSelf.access_token playbackID:weakSelf.playbackID title:nil];
        [weakSelf.downloadManager startDownload:weakSelf.playbackID];
        [[DBManager shareManager] insertVideo:self.videoItem];
        PERFORM_IN_MAIN_QUEUE([self.view toast:@"已开始下载，请到我的下载中查看" position:ToastPosition];)
    }]];
}
#pragma mark - 旋转
- (BOOL)shouldAutorotate{
    return NO;
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    if (APPLICATION.statusBarOrientation == UIInterfaceOrientationLandscapeRight) {
        return UIInterfaceOrientationMaskLandscapeRight;
    }
//    if (APPLICATION.statusBarOrientation == UIInterfaceOrientationPortrait) {
//        return UIInterfaceOrientationMaskPortrait;
//    }
    return UIInterfaceOrientationMaskPortrait;
}
- (void)onUIApplicationDidEnterBackgroundNotification:(NSNotification *)notification{
    //    [self.pptsFunctionView play:YES];
    [self uploadProgress]; //上传视频进度到后台
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark - alertView delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    self.alertView_1 =nil;
}

#pragma mark - 懒加载
- (TalkfunDownloadManager *)downloadManager
{
    if (!_downloadManager) {
        _downloadManager = [TalkfunDownloadManager shareManager];
        WeakSelf
        _downloadManager.diskLowReminderValueCallback = ^{
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if( weakSelf.alertView_1 ==nil){
                    weakSelf.alertView_1 = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"磁盘可用空间不足,无法下载!" delegate:weakSelf cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
                    weakSelf.alertView_1.alertViewStyle = UIAlertViewStyleDefault;
                    [weakSelf.alertView_1 show];
                }
            });
            NSLog(@"磁盘空间不足够");
        };
    }
    return _downloadManager;
}
//MARK:ppt
//ppt信息及按钮
- (TalkfunNewFunctionView *)pptsFunctionView{
    if (!_pptsFunctionView) {
        _pptsFunctionView = [TalkfunNewFunctionView initView];
        _pptsFunctionView.frame = CGRectMake(0, 0, CGRectGetWidth(self.pptView.frame), CGRectGetHeight(self.pptView.frame));
        [_pptsFunctionView buttonsAddTarget:self action:@selector(pptsButtonClicked:)];
        [_pptsFunctionView.playBtn addTarget:self action:@selector(playBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        _pptsFunctionView.hidden = YES;
        [_pptsFunctionView playbackMode:YES];
        WeakSelf
        _pptsFunctionView.playbackRateBlock = ^(CGFloat speed){
            
            weakSelf.talkfunSDK.playbackRate= speed;
            
        };
        
        _pptsFunctionView.sliderValueBlock = ^(CGFloat sliderValue){
            [weakSelf seek:sliderValue];
        };
        //过程中
        _pptsFunctionView.sliderValueChangeBlock = ^(CGFloat sliderValue){
            weakSelf.playDuration = sliderValue;
            weakSelf.pptsFunctionView.timeLabel.text = [weakSelf getTimeStr:sliderValue];
        };
        
    }
    return _pptsFunctionView;
}
- (TalkfunKuaiJinView *)kuaiJinView{
    if (!_kuaiJinView) {
        _kuaiJinView = [TalkfunKuaiJinView initView];
        _kuaiJinView.frame = self.pptView.frame;
        [self.pptView addSubview:_kuaiJinView];
    }
    return _kuaiJinView;
}
//- (TalkfunPlaybackMessageView *)messageView
//{
//    if (!_messageView) {
//        _messageView = [[NSBundle mainBundle] loadNibNamed:@"TalkfunPlaybackMessageView" owner:nil options:nil][0];
//        _messageView.frame = CGRectMake(0, 0, self.pptView.frame.size.width, 50);
//        [_messageView.returnBtn addTarget:self action:@selector(pptsButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
//    }
//    return _messageView;
//}
//- (TalkfunFunctionView *)functionView
//{
//    if (!_functionView) {
//        _functionView = [[NSBundle mainBundle] loadNibNamed:@"TalkfunFunctionView" owner:nil options:nil][0];
//        _functionView.frame = CGRectMake(CGRectGetWidth(self.pptView.frame)-60-35-8, CGRectGetMaxY(self.messageView.frame), 35+35+8, CGRectGetHeight(self.pptView.frame)-CGRectGetMaxY(self.messageView.frame)-35);
//        [_functionView buttonsAddTarget:self action:@selector(pptsButtonClicked:)];
//        _functionView.topSpaceToExchangeBtn.constant = self.pptView.frame.size.width<330?-35:8;
//        _functionView.trailingSpaceToContainer.constant = self.pptView.frame.size.width<330?35+8:0;
//    }
//    return _functionView;
//}
//- (TalkfunVideoControlView *)videoControlView
//{
//    if (!_videoControlView) {
//        WeakSelf
//        _videoControlView = [[NSBundle mainBundle] loadNibNamed:@"TalkfunVideoControlView" owner:nil options:nil][0];
//        _videoControlView.frame = CGRectMake(0, CGRectGetHeight(self.pptView.frame)-35, CGRectGetWidth(self.pptView.frame), 35);
//        _videoControlView.sliderValueBlock = ^(CGFloat sliderValue){
//            [weakSelf.talkfunSDK setPlayDuration:sliderValue];
//        };
//        [_videoControlView.playBtn addTarget:self action:@selector(playBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
//    }
//    return _videoControlView;
//}
//MARK:scrollView及其上面的东西
- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initScrollViewWithTarget:self frame:CGRectMake(0, CGRectGetMaxY(self.pptView.frame) + 35, ScreenSize.width, ScreenSize.height - CGRectGetMaxY(self.pptView.frame) - 35)];
        _scrollView.delegate = self;
    }
    return _scrollView;
}
- (UIView *)shadowView
{
    if (!_shadowView) {
        _shadowView = [[UIView alloc] initShadowViewWithFrame:self.scrollView.frame];
    }
    return _shadowView;
}
- (TalkfunButtonView *)buttonView{
    if (!_buttonView) {
        _buttonView = [TalkfunButtonView initView];
        [_buttonView buttonsAddTarget:self action:@selector(btnViewButtonsClicked:)];
        _buttonView.frame = CGRectMake(0, CGRectGetMaxY(self.pptView.frame), ScreenSize.width, ButtonViewHeight);
        [_buttonView isPlayback:YES];
    }
    return _buttonView;
}
- (NSMutableArray *)btnNames
{
    if (!_btnNames) {
        _btnNames = [NSMutableArray arrayWithObjects:@"聊天",@"提问",@"章节",@"专辑", nil];
    }
    return _btnNames;
}

//- (NetworkDetector *)networkDetector
//{
//    if (!_networkDetector) {
//        __weak typeof(self) weakSelf = self;
//        _networkDetector = [[NetworkDetector alloc] init];
//        _networkDetector.networkChangeBlock = ^(NetworkStatus networkStatus){
//
//            if (networkStatus == 0 && ![weakSelf.downloadManager containsPlaybackID:weakSelf.playbackID]) {
//                [weakSelf.view alert:@"提示" message:@"没有网络信号"];
//            }
//        };
//    }
//    return _networkDetector;
//}
- (TalkfunLoadingView *)loadingView{
    if (!_loadingView) {
        _loadingView = [TalkfunLoadingView initView];
        
        _loadingView.frame = self.view.bounds;
    }
    return _loadingView;
}

- (UIActivityIndicatorView *)activityIndicator
{
    if (!_activityIndicator) {
        _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    }
    return _activityIndicator;
}

- (void)updateChrysanthemum
{
    if (self.isExchanged==YES) {
        self.activityIndicator.frame = CGRectMake(0, 0, self.pptView.frame.size.width,  self.pptView.frame.size.height);
        
        [self.pptView addSubview:self.activityIndicator];
        [self.pptView bringSubviewToFront:self.activityIndicator];
        
        
    }else{
        self.activityIndicator.frame = CGRectMake(0, 0, self.cameraView.frame.size.width,  self.cameraView.frame.size.height);;
        
        [self.cameraView addSubview:self.activityIndicator];
        
        [self.cameraView bringSubviewToFront:self.activityIndicator];
    }
}

#pragma mark  视频播放状态改变  -黑屏加菊花时用到

- (void)playerLoadStateDidChange:(TalkfunPlayerLoadState)loadState
{
    [self updateChrysanthemum];
    
    
    if ((loadState & TalkfunPlayerLoadStatePlaythroughOK) != 0) {
        
        NSLog(@"正常播放，移除菊花");
        [self.activityIndicator stopAnimating];
        
    }else if ((loadState & TalkfunPlayerLoadStateStalled) != 0) {
        NSLog(@"发生卡顿，显示菊花");
        [self.activityIndicator startAnimating];
        
    } else {
        NSLog(@"loadStateDidChange: ???: %d\n", (int)loadState);
    }
}

#pragma mark 广告代理

/**
 *  广告播放总时长
 *  是否可跳过广告
 */
- (void)onADPrepare:(TalkfunADConfig*)model
{
    self.advertView.hidden = NO;
    
    [ self.advertView advertisingPlayStart:model playbackID:self.playbackID];
}
/**
 *
 *  广告播放倒计时
 */
- (void)OnADCountDownTime:(NSInteger)duration
{
    [self.advertView setSecond:duration playbackID:self.playbackID];
}

/**
 *
 *  广告播放状态改变
 */
- (void)onADVideoStatusChange:(TalkfunMultiMediaStatusChangeListener)loadState
{   //结束
    if (loadState ==TalkfunMultiMediaStatusChangeListenerComplate) {
        [self.advertView advertisingPlaybackCompleted:self.playbackID];
        [self.talkfunSDK skipAD];
    }else if (loadState ==TalkfunMultiMediaStatusChangeListenerError) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"广告加载失败 " delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        alertView.alertViewStyle = UIAlertViewStyleDefault;
        [alertView show];
    }
}

#pragma mark  添加水印
- (void)addWatermarkLayer{
    
    if([self.nameDict[@"enable"] integerValue ]==1){
        if (self.layer==nil) {
            
            // 设置字体
            UIFont *font =  [UIFont fontWithName:@"Euphemia UCAS" size:11];
            //位置
            NSString *name =    self.nameDict[@"watermarkName"];
            NSDictionary *attrs = @{NSFontAttributeName : font};
            //位置
            CGSize attrsSize=[name sizeWithAttributes:attrs];
            
            
            CGFloat layerX = self.pptView.frame.size.width - attrsSize.width;
            CGFloat layerY = self.pptView.frame.size.height - attrsSize.height;
            
            self.layer =   [TalkfunWatermark  singleLinePathStandard:self.nameDict[@"watermarkName"] withFont:11 withPosition:CGPointMake(arc4random_uniform(layerX),arc4random_uniform(layerY)) textColor:[UIColor whiteColor]];
            
            [self.pptView.layer addSublayer:self.layer];
            
            self.layerTimer = [NSTimer scheduledTimerWithTimeInterval:arc4random_uniform([self getRandomNumber]) target:self selector:@selector(arc4random_uniformFrame) userInfo:nil repeats:YES];
            [[NSRunLoop mainRunLoop] addTimer:self.layerTimer forMode:NSRunLoopCommonModes];
        }
    }
}

- (int)getRandomNumber
{
    int random = 60 +  arc4random_uniform((180 - 60));
    return random;
}

//生成layer层
- (void)arc4random_uniformFrame
{
    [self.layerTimer invalidate];
    _layerTimer = nil;
    
    self.layerTimer = [NSTimer scheduledTimerWithTimeInterval:arc4random_uniform([self getRandomNumber]) target:self selector:@selector(arc4random_uniformFrame) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.layerTimer forMode:NSRunLoopCommonModes];
    
    self.layer.frame =  [self getLayerFrame];
}

//生成位置
- (CGRect)getLayerFrame{
    CGFloat layerX = self.pptView.frame.size.width - self.layer.frame.size.width;
    CGFloat layerY = self.pptView.frame.size.height - self.layer.frame.size.height;
    CGRect rect = CGRectMake(arc4random_uniform(layerX), arc4random_uniform(layerY), self.layer.frame.size.width,self.layer.frame.size.height);
    
    return rect;
}

- (void)timerInvalidate
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.layerTimer invalidate];
        _layerTimer = nil;
        
        [self.layer removeFromSuperlayer];
        self.layer = nil;
        
    });
}

- (TalkfunModulation* )modulation
{
    if (_modulation==nil) {
        _modulation = [TalkfunModulation shared];
    }
    return _modulation;
}

//MARK:弹幕
- (BulletView *)barrageRender{
    if (!_barrageRender) {
        _barrageRender = [[BulletView alloc]init];
        //开启弹幕权限
        _barrageRender.bulletSwitch = NO;
        [self.pptView.layer addSublayer:_barrageRender.layer];
    }
    return _barrageRender;
}

- (void)getBarrageRenderL:(NSInteger)time{
    
    if (self.barrageRender.bulletSwitch) {
        for (NSDictionary *dict in self.playbackChat) {
            
            if ([dict[@"time"] integerValue]==time) {
                //                NSLog(@"弹幕===>%@",dict[@"msg"]);
                
                //弹幕
                [self loadData:dict[@"msg"]];
            }
        }
    }
}
//加载弹幕
- (void)loadData:(NSString *)data
{
    ColorArray
    UIColor *tempColor = TempColor;
    [self.barrageRender initWithContent:data ontOfSize:14 textColor:tempColor];
}

//添加b弹幕聊天数据
- (void)addPlaybackChat:(NSMutableArray*)array
{
    if ([array isKindOfClass:[NSArray class]]) {
        [self.playbackChat addObjectsFromArray:array];
    }
}

- (NSMutableArray*)playbackChat
{
    if (_playbackChat==nil) {
        _playbackChat = [NSMutableArray array];
    }
    return _playbackChat;
}

#pragma mark - scrollView 代理方法

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
    self.scrollViewWillBegin = YES;
}

-(void)scrollViewDidEndDragging:(UIScrollView*)scrollView willDecelerate:(BOOL)decelerate
{
    NSLog(@"滚动视图结束滚动，它只调用一次");
    self.scrollViewWillBegin = NO;
}

- (void)mod_playbackinfo_playback:(id)obj
{
    //聊天与提问的开关
    if([obj[@"roomInfo"][@"mod_playbackinfo_playback"] isKindOfClass:[NSDictionary class]]){
        
        NSDictionary *mod_playbackinfo_playback = obj[@"roomInfo"][@"mod_playbackinfo_playback"];
        
        //聊天
        if([mod_playbackinfo_playback[@"config"][@"chat"]isKindOfClass:[NSDictionary class]]){
            NSDictionary *chat = mod_playbackinfo_playback[@"config"][@"chat"];
            int chatEnable  = [chat[@"enable"] intValue];
            //                chatEnable = 0;
            if(chatEnable ==0){
                self.buttonView.chatBtn.hidden = YES;
            }
        }
        //问答
        if([mod_playbackinfo_playback[@"config"][@"qa"]isKindOfClass:[NSDictionary class]]){
            NSDictionary *qa = mod_playbackinfo_playback[@"config"][@"qa"];
            int qaEnable  = [qa[@"enable"] intValue];
            //                            qaEnable = 0;
            if(qaEnable ==0){
                self.buttonView.askBtn.hidden = YES;
            }
        }
        
        if ( self.buttonView.askBtn.hidden == YES&& self.buttonView.chatBtn.hidden ==NO) {
            self.buttonView.askButtonX.constant =  - self.buttonView.askBtn.frame.size.width;
        }
        
        if (self.buttonView.chatBtn.hidden) {
            if (self.buttonView.askBtn.hidden == YES) {
                self.buttonView.chatButtonX.constant = - self.buttonView.chatBtn.frame.size.width *2;
                self.scrollView.contentOffset = CGPointMake(self.view.frame.size.width, 0);
                
            }else{
                self.buttonView.chatButtonX.constant = - self.buttonView.chatBtn.frame.size.width;
                self.scrollView.contentOffset = CGPointMake(self.view.frame.size.width*2, 0);
            }
        }
        
        [self.buttonView selectButton:self.buttonView.noticeBtn];
    }
}

//广告返回
- (void)backClick:(UIButton*)btn
{
    [TalkfunCourseManagement setPlay:[self.playbackID  integerValue] progress:self.playDuration];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [self.view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    if (self.isOrientationLandscape) {
        [UIApplication sharedApplication].statusBarOrientation = UIInterfaceOrientationPortrait;
    }
    [self.talkfunSDK destroy];
    [self timerInvalidate];
    QUITCONTROLLER(self)
}

//跳过广告
- (void)promptClick:(UIButton*)btn
{
    [self.talkfunSDK skipAD];
    self.advertView.hidden = YES;
}

//横屏
- (void)fullScreenClick:(UIButton*)btn
{
    if (btn.selected==NO) {
#pragma mark - ---超职修改
        NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeRight];
        [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
#pragma mark - 超职修改---
        self.pptsFunctionView.fullScreenBtn.selected = YES;
        [self orientationLandscape];
    }else{
#pragma mark - ---超职修改
        NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
        [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
#pragma mark - 超职修改---
        self.pptsFunctionView.fullScreenBtn.selected = NO;
        [self orientationPortrait];
    }
    self.advertView.frame = CGRectMake(0, 0, ScreenSize.width, ScreenSize.height );
    btn.selected = !btn.selected;
}

@end

