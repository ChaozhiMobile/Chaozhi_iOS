//
//  TalkfunViewController.m
//  TalkfunSDKDemo
//
//  Created by 孙兆能 on 2016/11/18.
//  Copyright © 2016年 talk-fun. All rights reserved.
//

#import "TalkfunViewController.h"
//#import "TalkfunSDK.h"
#import "TalkfunSDKLive.h"
#import "UIButton+TalkfunButton.h"
#import "UILabel+TalkfunLabel.h"
#import "UIScrollView+TalkfunScrollView.h"
#import "UIView+TalkfunView.h"
#import "RootTableViewController.h"
#import "UITextField+TalkfunTextField.h"
#import "UIImageView+TalkfunImageView.h"
#import "NetworkSelectionViewController.h"
#import "VoteViewController.h"
#import "VoteEndViewController.h"
#import "LotteryViewController.h"
#import "MyLotteryViewController.h"
#import "TalkfunMessageView.h"
#import "TalkfunFunctionView.h"
#import "TalkfunHornView.h"
#import "TalkfunNetworkStatusView.h"
#import "BulletView.h"
//#import "BarrageWalkImageTextSprite.h"
#import "TalkfunTextfieldView.h"
#import "TalkfunNewFunctionView.h"
#import "TalkfunButtonView.h"
#import "TalkfunNewTextfieldView.h"
#import "TalkfunExpressionViewController.h"
#import "TalkfunLongTextfieldView.h"
#import "TalkfunReplyTipsView.h"
#import "TalkfunGuidanceView.h"
#import "GroupTableViewController.h"
#import "HYAlertView.h"
#import "TalkfunLoadingView.h"
#import "UIImageView+WebCache.h"

#import "TalkfunNetworkLines.h"
#import "TalkfunSignViewController.h"
#import "TalkfunDownloadManager.h"
#import "TalkfunMoveLabel.h"
#import "TalkfunScoreView.h"
#import "TalkfunWatermark.h"
#import "TalkfunModulation.h"
#import "TalkfunMultifunctionTool.h"
#import "CZCommentView.h"

#define TrailingValue 40
#define NetworkStatusViewWidth 147
#define ButtonViewHeight 35
#define UpSpace 40
#define success @"0"

#define returnButton 200
#define hiddenCameraButton 201
#define statusSwitchingButton 202
#define refreshButton 203

#define smoothButton 208


#define networkSelectionButton 204
#define barrageButton 205
#define fullScreenButton 206
#define KIsiPhoneX  @available(iOS 11.0, *) && UIApplication.sharedApplication.keyWindow.safeAreaInsets.bottom > 0.0
#define viewSize self.view.frame.size
@interface TalkfunViewController ()<UIScrollViewDelegate,UITextFieldDelegate,UIAlertViewDelegate,TalkfunSDKLiveDelegate>
{
    NSInteger count;
}
/** 评价视图 */
@property (nonatomic,retain) CZCommentView *commentView;
/** 是否评价 YES已评价 */
@property (nonatomic,assign) BOOL is_review;
/** 直播时长 */
@property (nonatomic,assign) NSInteger liveTime;

//SDK
@property (nonatomic,strong) TalkfunSDKLive * talkfunSDK;
@property (nonatomic,strong) UIView * pptView;
@property (nonatomic,strong) UIView * cameraView;

//默认占位图
@property(nonatomic,strong)UIImageView *bitmapView;
//桌面分享(可选、默认pptView为desktopShareView)
@property (nonatomic,strong) UIView * desktopShareView;

//滚动通知的东西
@property (nonatomic,copy) NSString * link;

//ppt信息及按钮
@property (nonatomic,strong) TalkfunNewFunctionView * pptsFunctionView;
@property (nonatomic,strong) TalkfunHornView * hornView;

//btnView
@property (nonatomic,strong) TalkfunButtonView * buttonView;

//scrollView及其上面的东西
@property (nonatomic,strong) TalkfunNewTextfieldView * chatTFView;
@property (nonatomic,strong) TalkfunTextfieldView * askTFView;
//横屏时候发送聊天的TF
@property (nonatomic,strong) TalkfunLongTextfieldView * longTextfieldView;
@property (nonatomic,strong) TalkfunNewTextfieldView * longCoverTFView;
@property (nonatomic,strong) UIScrollView * scrollView;
@property (nonatomic,strong) UIView * shadowView;
@property (nonatomic,strong) TalkfunExpressionViewController * expressionViewVC;
//投票
@property (nonatomic,strong) VoteViewController     * voteVC;
@property (nonatomic,strong) VoteEndViewController   * voteEndVC;
@property (nonatomic,strong) LotteryViewController   * lotteryVC;
@property (nonatomic,strong) MyLotteryViewController * myLotteryVC;
//记住投票信息的字典
@property (nonatomic,strong) NSMutableDictionary * voteNewDict;
@property (nonatomic,strong) NSMutableDictionary * votePubDict;
//记住已经投了票的vid
@property (nonatomic,strong) NSMutableArray      * voteFinishArray;

//老师回复提示
@property (nonatomic,strong) TalkfunReplyTipsView * replyTipsView;
//网络较差提示
@property (nonatomic,strong) UIImageView * networkTipsImageView;

//私聊
@property (nonatomic,strong) UIButton                 * groupBtn;
@property (nonatomic,strong) GroupTableViewController * groupTableVC;
@property (nonatomic,strong) UINavigationController   * nav;
@property (nonatomic,strong) NSMutableDictionary      * chatGroupsDict;

//送花
@property (nonatomic,strong) UILabel * flowerTipsLabel;

//弹幕
@property (nonatomic,strong) BulletView * barrageRender;
@property (nonatomic,strong) NSDate * startTime;//开始时间

//被强迫下线
@property (nonatomic,strong) UIAlertView * forceoutAlertView;
//被提出房间
@property (nonatomic,strong) UIAlertView * kickoutAlertView;
//视频切换、暂停提示
@property (nonatomic,strong) UILabel * tipsLabel;
//网络状态
@property (nonatomic,assign) TalkfunNetworkStatus networkStatus;
//网络选择懒加载
@property (nonatomic,strong) NetworkSelectionViewController * networkSelectionVC;
//其它
//横竖屏
@property (nonatomic,assign) BOOL isOrientationLandscape;
//是否已经开始直播
@property (nonatomic,assign) BOOL unStart;
//退出确认alertController
@property (nonatomic,strong) UIAlertView * quitAlertView;

//方向
//@property (nonatomic,assign) NSInteger orientation;
//tableView的数量
@property (nonatomic,assign) NSInteger tableViewNum;
//覆盖的View（遮布）
@property (nonatomic,strong) UIView * coverView;
//网络状态偏出的位置
@property (nonatomic,assign) CGFloat extraValue;
//记住自己信息的字典
@property (nonatomic,strong) NSDictionary * me;
//是否第一次进来
@property (nonatomic,assign) BOOL isFirst;
//记录摄像头是否全屏
@property (nonatomic,assign) BOOL isCameraFullScreen;
//计时的time
@property (nonatomic,assign) NSInteger time;
//是否是iPad且自动旋转
@property (nonatomic,assign) BOOL iPadAutoRotate;

//输入时的透明背景黑色
@property (nonatomic,strong) UIView * inputBackgroundView;
//消失网络差的提示timer
@property (nonatomic,strong) NSTimer * dismissTimer;
//是否请求过问答数据
@property (nonatomic,assign) BOOL alreadyRequested;

//是否是桌面分享
@property (nonatomic,assign)BOOL isDesktop;

//所有人禁言
@property (nonatomic,assign)BOOL disableAll;
@property (nonatomic,strong) TalkfunLoadingView * loadingView;
@property (nonatomic,strong)HYAlertView *alertView ;

//老师直播端的摄像头状态
@property(nonatomic,assign)BOOL cameraShow;

//直播已结束
@property(nonatomic,assign)BOOL liveStop;

@property(nonatomic,assign)BOOL isFullScreen;//是否全屏
//视频窗口上的菊花
@property (nonatomic,strong) UIActivityIndicatorView * activityIndicator;
//签名
@property (nonatomic,strong)TalkfunSignViewController * sign;

@property (nonatomic,strong )TalkfunMoveLabel *onlineLabel;

//访客 显示 还是隐藏
@property(nonatomic,assign)BOOL enable;


@property (strong, nonatomic) NSMutableArray  *videoSessions;//小班的视频view数组

@property (strong, nonatomic)TalkfunScoreView*ScoreView;
@property (assign, nonatomic)BOOL isScore;//记录有没有开启评分
@property (strong, nonatomic)CATextLayer *layer;//水印
//消失网络差的提示timer
@property (nonatomic,strong) NSTimer * layerTimer;
@property (nonatomic,strong)NSDictionary *nameDict;
@property (nonatomic,strong)TalkfunModulation* modulation ;//系统音量调节
@property (nonatomic, assign) float lastVolume; // 上一次调节音量时的音量大小
@property (nonatomic,assign) int  origin;//原点
@end

@implementation TalkfunViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    count = 0;
    self.isPanForbid = YES; //禁用侧滑返回
    
    //防止横屏进来
    CGFloat width =  (viewSize.width>viewSize.height)?viewSize.height:viewSize.width;
    CGFloat height = (viewSize.width>viewSize.height)?viewSize.width:viewSize.height;
    self.view.frame = CGRectMake(0, 0, width, height);
    
    //设置背景颜色
    self.view.backgroundColor = DARKBLUECOLOR;
    //隐藏状态栏
    [APPLICATION setStatusBarHidden:YES];
    self.unStart = YES;
    self.isFirst = YES;
    
    self.isCameraFullScreen = NO;
    self.isOrientationLandscape = NO;
    self.isDesktop = NO;
    self.iPadAutoRotate = YES;
    self.alreadyRequested = NO;
    //开始
    [self getAccessToken];
    
    [self createUI];
    
    [self addGesture];
    
    [self registerEventListener];
    
    //=================== 监听键盘 ====================
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardDidShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardDidHide:) name:UIKeyboardWillHideNotification object:nil];
    //=================== 监听输入框的字符长度 ====================
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(infoAction:)name:UITextFieldTextDidChangeNotification object:nil];
    //    if (IsIPAD) {
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
    //    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sdkError:) name:TalkfunErrorNotification object:nil];
    //    self.orientation = 3;
    
    self.onlineLabel.userInteractionEnabled = YES;
    [self.view bringSubviewToFront:self.onlineLabel];
    
    if ([AppChannel isEqualToString:@"1"]
        && [self.videoItem.type isEqualToString:@"2"]) { //超职、直播/回放
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
                [weakSelf quit];
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

- (NSString*)dictionaryToJson:(NSDictionary *)dic

{
    if ([dic isKindOfClass:[NSDictionary class]]) {
        NSError *parseError = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
        
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }else{
        return @"";
    }
    
}

- (void)sdkError:(NSNotification *)notification{
    NSDictionary * userInfo = notification.userInfo;
    
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message: [self dictionaryToJson:userInfo] delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
    alertView.alertViewStyle = UIAlertViewStyleDefault;
    [alertView show];
    //    }
}

#pragma mark - 实例化talkfunSDK
- (void)getAccessToken
{
    NSString * token = nil;
    if (_res) {
        token = _res[@"data"][@"access_token"];
    }
    else
    {
        token = _token;
    }
    if (token && ![token isEqualToString:@""]) {
        [self configViewWithAccessToken:token];
    }
    else
    {
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
    
    //1.实例化SDK（如果用的是accessKey则在access_token参数中传入）
    self.talkfunSDK = [[TalkfunSDKLive alloc] initWithAccessToken:access_token parameters:parameters];
    
    //设置代理对象
    self.talkfunSDK.delegate = self;
    //  是否开启自动的线路选择
    //    self.talkfunSDK.autoSelectNetwork = NO;
    
    //    NSString * accessKey = @"";
    //通过accessKey实例化SDK
    //    self.talkfunSDK = [[TalkfunSDKLive alloc] initWithAccessKey:accessKey parameters:parameters];
    
    //进入后台是否暂停（默认是暂停）
    [self.talkfunSDK setPauseInBackground:YES];
    
    //ppt容器（4：3比例自适应）
    self.pptView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewSize.width, self.view.frame.size.width * 3 / 4.0)];
    self.pptView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.pptView];
    
    self.bitmapView = [[UIImageView alloc]init];
    self.bitmapView.frame = CGRectMake(0, 0, self.pptView.frame.size.width, self.pptView.frame.size.height);
    self.bitmapView.image =  [UIImage imageNamed:@"直播未开始"];
    //    直播未开始   直播已结束
    [self.pptView addSubview:self.bitmapView];
    
    [self.pptView addSubview:self.pptsFunctionView];
    //2.把ppt容器给SDK（要显示ppt区域的必须部分）
    [self.talkfunSDK configurePPTContainerView:self.pptView];
    
    //cameraView容器
    self.cameraView = ({
        UIView * view = [[UIView alloc] initWithFrame:CGRectMake(viewSize.width - 150, CGRectGetMaxY(self.pptView.frame) + ButtonViewHeight, 150, 150 * 3 / 4.0)];
        if (IsIPAD) {
            view.frame = CGRectMake(viewSize.width * 0.7, CGRectGetMaxY(self.pptView.frame) + ButtonViewHeight, viewSize.width * 0.3, viewSize.width * 0.3 * 3 / 4.0);
        }
        view.backgroundColor = [UIColor blackColor];
        //首先把容器隐藏
        view.hidden = YES;
        view;
    });
    
    //3.把ppt容器给SDK（要显示摄像头区域的必须部分）
    [self.talkfunSDK configureCameraContainerView:self.cameraView];
}

- (void)createUI{
    
    self.pptsFunctionView.hidden = NO;
    [self createScrollView];
    //加btnView
    [self.view addSubview:self.buttonView];
    [self.view addSubview:self.cameraView];
    _startTime = [NSDate date];
    
    [self.pptsFunctionView insertSubview:self.inputBackgroundView atIndex:0];
    
    self.expressionViewVC.view.frame = CGRectMake(0, viewSize.height, viewSize.width,ExpressionViewHeight());
    
    [self.view addSubview:self.expressionViewVC.view];
    [self addGuidance];
    [self.view bringSubviewToFront:self.chatTFView];
    [self.view bringSubviewToFront:self.askTFView];
}

- (void)addLoadingView{
    [self.view addSubview:self.loadingView];
    [self.loadingView configLogo:self.res[@"data"][@"logo"] courseName:self.res[@"data"][@"title"]];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.loadingView removeFromSuperview];
        self.loadingView = nil;
    });
}

- (void)addGuidance{
    TalkfunGuidanceView * gv = [[TalkfunGuidanceView alloc] initView];
    gv.frame = self.view.frame;
    [self.view addSubview:gv];
}


- (void)addNetworkTipsView{
    if (_networkTipsImageView) {
        return;
    }
    [self.dismissTimer invalidate];
    [self.view addSubview:self.networkTipsImageView];
    self.dismissTimer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(networkTipsTap:) userInfo:nil repeats:NO];
    [[NSRunLoop mainRunLoop] addTimer:self.dismissTimer forMode:NSRunLoopCommonModes];
}
- (void)addReplyTipsView{
    if (_replyTipsView) {
        return;
    }
    [self.view addSubview:self.replyTipsView];
}

#pragma mark - 创建scrollView
- (void)createScrollView{
    [self.view addSubview:self.shadowView];
    [self.view addSubview:self.scrollView];
    
    /*=================加tableView===================*/
    NSArray * tableVCName = @[@"ChatTableViewController",
                              @"QuestionTableViewController",
                              @"NoticeTableViewController"];
    
    self.tableViewNum = tableVCName.count;
    for (int i = 0; i < self.tableViewNum; i ++) {
        
        Class className = NSClassFromString(tableVCName[i]);
        
        RootTableViewController * tableViewVC = [[className alloc] init];
        tableViewVC.view.frame = CGRectMake(i * self.scrollView.frame.size.width, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height - 50);
        
        WeakSelf
        //聊天页面
        if (i == 0) {
            tableViewVC.btnBlock = ^(BOOL voted,NSString *vid){
                //点击 查看结果 按钮
                if (voted) {
                    [weakSelf.talkfunSDK emit:TALKFUN_EVENT_VOTE_INFO parameter:@{@"vid":vid} callback:^(id obj) {
                        if ([obj[@"code"]intValue]==0) {
                            PERFORM_IN_MAIN_QUEUE(weakSelf.voteVC.view.alpha = 1.0;
                                                  [weakSelf.voteVC removeFromSuperview];
                                                  
                                                  [weakSelf.voteVC refreshUIWithResult:obj];
                                                  [weakSelf.view addSubview:weakSelf.voteVC.view];)
                        }
                    }];
                    return ;
                }
                
                if (weakSelf.votePubDict[vid]) {
                    weakSelf.voteEndVC.voteTitle.text = @"投票已结束";
                    weakSelf.voteEndVC.message = @"投票已结束";
                    weakSelf.voteEndVC.view.alpha = 1.0;
                    [weakSelf.view addSubview:weakSelf.voteEndVC.view];
                    [weakSelf.voteEndVC refreshUIWithAfterCommitted];
                    return;
                }
                else if ([weakSelf.voteFinishArray containsObject:vid])
                {
                    weakSelf.voteEndVC.view.alpha = 1.0;
                    [weakSelf.view addSubview:weakSelf.voteEndVC.view];
                    [weakSelf.voteEndVC refreshUIWithAfterCommitted];
                }else if (!voted){
                    if (weakSelf.votePubDict[vid]) {
                        weakSelf.voteVC.view.alpha = 1.0;
                        [weakSelf.voteVC removeFromSuperview];
                        [weakSelf.view addSubview:weakSelf.voteVC.view];
                        id obj = weakSelf.votePubDict[vid];
                        
                        [weakSelf.voteVC refreshUIWithResult:obj];
                    }else{
                        //
                        //                        [weakSelf.view addSubview:weakSelf.voteVC.view];
                        ;
                        id obj = weakSelf.voteNewDict[vid];
                        [weakSelf.voteVC removeFromSuperview];
                        [weakSelf.voteVC refreshUIWithParams:obj];
                        
                        weakSelf.voteVC.view.alpha = 1.0;
                        [weakSelf.view addSubview:weakSelf.voteVC.view];
                    }
                }
            };
        }
        //公告
        if (i == 2) {
            tableViewVC.view.frame = CGRectMake(i * self.scrollView.frame.size.width, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height);
        }
        
        tableViewVC.view.tag = 300 + i;
        tableViewVC.view.backgroundColor = DARKBLUECOLOR;
        [self.scrollView addSubview:tableViewVC.view];
        [self addChildViewController:tableViewVC];
    }
    self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.scrollView.frame) * self.tableViewNum, CGRectGetHeight(self.scrollView.frame));
    /*=================添加textfield===================*/
    [self.view addSubview:self.chatTFView];
    [self.view addSubview:self.askTFView];
    self.askTFView.hidden = YES;
}

#pragma mark - 监听事件
- (void)registerEventListener
{
    WeakSelf
    //MARK:初始化(room:init)
    [self.talkfunSDK on:TALKFUN_EVENT_ROOM_INIT callback:^(id obj) {
        [weakSelf roomInit:obj];
    }];
    
    
    //网速
    [self.talkfunSDK on:TALKFUN_EVENT_NETWORK_SPEED callback:^(id obj) {
        [weakSelf networkSpeed:obj];
    }];
    
    //TODO:桌面分享
    [self.talkfunSDK on:TALKFUN_EVENT_DESKTOP_START callback:^(id obj) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.isDesktop = YES;
            [weakSelf.cameraView removeFromSuperview];
        });
        
    }];
    
    [self.talkfunSDK on:TALKFUN_EVENT_DESKTOP_STOP callback:^(id obj) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.isDesktop = NO;
            [weakSelf.view addSubview:weakSelf.cameraView];
        });
        
    }];
    
    [self.talkfunSDK on:TALKFUN_EVENT_DESKTOP_PAUSE callback:^(id obj) {
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.tipsLabel.text = @"暂停中......";
            [weakSelf.pptView addSubview:weakSelf.tipsLabel];
        });
        
    }];
    
    
    [self.talkfunSDK on:TALKFUN_EVENT_CAMERA_SHOW callback:^(id obj) {
        
        weakSelf.cameraShow = YES;
        weakSelf.cameraView.hidden = NO;
        if (IsIPAD&&self.isOrientationLandscape&&weakSelf.pptsFunctionView.fullScreenBtn.selected==NO) {
            [weakSelf reloadScrollView:NO];
        }
        
        if (KIsiPhoneX) {
            [weakSelf.pptsFunctionView.CameraBtn1 setImage:[UIImage imageNamed:@"开启摄像头"] forState:UIControlStateNormal];
        }else{
            [weakSelf.pptsFunctionView.cameraBtn setImage:[UIImage imageNamed:@"开启摄像头"] forState:UIControlStateNormal];
        }
        
    }];
    
    [self.talkfunSDK on:TALKFUN_EVENT_CAMERA_HIDE callback:^(id obj) {
        
        weakSelf.cameraShow = NO;
        weakSelf.cameraView.hidden = YES;
        if (IsIPAD&&self.isOrientationLandscape&&weakSelf.pptsFunctionView.fullScreenBtn.selected==NO) {
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
        [weakSelf liveModeChange:obj];
    }];
    
    //当时视频播放的时候的回调
    [self.talkfunSDK on:TALKFUN_EVENT_PLAY callback:^(id obj) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.tipsLabel.hidden = YES;
            
            weakSelf.tipsLabel.alpha = 0;
            [weakSelf.tipsLabel removeFromSuperview];
            weakSelf.tipsLabel = nil;
            
        });
    }];
    
    //TODO:直播时长
    [self.talkfunSDK on:TALKFUN_EVENT_LIVE_DURATION callback:^(id obj) {
        
        self.liveTime = [obj[@"hour"] integerValue]*60*60 + [obj[@"minute"] integerValue]*60 + [obj[@"second"] integerValue];
        
//        NSString *duration = [TalkfunMultifunctionTool getLiveDuration:obj];
//        NSLog(@"源数据%@ 直播时长========%@",obj,duration);
    }];
    
    //投票
    //投票开始
    [self.talkfunSDK on:TALKFUN_EVENT_VOTE_NEW callback:^(id obj) {
        [weakSelf voteNew:obj];
    }];
    //投票结束
    [self.talkfunSDK on:TALKFUN_EVENT_VOTE_PUB callback:^(id obj) {
        [weakSelf votePub:obj];
    }];
    //开始抽奖
    [self.talkfunSDK on:TALKFUN_EVENT_LOTTERY_START callback:^(id obj) {
        [weakSelf lotteryStart:obj];
    }];
    //结束抽奖
    [self.talkfunSDK on:TALKFUN_EVENT_LOTTERY_STOP callback:^(id obj) {
        [weakSelf lotteryStop:obj];
    }];
    
    //广播
    [self.talkfunSDK on:TALKFUN_EVENT_BROADCAST callback:^(id obj) {
        [weakSelf broadcast:obj];
    }];
    
    //禁言
    [self.talkfunSDK on:TALKFUN_EVENT_CHAT_DISABLE callback:^(id obj) {
        [weakSelf chatDisable:obj];
    }];
    
    //全体禁言
    [self.talkfunSDK on:TALKFUN_EVENT_CHAT_DISABLE_ALL callback:^(id obj) {
        [weakSelf chatDisableAll:obj];
    }];
    
    //发送聊天
    [self.talkfunSDK on:TALKFUN_EVENT_CHAT_SEND callback:^(id obj) {
        NSLog(@"聊天===>%@",obj);
        if ([obj[@"chat"] isKindOfClass:[NSDictionary class]]) {
            if (obj[@"chat"][@"enable"] ) {
                //已经禁言
                if ([obj[@"chat"][@"enable"] integerValue ]==0) {
                    //聊天开启
                }else if ([obj[@"chat"][@"enable"] integerValue ]==1) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"chat" object:nil userInfo:@{@"mess":obj}];
                    NSString *text =  obj[@"msg"];
                    //加载数据
                    [weakSelf loadData:text];
                }
            }
        }else{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"chat" object:nil userInfo:@{@"mess":obj}];
            NSString *text =  obj[@"msg"];
            //加载数据
            [weakSelf loadData:text];
        }
    }];
    
    //老师删除信息
    [self.talkfunSDK on:TALKFUN_EVENT_QUESTION_DELETE callback:^(id obj) {
        NSString * qid = [NSString stringWithFormat:@"%@",obj[@"qid"]];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"deleteQuestion" object:nil userInfo:@{@"qid":qid}];
    }];
    
    //TODO:送花
    [self.talkfunSDK on:TALKFUN_EVENT_FLOWER_SEND callback:^(id obj) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"flower" object:nil userInfo:@{@"mess":obj}];
    }];
    [self.talkfunSDK on:TALKFUN_EVENT_FLOWER_INIT callback:^(id obj) {
        [weakSelf flowerGetInit:obj];
    }];
    [self.talkfunSDK on:TALKFUN_EVENT_FLOWER_TOTAL callback:^(id obj) {
        [weakSelf flowerTotal:obj];
    }];
    [self.talkfunSDK on:TALKFUN_EVENT_FLOWER_TIME_LEFT callback:^(id obj) {
        //[weakSelf flowerTimeLeft:obj];
    }];
    
    //提问
    [self.talkfunSDK on:TALKFUN_EVENT_QUESTION_ASK callback:^(id obj) {
        [weakSelf questionAsk:obj];
    }];
    
    //审核通过
    [self.talkfunSDK on:TALKFUN_EVENT_QUESTION_AUDIT callback:^(id obj) {
        //        NSLog(@"通过%@",obj);
        
        [weakSelf questionAsk:obj];
    }];
    
    //问题回答
    [self.talkfunSDK on:TALKFUN_EVENT_QUESTION_REPLY callback:^(id obj) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"reply" object:nil userInfo:@{@"mess":obj}];
        if (weakSelf.scrollView.contentOffset.x!= viewSize.width&&[obj[@"question"][@"xid"] integerValue]==[weakSelf.me[@"xid"] integerValue] && weakSelf.pptsFunctionView.fullScreenBtn.selected == NO) {
            PERFORM_IN_MAIN_QUEUE([weakSelf addReplyTipsView];)
        }
    }];
    
    //有人加入直播间
    [self.talkfunSDK on:TALKFUN_EVENT_MEMBER_JOIN_OTHER callback:^(id obj) {
        [weakSelf memberTotal:obj];
    }];
    
    //有人退出房间
    [self.talkfunSDK on:TALKFUN_EVENT_MEMBER_LEAVE callback:^(id obj) {
        [weakSelf memberTotal:obj];
    }];
    
    //公告
    [self.talkfunSDK on:TALKFUN_EVENT_ANNOUNCE_NOTICE callback:^(id obj) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"notice" object:nil userInfo:@{@"mess":obj}];
    }];
    
    //我加入房间
    [self.talkfunSDK on:TALKFUN_EVENT_MEMBER_JOIN_ME callback:^(id obj) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf memberTotal:obj];
        });
    }];
    
    [self.talkfunSDK on:TALKFUN_EVENT_LIVE_WAIT callback:^(id obj) {
        
    }];
    
    //直播开始
    [self.talkfunSDK on:TALKFUN_EVENT_LIVE_START callback:^(id obj) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.bitmapView.hidden = YES;
            [weakSelf addWatermarkLayer];
        });
        
        [weakSelf liveStart:obj];
    }];
    
    //直播结束
    [self.talkfunSDK on:TALKFUN_EVENT_LIVE_STOP callback:^(id obj) {
        if(   weakSelf.talkfunSDK.evaluate&&weakSelf.bitmapView.hidden){
            //1.启动了评分
            weakSelf.isScore = YES;
            //2.添加了评分
            [weakSelf.view addSubview:weakSelf.ScoreView ];
            
            [weakSelf timerInvalidate];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.liveStop = YES;
            if(weakSelf.pptView.frame.size.height/weakSelf.pptView.frame.size.width!=0.75){
                weakSelf.bitmapView.image = [UIImage imageNamed:@"直播已结束16_9"];
            }else{
                
                weakSelf.bitmapView.image = [UIImage imageNamed:@"直播已结束"];
            }
            
            weakSelf.bitmapView.hidden = NO;
        });
        
        
        [weakSelf liveStop:obj];
        
        weakSelf.cameraView.hidden = YES;
    }];
    
    //被管理员踢出房间
    [self.talkfunSDK on:TALKFUN_EVENT_MEMBER_KICK callback:^(id obj) {
        [weakSelf memberKick:obj];
    }];
    
    //被强迫下线
    [self.talkfunSDK on:TALKFUN_EVENT_MEMBER_FORCEOUT callback:^(id obj) {
        [weakSelf memberForceout:obj];
    }];
    
    //滚动通知
    [self.talkfunSDK on:TALKFUN_EVENT_ANNOUNCE_ROLL callback:^(id obj) {
        [weakSelf.hornView announceRoll:obj];
    }];
    
    //总人数
    [self.talkfunSDK on:TALKFUN_EVENT_MEMBER_TOTAL callback:^(id obj) {
        [weakSelf memberTotal:obj];
    }];
    
    //接收老师发起的点名
    [self.talkfunSDK on:TALKFUN_SIGN_NEW callback:^(id obj) {
        
        [APPLICATION sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
        NSString * nickname  = obj[@"data"][@"nickname"];
        NSString * startTime = obj[@"data"][@"time"];
        
        NSString * message   = [NSString stringWithFormat:@"管理员 %@ 在%@开始点名",nickname,startTime];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"broadcastInfo" object:nil userInfo:@{@"vote:new":message,@"nickname":nickname,@"vid":@""}];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [weakSelf.sign refreshUIWithParams:obj] ;
            
            [weakSelf.view addSubview:weakSelf.sign.view];
            
        });
    }];
    
    //结束点名
    [self.talkfunSDK on:TALKFUN_SIGN_END callback:^(id obj) {
        
        NSLog(@"点击结束");
        
        [weakSelf.sign deleteClicked];
    }];

    //默认清晰度选择
    [self.talkfunSDK on:TALKFUN_EVENT_CURRENT_VIDEO_DEFINITION_LIST callback:^(id obj) {
        [weakSelf.pptsFunctionView setDefaultStream:obj];
    }];
    
    //================= 未读消息红点 ====================
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chatMessageCome) name:@"chatMessageCome" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(askMessageCome) name:@"askMessageCome" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noticeMessageCome) name:@"noticeMessageCome" object:nil];
    
    //    [self XiaoBan];
}

- (UIActivityIndicatorView *)activityIndicator
{
    if (!_activityIndicator) {
        _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        _activityIndicator.userInteractionEnabled = NO;
    }
    return _activityIndicator;
}

- (void)updateChrysanthemum
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (self.talkfunSDK.isExchanged==YES) {
            self.activityIndicator.frame = CGRectMake(0, 0, self.pptView.frame.size.width,  self.pptView.frame.size.height);
            self.activityIndicator.center = CGPointMake(self.pptView.frame.size.width * 0.5, self.pptView.frame.size.height * 0.5);
            
            [self.pptView addSubview:self.activityIndicator];
            [self.pptView bringSubviewToFront:self.activityIndicator];
            
            
        }else{
            self.activityIndicator.frame = CGRectMake(0, 0, self.cameraView.frame.size.width,  self.cameraView.frame.size.height);;
            self.activityIndicator.center = CGPointMake(self.cameraView.frame.size.width * 0.5, self.cameraView.frame.size.height * 0.5);
            [self.cameraView addSubview:self.activityIndicator];
            
            [self.cameraView bringSubviewToFront:self.activityIndicator];
        }
    });
    
    
}

#pragma mark  视频播放状态改变  -黑屏加菊花时用到

- (void)playerLoadStateDidChange:(TalkfunPlayerLoadState)loadState
{
    
    [self updateChrysanthemum];
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if ((loadState & TalkfunPlayerLoadStatePlaythroughOK) != 0) {
            
            NSLog(@"正常播放，移除菊花");
            [self.activityIndicator stopAnimating];
            
        }else if ((loadState & TalkfunPlayerLoadStateStalled) != 0) {
            //背景色设置为黑色,好显示菊花
            if (self.talkfunSDK.isExchanged==YES) {
                self.pptView.backgroundColor =[UIColor  blackColor];
            }
            
            NSLog(@"发生卡顿，显示菊花");
            [self.activityIndicator startAnimating];
            
            
            
            
        } else {
            NSLog(@"loadStateDidChange: ???: %d\n", (int)loadState);
        }
    });
    
    
}
static dispatch_once_t onceToken;
- (void)btnViewButtonsClicked:(UIButton *)button{
    [self.buttonView selectButton:(TalkfunNewButtonViewButton *)button];
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.frame.size.width * (button.tag - 500), 0) animated:NO];
    if (button.tag == 501) {
        
        
        
        //聊天栏隐藏
        self.chatTFView.hidden = YES;
        //提问打开
        self.askTFView.hidden = NO;
        
        if ( self.isOrientationLandscape) {
            self.onlineLabel.hidden = YES;
        }
        //
        
        WeakSelf
        dispatch_once(&onceToken, ^{
            [self.talkfunSDK getQuestionList:^(id result) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if(weakSelf.me){
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"questionList" object:nil userInfo:@{@"mess":result,@"xid":weakSelf.me}];
                    }
                    
                });
            }];
        });
        [self removeReplyTipsView];
    }else if (button.tag == 502) {
        
        //聊天栏隐藏
        self.chatTFView.hidden = YES;
        //提问隐藏
        self.askTFView.hidden = YES;
        
        [self.view endEditing:YES];
        if ( self.isOrientationLandscape) {
            self.onlineLabel.hidden = YES;
        }
        
    }else if (button.tag == 500) {
        
        
        
        //聊天栏显示
        self.chatTFView.hidden = NO;
        //提问隐藏
        self.askTFView.hidden = YES;
        
        if (self.enable) {
            self.onlineLabel.hidden = NO;
        }else{
            self.onlineLabel.hidden = YES;
        }
        
    }
    
    
}

- (void)chatButtonClicked:(UIButton *)chatButton
{
    if (self.unStart) {
        [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
        [self.view toast:@"还没开始上课" position:ToastPosition];
        return;
    }
    [self.view endEditing:YES];
    NSMutableDictionary * parameter = [NSMutableDictionary new];
    if (chatButton == self.chatTFView.flowerButton || chatButton == _longCoverTFView.flowerButton) {
        WeakSelf
        [self.talkfunSDK emit:TALKFUN_EVENT_FLOWER_SEND parameter:parameter callback:^(id obj) {
            if ([obj[@"code"] intValue]==0) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"flower" object:nil userInfo:@{@"mess":obj[@"data"]}];
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [weakSelf.view toast:[NSString stringWithFormat:@"%@秒后可获取一朵鲜花",obj[@"data"][@"left_time"]?obj[@"data"][@"left_time"]:@""] position:ToastPosition];
                    
                    
                    [weakSelf.chatTFView flower:NO number:0];
                });
                
                
                //
            }
        }];
    }else if (chatButton == self.chatTFView.sendButton || chatButton == self.longTextfieldView.sendBtn || chatButton == _longCoverTFView.sendButton)
    {
        if (chatButton == self.chatTFView.sendButton || chatButton == _longCoverTFView.sendButton) {
            parameter[@"msg"] = self.chatTFView.tf.text;
        }else{
            parameter[@"msg"] = self.longTextfieldView.tf.text;
        }
        WeakSelf
        [self.talkfunSDK emit:TALKFUN_EVENT_CHAT_SEND parameter:parameter callback:^(id obj) {
            PERFORM_IN_MAIN_QUEUE(
                                  if ([obj[@"code"] intValue] == TalkfunCodeSuccess) {
                                      [weakSelf loadData:parameter[@"msg"]];
                                      [[NSNotificationCenter defaultCenter] postNotificationName:@"chat" object:nil userInfo:@{@"mess":obj[@"data"]}];
                                  }
                                  else if ([obj[@"code"] intValue] == TalkfunCodeFailed)
                                  {
                                      [weakSelf.view toast:obj[@"msg"] position:ToastPosition];
                                  }
                                  else
                                  {
                                      [weakSelf.view toast:@"信息发送失败!" position:ToastPosition];
                                  }
                                  )
        }];
    }
    self.chatTFView.tf.text = nil;
    _longCoverTFView.tf.text = nil;
    self.longTextfieldView.tf.text = nil;
    [self expressionsViewShow:NO];
    [self.chatTFView showSendButton:NO];
    [_longCoverTFView showSendButton:NO];
}
//MARK:提问按钮点击事件
- (void)askButtonClicked:(UIButton *)button
{
    if (self.askTFView.myTextField.text.length==0) {
        [self.view endEditing:YES];
        [self.view toast:@"请输入要提问的内容!" position:ToastPosition];
        return;
    }
    
    if (self.unStart) {
        [self.view endEditing:YES];
        [self.view toast:@"还没开始上课" position:ToastPosition];
        return;
    }
    WeakSelf
    [self.talkfunSDK emit:TALKFUN_EVENT_QUESTION_ASK parameter:@{@"content":self.askTFView.myTextField.text} callback:^(id obj) {
        PERFORM_IN_MAIN_QUEUE(
                              if ([obj[@"code"] intValue] == TalkfunCodeSuccess) {
                                  [weakSelf questionAsk:obj[@"data"]];
                              }else if ([obj[@"code"] intValue] == 1202) {
                                  [weakSelf.askTFView.myTextField resignFirstResponder];
                                  [weakSelf.view toast:@"当前不在直播中" position:ToastPosition];
                              }
                              else if (![obj[@"msg"] isEqualToString:@""]) {
                                  [weakSelf.view toast:obj[@"msg"] position:ToastPosition];
                              })
    }];
    
    self.askTFView.myTextField.text = nil;
    [self.view endEditing:YES];
}
//MARK:表情按钮点击事件
- (void)expressionsBtnClicked:(UIButton *)expressionsBtn
{
    expressionsBtn.selected = !expressionsBtn.selected;
    if (expressionsBtn == self.chatTFView.expressionButton || expressionsBtn == _longCoverTFView.expressionButton) {
        //        [UIView animateWithDuration:0.25 animations:^{
        if (expressionsBtn.selected) {
            [self.view endEditing:YES];
            [self expressionsViewShow:YES];
            self.onlineLabel.frame= CGRectMake(self.onlineLabel.frame.origin.x, self.scrollView.frame.origin.y+30, self.onlineLabel.frame.size.width, self.onlineLabel.frame.size.height);
        }else{
            [self expressionsViewShow:NO];
            if (IsIPAD && self.isOrientationLandscape) {
                [_longCoverTFView.tf becomeFirstResponder];
            }else
                [self.chatTFView.tf becomeFirstResponder];
        }
        //        }];
    }
    else if (expressionsBtn == self.longTextfieldView.expressionBtn){
        [UIView animateWithDuration:0.25 animations:^{
            if (expressionsBtn.selected) {
                [self.view endEditing:YES];
                [self expressionsViewShow:YES];
            }else{
                [self expressionsViewShow:NO];
                [self.longTextfieldView.tf becomeFirstResponder];
            }
        }];
    }
}
#pragma mark 表情ivew显示
- (void)expressionsViewShow:(BOOL)show{
    if (!self.pptsFunctionView.fullScreenBtn.selected) {
        CGRect rect = _longCoverTFView.frame;
        rect.origin.x = show?0:CGRectGetMaxX(self.pptView.frame);
        rect.size.width = show?viewSize.width:CGRectGetWidth(self.scrollView.frame);
        self.longCoverTFView.frame = rect;
    }
    [UIView animateWithDuration:0.25 animations:^{
        if (show) {
            self.longCoverTFView.transform = CGAffineTransformMakeTranslation(0, -self.expressionViewVC.collectionView.contentSize.height);
            //160
            self.longTextfieldView.frame = CGRectMake(0, CGRectGetHeight(self.pptView.frame)-50 -2, CGRectGetWidth(self.pptView.frame), 50);
            self.expressionViewVC.view.transform = CGAffineTransformMakeTranslation(0, -self.expressionViewVC.collectionView.contentSize.height);
            [self.expressionViewVC.collectionView reloadData];
            self.longTextfieldView.transform = CGAffineTransformMakeTranslation(0, -self.expressionViewVC.collectionView.contentSize.height);
            self.chatTFView.transform = CGAffineTransformMakeTranslation(0, -self.expressionViewVC.collectionView.contentSize.height);
            if (self.isOrientationLandscape && self.pptsFunctionView.fullScreenBtn.selected) {
                self.inputBackgroundView.hidden = NO;
            }
            
        }else{
            self.expressionViewVC.view.transform = CGAffineTransformIdentity;
            
            self.longTextfieldView.transform = CGAffineTransformIdentity;
            self.longTextfieldView.frame = CGRectMake(0, CGRectGetHeight(self.pptView.frame)-50 -2, CGRectGetWidth(self.pptView.frame)-160, 50);
            
            self.chatTFView.transform = CGAffineTransformIdentity;
            self.longCoverTFView.transform = CGAffineTransformIdentity;
            self.inputBackgroundView.hidden = YES;
            
            
        }
        [self.chatTFView expressionBtnSelected:show];
        [self.longCoverTFView expressionBtnSelected:show];
        [self.longTextfieldView expressionBtnSelected:show];
    }];
}

#pragma mark - 强制竖屏
- (void)orientationPortrait {

    @synchronized (self) {

        self.isOrientationLandscape = NO;
    
        self.pptsFunctionView.fullScreenBtn.selected = NO;
        [[UIDevice currentDevice] setValue:@(UIInterfaceOrientationPortrait) forKey:@"orientation"];
        [self orientationPortrait:YES];
        self.view.bounds = CGRectMake(0, 0, ScreenSize.width, ScreenSize.height);
        [self updateChrysanthemum];
        
    }
}

- (void)deviceOrientationChange:(NSNotification *)notification{
    if (self.pptsFunctionView.fullScreenBtn.selected || [self.view.subviews.lastObject isKindOfClass:[TalkfunGuidanceView class]]) {
        return;
    }
    NSLog(@"oooo:%ld",[UIDevice currentDevice].orientation);
    [self expressionsViewShow:NO];
    [self.view endEditing:YES];
    
    [_commentView changeLayout];
    
    if ([UIDevice currentDevice].orientation == 3 && !self.isOrientationLandscape) {
        [self orientationLandscape];
    } else if ([UIDevice currentDevice].orientation==1 && self.isOrientationLandscape){
        [self orientationPortrait];
    }
}

- (void)orientationPortrait:(BOOL)portrait
{
    [_commentView changeLayout];
    
    self.isOrientationLandscape = !portrait;
    //ppt
    self.pptView.frame = portrait?CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.width * 3 / 4.0):IsIPAD&&self.iPadAutoRotate?CGRectMake(0, 0, self.view.bounds.size.width * 7 / 10, self.view.bounds.size.height):CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    
    self.bitmapView.frame = CGRectMake(0, 0, self.pptView.frame.size.width, self.pptView.frame.size.height);
    
    if(self.liveStop){
        
        if(self.pptView.frame.size.height/self.pptView.frame.size.width!=0.75){
            self.bitmapView.image = [UIImage imageNamed:@"直播已结束16_9"];
        }else{
            self.bitmapView.image = [UIImage imageNamed:@"直播已结束"];
        }
    }else{
        if(self.pptView.frame.size.height/self.pptView.frame.size.width!=0.75){
            self.bitmapView.image = [UIImage imageNamed:@"直播未开始16_9"];
        }else{
            self.bitmapView.image = [UIImage imageNamed:@"直播未开始"];
        }
    }
    
    self.longTextfieldView.frame = CGRectMake(0, CGRectGetHeight(self.pptView.frame)-50 -2, CGRectGetWidth(self.pptView.frame) - 160, 50);
    self.inputBackgroundView.frame = self.view.bounds;
    self.longTextfieldView.hidden = portrait|self.iPadAutoRotate;
    self.expressionViewVC.view.frame = CGRectMake(0, viewSize.height, viewSize.width,ExpressionViewHeight());
    
    //改变喇叭滚动条的frame
    self.hornView.frame = CGRectMake(0, CGRectGetMaxY(self.pptView.frame) - 25, CGRectGetWidth(self.pptView.frame), 25);
    
    //加动画
    [self.hornView rollLabelAddAnimation];
    
    //修改摄像头的frame
    //    self.cameraView.transform = CGAffineTransformIdentity;
    
    if (IsIPAD) {
        self.cameraView.frame = portrait?CGRectMake(viewSize.width * 0.7, CGRectGetMaxY(self.pptView.frame) + ButtonViewHeight, viewSize.width*0.3, viewSize.width*0.3*3.0/4.0):self.iPadAutoRotate?CGRectMake(CGRectGetMaxX(self.pptView.frame), 0, CGRectGetWidth(self.view.bounds)-CGRectGetWidth(self.pptView.frame), (viewSize.width-CGRectGetWidth(self.pptView.frame))*3.0/4.0):CGRectMake(CGRectGetMaxX(self.pptView.frame) - CGRectGetHeight(self.view.bounds)*3.0/10.0, CGRectGetMaxY(self.pptView.frame)-50-(CGRectGetHeight(self.view.bounds)*3.0/10.0)*3.0/4.0, CGRectGetHeight(self.view.bounds)*3.0/10.0, (CGRectGetHeight(self.view.bounds)*3.0/10.0)*3.0/4.0);
    }else{
        CGRect frame = self.cameraView.frame;
        frame.origin = portrait?CGPointMake(viewSize.width - 150, CGRectGetMaxY(self.pptView.frame) + ButtonViewHeight):CGPointMake(CGRectGetMaxX(self.pptView.frame) - self.cameraView.frame.size.width, CGRectGetMaxY(self.pptView.frame)-50-CGRectGetHeight(frame));
        self.cameraView.frame = frame;
    }
    //    self.cameraView.backgroundColor = [UIColor blackColor];
    //    self.cameraView.hidden = NO;
    self.buttonView.frame = portrait?CGRectMake(0, CGRectGetMaxY(self.pptView.frame) - 1, viewSize.width, ButtonViewHeight):CGRectMake(CGRectGetMaxX(self.pptView.frame), self.cameraView.hidden?0:CGRectGetMaxY(self.cameraView.frame), viewSize.width-CGRectGetWidth(self.pptView.frame), ButtonViewHeight);
    
    //修改scrollView的frame和contentSize
    self.scrollView.frame = portrait?CGRectMake(0, CGRectGetMaxY(self.pptView.frame) + ButtonViewHeight, viewSize.width, viewSize.height - CGRectGetMaxY(self.pptView.frame) - ButtonViewHeight):CGRectMake(CGRectGetMaxX(self.pptView.frame), CGRectGetMaxY(self.buttonView.frame), self.view.bounds.size.width - CGRectGetMaxX(self.pptView.frame), self.view.bounds.size.height - CGRectGetMaxY(self.buttonView.frame));
    self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.scrollView.frame) * self.tableViewNum, CGRectGetHeight(self.scrollView.frame));
    self.scrollView.contentOffset = CGPointMake(0, 0);
    [self.buttonView selectButton:self.buttonView.chatBtn];
    
    //修改tableView的frame和刷新tableView
    for (int i = 0; i < self.tableViewNum; i ++) {
        UIView * tableView = (UIView *)[self.scrollView viewWithTag:300 + i];
        tableView.frame    = CGRectMake(i * self.scrollView.frame.size.width, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height - 50);
        if (i == 2) {
            tableView.frame = CGRectMake(i * self.scrollView.frame.size.width, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height);
        }
        id tableViewV = tableView.nextResponder;
        RootTableViewController * tableViewVC = tableViewV;
        
        //        if (i == 0 || i == 1) {
        [tableViewVC recalculateCellHeight];
        //        }else
        [tableViewVC.tableView reloadData];
        
        
    }
    self.shadowView.frame = self.scrollView.frame;
    
    //修改chatTF和askTF的frame
    self.chatTFView.frame = CGRectMake(0, CGRectGetHeight(self.view.frame) - 50, CGRectGetWidth(self.scrollView.frame), 50);
    
    self.askTFView.frame = CGRectMake(0, CGRectGetHeight(self.view.frame) - 50, CGRectGetWidth(self.scrollView.frame), 50);
    
    
    if (!portrait && IsIPAD && !_longCoverTFView) {
        [self.view insertSubview:self.longCoverTFView belowSubview:self.cameraView];
    }
    _longCoverTFView.hidden = portrait;
    _longCoverTFView.frame = CGRectMake(CGRectGetMaxX(self.pptView.frame), CGRectGetMaxY(self.scrollView.frame)-CGRectGetHeight(self.chatTFView.frame), CGRectGetWidth(self.scrollView.frame), CGRectGetHeight(self.chatTFView.frame));
    
    
    //改变输入框下划线长度
    [self.askTFView askTFFrameChanged];
    
    //改变遮布
    self.coverView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    
    //抽奖投票
    self.voteVC.view.frame = self.view.bounds;
    self.voteEndVC.view.frame = self.view.bounds;
    self.lotteryVC.view.frame = self.view.bounds;
    self.myLotteryVC.view.frame = self.view.bounds;
    
    //网络选择
    self.networkSelectionVC.view.frame = self.view.bounds;
    self.networkSelectionVC.rotated    = !portrait;
    
    originPPTFrame = self.pptView.frame;
    
    if (!IsIPAD||!self.iPadAutoRotate) {
        self.buttonView.hidden = !portrait;
        self.scrollView.hidden = !portrait;
        self.shadowView.hidden = !portrait;
    }
    [self removeNetworkTipsView];
    [self removeReplyTipsView];
    
    [self updateChrysanthemum];
    
}
#pragma mark - 强制横屏
- (void)orientationLandscape
{
    @synchronized (self) {
        
        self.isOrientationLandscape = YES;
        
//        [[UIDevice currentDevice] setValue:@(UIInterfaceOrientationPortrait) forKey:@"orientation"];
//        //强制翻转屏幕，Home键在右边。
//        [[UIDevice currentDevice] setValue:@(UIInterfaceOrientationLandscapeRight) forKey:@"orientation"];
        //刷新
        //        [UIViewController attemptRotationToDeviceOrientation];
        
        [self orientationPortrait:NO];
        
    }
}

- (void)chatMessageCome{
    [self.buttonView showTipsInButton:self.buttonView.chatBtn];
}
- (void)askMessageCome{
    [self.buttonView showTipsInButton:self.buttonView.askBtn];
}
- (void)noticeMessageCome{
    [self.buttonView showTipsInButton:self.buttonView.noticeBtn];
}

#pragma mark - =========== 接口回调处理 ============
- (void)questionAsk:(id)obj{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ask" object:nil userInfo:@{@"mess":obj}];
}
- (void)liveModeChange:(id)obj
{
    WeakSelf
    TalkfunLiveMode mode = [obj[@"currentMode"] intValue];
    TalkfunLiveMode mode2 = [obj[@"beforeMode"] intValue];
    
    
    if (mode != mode2) {
        weakSelf.tipsLabel.text = @"切换中...";
        [weakSelf.pptView addSubview:weakSelf.tipsLabel];
    }
}

- (void)voteNew:(id)obj
{
    WeakSelf
    [weakSelf.voteNewDict setObject:obj forKey:obj[@"vid"]];
    [APPLICATION sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    NSString * nickname  = obj[@"info"][@"nickname"];
    NSString * startTime = obj[@"info"][@"startTime"];
    //    NSArray * arr        = [startTime componentsSeparatedByString:@" "];
    //    NSString *content = @"";
    //    if(arr.count>1){
    //        content = arr[1];
    //    }else if (arr.count==1){
    //        content = arr[0];
    //    }
    startTime = [self removeSpaceAndNewline:startTime];
    NSString * message   = [NSString stringWithFormat:@"管理员 %@ 在%@发起了一个",nickname,startTime];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"broadcastInfo" object:nil userInfo:@{@"vote:new":message,@"nickname":nickname,@"vid":obj[@"vid"]}];
    
    [weakSelf.voteVC removeFromSuperview];
    //
    [weakSelf.voteVC refreshUIWithParams:obj];
    
    weakSelf.voteVC.view.alpha = 1.0;
    [weakSelf.view addSubview:weakSelf.voteVC.view];
}

- (NSString *)removeSpaceAndNewline:(NSString *)str
{
    if (str==nil) {
        str =@"";
    }
    NSString *temp = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    temp = [temp stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    temp = [temp stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    return temp;
}
- (void)votePub:(id)obj
{
    WeakSelf
    [weakSelf.voteNewDict removeObjectForKey:obj[@"info"][@"vid"]];
    [weakSelf.votePubDict setObject:obj[@"isShow"] forKey:obj[@"info"][@"vid"]];
    [APPLICATION sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    NSString * nickname = obj[@"info"][@"nickname"];
    NSString * endTime  = obj[@"info"][@"endTime"];
    NSArray * arr2      = [endTime componentsSeparatedByString:@" "];
    
    NSString *content = @"";
    if(arr2.count>1){
        content = arr2[1];
    }else if (arr2.count==1){
        content = arr2[0];
    }
    
    NSString * message  = [NSString stringWithFormat:@"管理员 %@ 在%@结束了投票。",nickname,content];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"broadcastInfo" object:nil userInfo:@{@"vote:pub":message,@"nickname":nickname,@"vid":obj[@"info"][@"vid"],@"isShow":obj[@"isShow"]}];
    if ([obj[@"isShow"] integerValue] == 0) {
        return ;
    }
    [weakSelf.voteVC removeFromSuperview];
    
    [weakSelf.voteVC refreshUIWithResult:obj];
    weakSelf.voteVC.view.alpha = 1.0;
    [weakSelf.view addSubview:weakSelf.voteVC.view];
}

- (void)lotteryStart:(id)obj
{
    WeakSelf
    [weakSelf.myLotteryVC.view removeFromSuperview];
    [APPLICATION sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    weakSelf.lotteryVC.view.alpha = 1.0;
    [weakSelf.view addSubview:weakSelf.lotteryVC.view];
    [weakSelf.lotteryVC refreshUIWithInfo:nil];
}

- (void)lotteryStop:(id)obj
{
    WeakSelf
    [weakSelf.lotteryVC.view removeFromSuperview];
    [APPLICATION sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    NSArray * arr              = obj[@"result"];
    NSString * launch_nickname = arr[0][@"launch_nickname"];
    
    
    NSString *nickname = @"";
    
    
    for (int i = 0; i<arr.count; i++) {
        
        NSDictionary *nameDict  = arr[i];
        nickname = [nickname stringByAppendingString:nameDict[@"nickname"]];
        if (i!=arr.count-1) {
            nickname = [nickname stringByAppendingString:@"、"];
        }
        
    }
    
    NSLog(@"%@",nickname);
    //    NSString * nickname        = arr[0][@"nickname"];
    NSString * message         = [NSString stringWithFormat:@"通知: %@ 发起了抽奖,恭喜 %@ 中奖!",launch_nickname,nickname];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"broadcastInfo" object:nil userInfo:@{@"lottery:stop":message,@"launch_nickname":launch_nickname,@"nickname":nickname}];
    if (![weakSelf.view.subviews containsObject:weakSelf.lotteryVC.view]) {
        
        //        NSString * xid = [NSString stringWithFormat:@"%@",obj[@"result"][0][@"xid"]];
        NSString * myXid = [NSString stringWithFormat:@"%@",weakSelf.me[@"xid"]];
        
        
        for (NSDictionary *dict in obj[@"result"]) {
            
            
            NSString * xid = [NSString stringWithFormat:@"%@",dict[@"xid"]];
            
            if ([xid isEqualToString:myXid]) {
                weakSelf.myLotteryVC.view.alpha = 1.0;
                
                weakSelf.myLotteryVC.nameLabel.text = weakSelf.me[@"nickname"];
                [weakSelf.view addSubview:weakSelf.myLotteryVC.view];
                [weakSelf.myLotteryVC refreshUIWithInfo:obj];
                return;
            }
        }
        
        
        
        //        if ([xid isEqualToString:myXid]) {
        //
        //
        //        }else
        //        {
        weakSelf.lotteryVC.view.alpha = 1.0;
        [weakSelf.view addSubview:weakSelf.lotteryVC.view];
        [weakSelf.lotteryVC refreshUIWithInfo:obj];
        //        }
    }
}

- (void)broadcast:(id)obj{
    NSString * mess    = obj[@"message"];
    NSString * message = [NSString stringWithFormat:@"公共广播: %@",mess];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"broadcastInfo" object:nil userInfo:@{@"broadcast":message,@"mess":mess}];
}

- (void)chatDisable:(id)obj
{
    WeakSelf
    NSString * nickname = obj[@"nickname"];
    if ([weakSelf.me[@"xid"] integerValue] == [obj[@"xid"] integerValue]) {
        return ;
    }
    else if ([weakSelf.me[@"role"] isEqualToString:TalkfunMemberRoleAdmin] || [weakSelf.me[@"role"] isEqualToString:TalkfunMemberRoleSpadmin])
    {
        NSString * message = [NSString stringWithFormat:@"系统:【%@】已经被管理员\"禁言\"",nickname];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"broadcastInfo" object:nil userInfo:@{@"chat:disable":message,@"nickname":nickname}];
    }
}

- (void)chatDisableAll:(id)obj
{
    int status = [obj[@"status"] intValue];
    self.chatTFView.userInteractionEnabled = status==1?NO:YES;
    self.chatTFView.alpha = status==1?0.5:1;
    
    self.longTextfieldView.userInteractionEnabled = status==1?NO:YES;
    self.longTextfieldView.alpha = status==1?0.5:1;
    
    
    
    self.longCoverTFView.userInteractionEnabled = status==1?NO:YES;
    self.longCoverTFView.alpha = status==1?0.5:1;
    //禁言
    if(status==1){
        self.disableAll = YES;
        NSString * message = [NSString stringWithFormat:@"公共广播: %@",@"锁屏模式已开启"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"broadcastInfo" object:nil userInfo:@{@"broadcast":message,@"mess":@"锁屏模式已开启"}];
        
        [self setWordsNotAllowed];
        
        
        //能说话
    }else if(status == 0){
        self.disableAll = NO;
        NSString * message = [NSString stringWithFormat:@"公共广播: %@",@"锁屏模式已关闭"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"broadcastInfo" object:nil userInfo:@{@"broadcast":message,@"mess":@"锁屏模式已关闭"}];
        [self setWordsAllowed];
        
    }
}

- (void)flowerGetInit:(id)obj
{
    if ([obj[@"code"] integerValue] == TalkfunCodeSuccess && ([obj[@"amount"] integerValue] > 0 && [obj[@"amount"] integerValue] <=3)) {
        //        NSString * amount = [NSString stringWithFormat:@"%@",obj[@"amount"]];
        [self.chatTFView flower:YES number:[obj[@"amount"] integerValue]];
        [_longCoverTFView flower:YES number:[obj[@"amount"] integerValue]];
    }else{
        [self.chatTFView flower:NO number:0];
        [_longCoverTFView flower:NO number:0];
    }
}

- (void)flowerTotal:(id)obj
{
    NSInteger total      = [obj[@"amount"] integerValue];
    NSLog(@"flowercome total:%ld",total);
    [self.chatTFView flower:total number:total];
    [_longCoverTFView flower:total number:total];
}

- (void)memberJoinOther:(id)obj{
    //    WeakSelf
    //    weakSelf.messageView.renshuLabel.text = [NSString stringWithFormat:@"%@人",obj[@"total"]];
}

- (void)memberLeave:(id)obj{
    //    WeakSelf
    //    weakSelf.messageView.renshuLabel.text = [NSString stringWithFormat:@"%@人",obj[@"total"]];
}

- (void)liveStart:(id)obj
{
    WeakSelf
    PERFORM_IN_MAIN_QUEUE(
                          //                          [weakSelf.view toast:@"开始上课" position:ToastPosition];
                          if (weakSelf.unStart == YES && !weakSelf.isFirst) {
                              //                              [[NSNotificationCenter defaultCenter] postNotificationName:@"clear" object:nil];
                          }
                          weakSelf.unStart = NO;
                          
                          [[TalkfunDownloadManager shareManager] pauseAllDownload];
                          )
}

- (void)liveStop:(id)obj
{
    WeakSelf;
    //    weakSelf.messageView.liveStatusLabel.text = @"直播已结束";
    weakSelf.unStart = YES;
    weakSelf.isFirst = NO;
    [weakSelf.tipsLabel removeFromSuperview];
    weakSelf.tipsLabel = nil;
    
    //    [weakSelf.functionView liveStart:NO];
    PERFORM_IN_MAIN_QUEUE(
                          [weakSelf.view toast:@"下课了～" position:ToastPosition];
                          weakSelf.networkSelectionVC.selectedNumber = 0;
                          if (weakSelf.talkfunSDK.isExchanged) {
                              [weakSelf.talkfunSDK exchangePPTAndCameraContainer];
                          }
                          )
    
    //    [weakSelf.networkStatusView networkStatusViewHide:YES];
}

- (void)memberKick:(id)obj
{
    WeakSelf
    NSString * nickname = obj[@"nickname"];
    NSString * message  = [NSString stringWithFormat:@"通知: 管理员把 %@ 请出了房间",nickname];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"broadcastInfo" object:nil userInfo:@{@"member:kick":message,@"nickname":nickname}];
    if ([weakSelf.me[@"xid"] isEqualToString:[NSString stringWithFormat:@"%@",obj[@"xid"]]]) {
        PERFORM_IN_MAIN_QUEUE([weakSelf removeOnSomething];
                              [weakSelf.kickoutAlertView show];
                              )
    }
}

- (void)memberForceout:(id)obj
{
    WeakSelf
    PERFORM_IN_MAIN_QUEUE([weakSelf removeOnSomething];
                          [weakSelf.forceoutAlertView show];
                          )
}

#pragma mark 锁屏模式,暂时不能发言哦
- (void)setWordsNotAllowed{
    
//    _askTFView.myTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"当前是锁屏模式,暂时不能发言哦..." attributes:@{NSForegroundColorAttributeName: LIGHTBLUECOLOR}];
//    _askTFView.userInteractionEnabled = NO;
//    _askTFView.alpha = 0.5;
    if (self.isOrientationLandscape==NO) {
        self.chatTFView.tf.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"当前是锁屏模式,暂时不能发言哦..." attributes:@{NSForegroundColorAttributeName: LIGHTBLUECOLOR}];
        self.longTextfieldView.tf.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"当前是锁屏模式,暂时不能发言哦..." attributes:@{NSForegroundColorAttributeName: LIGHTBLUECOLOR}];
        self.longCoverTFView.tf.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"当前是锁屏模式,暂时不能发言哦..." attributes:@{NSForegroundColorAttributeName: LIGHTBLUECOLOR}];
    }else{
        
        
        
        self.chatTFView.tf.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"当前是锁屏模式,暂时不能发言哦..." attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
        self.longTextfieldView.tf.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"当前是锁屏模式,暂时不能发言哦..." attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
        self.longCoverTFView.tf.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"当前是锁屏模式,暂时不能发言哦..." attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
        
    }
    
    
    
}
#pragma mark 请输入文字
- (void)setWordsAllowed
{

//    _askTFView.myTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"我要提问..." attributes:@{NSForegroundColorAttributeName: LIGHTBLUECOLOR}];
//     _askTFView.userInteractionEnabled = YES;
//    _askTFView.alpha = 1;

    if (self.isOrientationLandscape==NO) {
        
        self.chatTFView.tf.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入文字" attributes:@{NSForegroundColorAttributeName: LIGHTBLUECOLOR}];
        self.longTextfieldView.tf.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入文字" attributes:@{NSForegroundColorAttributeName: LIGHTBLUECOLOR}];
        self.longCoverTFView.tf.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入文字" attributes:@{NSForegroundColorAttributeName: LIGHTBLUECOLOR}];
    }else{
        
        self.chatTFView.tf.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入文字" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
        self.longTextfieldView.tf.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入文字" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
        self.longCoverTFView.tf.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入文字" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    }
}
- (void)roomInit:(id)obj
{
    WeakSelf
    //    [self.loadingView removeFromSuperview];
    //    self.loadingView = nil;
    //    [weakSelf.messageView roomInit:obj];
    weakSelf.me = [[NSDictionary alloc] initWithDictionary:obj[@"roomInfo"][@"me"]];
    //MARK:滚动条
    [weakSelf.pptView addSubview:weakSelf.hornView];
    [weakSelf.hornView announceRoll:obj[@"roomInfo"][@"announce"][@"roll"]];
    //有聊天数据才发送
    if(obj[@"roomInfo"][@"announce"][@"notice"]){
        [[NSNotificationCenter defaultCenter] postNotificationName:@"notice" object:nil userInfo:@{@"mess":obj[@"roomInfo"][@"announce"][@"notice"]}];
    }
    
    
    int stat =[obj[@"roomInfo"][@"room"][@"chat"][@"disableall"]intValue];
    
    NSArray * initEvent = obj[@"roomInfo"][@"initEvent"];
    for (NSDictionary * event in initEvent) {
        if ([event[@"cmd"] isEqualToString:@"broadcast"]) {
            [weakSelf broadcast:event[@"args"]];
        }
    }
    
    //禁
    if (stat==1) {
        NSLog(@"禁文");
        self.disableAll = YES;
        [self setWordsNotAllowed];
        
        self.chatTFView.userInteractionEnabled = NO;
        self.longTextfieldView.userInteractionEnabled = NO;
        self.longCoverTFView.userInteractionEnabled = NO;
        
        self.longTextfieldView.alpha = 0.5;
        self.chatTFView.alpha = 0.5;
        //         self.longCoverTFView.alpha = 0.5;
    }else if (stat ==0){
        self.disableAll = NO;
        NSLog(@"能说话");
        [self setWordsAllowed];
        
        
        self.longTextfieldView.userInteractionEnabled = YES;
        self.chatTFView.userInteractionEnabled = YES;
        self.longCoverTFView.userInteractionEnabled = NO;
        
        
        self.longTextfieldView.alpha = 1;
        self.chatTFView.alpha = 1;
        self.longCoverTFView.alpha = 1;
    }
    
    
    NSString * enable = obj[@"visitorInfo"][@"enable"];
    dispatch_async(dispatch_get_main_queue(), ^{
        //显示访客
        if ([enable integerValue]==1 ) {
            
            
            if ( [obj[@"visitorInfo"][@"config"][@"visitorCount"] isKindOfClass:[NSDictionary class] ]) {
                NSDictionary *config = obj[@"visitorInfo"][@"config"][@"visitorCount"];
                if ([config [@"enable"] integerValue]==0) {
                    self.enable =   NO;
                }else{
                    self.enable =   YES;
                }
                
                
                
            }
            
        }else{
            self.enable = NO;
            //            self.onlineLabel.hidden = YES;
            
        }
    });
    
    
    self.nameDict  =   [TalkfunWatermark getWatermarkName:obj];
    
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
- (TalkfunMoveLabel*)onlineLabel
{
    if (_onlineLabel==nil) {
        _onlineLabel = [[TalkfunMoveLabel alloc]init];
        _onlineLabel.hidden = YES;
        _onlineLabel.frame =CGRectMake(self.view.frame.size.width - 80, self.cameraView.frame.size.height +self.cameraView.frame.origin.y +(self.cameraView.frame.size.height*0.8)  , 65, 25);
        [self.view addSubview:_onlineLabel];
        [self.view bringSubviewToFront:_onlineLabel];
        
        _onlineLabel.font = [UIFont boldSystemFontOfSize:11];  // 按钮字体大小
        _onlineLabel.alpha = 0.5,
        _onlineLabel.layer.cornerRadius = 10;
        
        _onlineLabel.layer.masksToBounds = YES;
        _onlineLabel.backgroundColor = [UIColor colorWithRed:102 / 255.0 green:175 / 255.0 blue:239 / 255.0 alpha:1];;
        _onlineLabel.textAlignment = NSTextAlignmentCenter;
        _onlineLabel.textColor = [UIColor colorWithRed:236 / 255.0 green:255.0 / 255.0 blue:255 / 255.0 alpha:1];;
    }
    return _onlineLabel;
}


- (void)memberTotal:(id)obj
{
    
    if (![obj isKindOfClass:[NSDictionary class]] ) {
        return;
    }
    NSString *total = @"";
    if (obj[@"online"][@"total"]) {
        total = obj[@"online"][@"total"];
    }
    
    if (obj[@"total"]) {
        total = obj[@"total"];
    }
    
    //    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (self.enable==YES) {
            
            self.onlineLabel.text = [NSString stringWithFormat:@"在线 %@ 人",total];
            
            NSDictionary *attrs = @{NSFontAttributeName : [UIFont boldSystemFontOfSize:11]};
            CGSize attrsSize=[self.onlineLabel.text sizeWithAttributes:attrs];
            
            self.onlineLabel.frame = CGRectMake(self.onlineLabel.frame.origin.x, self.onlineLabel.frame.origin.y, attrsSize.width, self.onlineLabel.frame.size.height);
            
            self.onlineLabel.hidden =NO;
            
            //                [self.view addSubview:self.onlineLabel];
        }
        
    });
    
    //    });
    
    
    
    //       [[NSNotificationCenter defaultCenter] postNotificationName:@"TALKFUN_NOTIFICATION_TOTAL_ONLINE" object:nil userInfo:@{@"total":total}];
}

- (void)networkSpeed:(id)obj
{
    WeakSelf
    if (weakSelf.unStart) {
        return ;
    }
    [self.networkSelectionVC networkSpeed:obj];
    
    TalkfunNetworkStatus networkStatus = [obj[@"networkStatus"] intValue];
    
    if (networkStatus == TalkfunNetworkStatusBad && networkStatus != self.networkStatus) {
        [weakSelf addNetworkTipsView];
    }
    weakSelf.networkStatus = networkStatus;
}
#pragma mark - =========== 接口回调处理结束 ============

#pragma mark - 加手势
- (void)addGesture
{
    //scrollview加手势
    UITapGestureRecognizer * tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGR:)];
    [self.scrollView addGestureRecognizer:tapGR];
    
    //ppt加手势
    UITapGestureRecognizer * pptTapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pptTapGR:)];
    [self.pptView addGestureRecognizer:pptTapGR];
    pptTapGR.numberOfTapsRequired = 1;
    
    UITapGestureRecognizer * pptShareTapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pptShareTapGR:)];
    pptShareTapGR.numberOfTapsRequired = 2;
    [self.pptView addGestureRecognizer:pptShareTapGR];
    
    //pptview加拖动手势
    UIPanGestureRecognizer * pptHandlePan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pptHandlePan:)];
    //    pptPanGR.delegate= self;
    [self.pptView addGestureRecognizer:pptHandlePan];
    
    //摄像头加手势
    UIPanGestureRecognizer *panGR = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(objectDidDragged:)];
    panGR.maximumNumberOfTouches = 2;
    [self.cameraView addGestureRecognizer:panGR];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self.cameraView addGestureRecognizer:tap];
    
    originPPTFrame = self.pptView.frame;
    //摄像头缩放
    //    UIPinchGestureRecognizer * pinchGR = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchGR:)];
    //    [self.cameraView addGestureRecognizer:pinchGR];
    
    UITapGestureRecognizer * inputBackgroundTapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(inputBackgroundTapGR:)];
    [self.inputBackgroundView addGestureRecognizer:inputBackgroundTapGR];
}

- (void)inputBackgroundTapGR:(UITapGestureRecognizer *)tapGR{
    
}
#pragma mark - 手势的方法
- (void)tap:(UITapGestureRecognizer *)tap
{
    [self.view addSubview:self.cameraView];
    
    [self.view endEditing:YES];
    [self expressionsViewShow:NO];
    //    self.expressionsView.hidden = YES;
    //    self.expressionsView2.hidden = YES;
    //    static CGAffineTransform transform;
    static CGRect frame;
    if (self.isCameraFullScreen==NO) {
        self.isCameraFullScreen = YES;
        //        transform = self.cameraView.transform;
        //先保存原来cameraView的frame的大小
        frame = CGRectMake(self.cameraView.frame.origin.x, self.cameraView.frame.origin.y, self.cameraView.frame.size.width, self.cameraView.frame.size.height);
        //设为黑色和全屏
        //self.cameraView.backgroundColor = [UIColor blackColor];
        [UIView animateWithDuration:0.5 animations:^{
            //            self.cameraView.transform = CGAffineTransformIdentity;
            self.cameraView.frame = CGRectMake(0, 0,self.view.frame.size.width, self.view.frame.size.height);
            [self updateChrysanthemum];
        }];
    }else
    {
        self.isCameraFullScreen = NO;
        [UIView animateWithDuration:0.5 animations:^{
            self.cameraView.frame = frame;
            [self updateChrysanthemum];
        } completion:^(BOOL finished) {
            //设为原来的颜色和原来的frame
            //self.cameraView.backgroundColor = [UIColor clearColor];
        }];
    }
    
    
    
    
}

- (void)tapGR:(UITapGestureRecognizer *)tapGR{
    //收键盘
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    [self expressionsViewShow:NO];
}

- (void)pptTapGR:(UITapGestureRecognizer *)pptTapGR
{
    //    if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeRight ) {
    //        return;
    //    }
    self.pptsFunctionView.smoothView.alpha  = 0;
    //    NSLog(@"ppttapBegin:%ld",pptTapGR.state);
    self.pptsFunctionView.hidden = !self.pptsFunctionView.hidden;
}

static CGRect originPPTFrame;
- (void)pptShareTapGR:(UITapGestureRecognizer *)pptShareTapGR
{
    if (pptShareTapGR.state == UIGestureRecognizerStateEnded) {
        CGPoint location = [pptShareTapGR locationInView:self.pptView];
        if (!self.pptsFunctionView.hidden && (location.y<50||location.y>CGRectGetHeight(self.pptView.frame)-50)) {
            return;
        }
    }
    if (!self.pptsFunctionView.fullScreenBtn.selected && self.isOrientationLandscape) {
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
    
    
    lastScale = scale;
    
}

- (void)objectDidDragged:(UIPanGestureRecognizer *)sender
{
    if (self.isOrientationLandscape && self.pptsFunctionView.fullScreenBtn.selected == NO) {
        return;
    }
    if (sender.state == UIGestureRecognizerStateChanged) {
        
        //注意，这里取得的参照坐标系是该对象的上层View的坐标。
        CGPoint offset        = [sender translationInView:self.cameraView];
        UIView * draggableObj = self.cameraView;
        
        CGFloat finalX        = draggableObj.center.x + offset.x;
        CGFloat finalY        = draggableObj.center.y + offset.y;
        
        CGFloat minX          = self.cameraView.frame.size.width / 2;
        CGFloat maxX          = self.view.bounds.size.width - (self.cameraView.frame.size.width / 2);
        CGFloat minY          = self.cameraView.frame.size.height / 2;
        CGFloat maxY          = self.view.bounds.size.height - (self.cameraView.frame.size.height / 2);
        
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
        
        //通过计算偏移量来设定draggableObj的新坐标
        draggableObj.center = CGPointMake(finalX, finalY);
        //初始化sender中的坐标位置。如果不初始化，移动坐标会一直积累起来。
        [sender setTranslation:CGPointMake(0, 0) inView:self.cameraView];
        
        NSString * model = [UIDevice currentDevice].model;
        if ([model isEqualToString:@"iPod touch"]) {
            //有图像的留存问题 重新渲染
            for (UIView * subView in self.view.subviews) {
                [subView setNeedsDisplayInRect:self.view.bounds];
                [subView setNeedsLayout];
                [subView setNeedsDisplay];
            }
        }else
        {
            
        }
    }
}


- (void)removeOnSomething
{
    WeakSelf
    [[NSNotificationCenter defaultCenter] removeObserver:weakSelf];
    //    [weakSelf.talkfunSDK.view removeFromSuperview];
    weakSelf.coverView.hidden = NO;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    [self expressionsViewShow:NO];
    //    self.expressionsView.hidden = YES;
    //    self.expressionsView2.hidden = YES;
    
    
    
    //    WeakSelf
    
    
    //    //获取全部投票
    //    [self.talkfunSDK getVotes:^(id result) {
    //
    //        if ([result isKindOfClass:[NSArray class]]) {
    //
    //            dispatch_async(dispatch_get_main_queue(), ^{
    //                NSMutableArray *array = result;
    //                     if (array.count>0) {
    //                       [weakSelf voteNew: result[0]];
    //                      }
    //
    //              });
    //
    //        }
    //
    //    }];
    //    //获取未收到的投票
    //    [self.talkfunSDK getVotesUnreceived:^(id result) {
    //
    //           if ([result isKindOfClass:[NSArray class]]) {
    //
    //               dispatch_async(dispatch_get_main_queue(), ^{
    //                   NSMutableArray *array = result;
    //
    //                   if (array.count>0) {
    //                       [weakSelf voteNew: result[0]];
    //                   }
    //
    //               });
    //
    //           }
    //
    //    }];
    
    //
    //
    //    ///--------------------------------------------------------------------
    //     //获取全部的广播
    //    [self.talkfunSDK getBroadcasts:^(id result) {
    //
    //        if ([result isKindOfClass:[NSArray class]]) {
    //
    //            dispatch_async(dispatch_get_main_queue(), ^{
    //                NSMutableArray *array = result;
    //
    //                   if (array.count>0) {
    //                       [weakSelf broadcast: result[0]];
    //                      }
    //
    //            });
    //
    //        }
    //
    //    }];
    ////    ////获取未收到的广播
    //    [self.talkfunSDK getBroadcastsUnreceived:^(id result) {
    //
    //        if ([result isKindOfClass:[NSArray class]]) {
    //
    //
    //
    //            dispatch_async(dispatch_get_main_queue(), ^{
    //                NSMutableArray *array = result;
    //
    //                if (array.count>0) {
    //                    [weakSelf broadcast: result[0]];
    //                }
    //
    //            });
    //
    //        }
    //
    //    }];
    
    
}

#pragma mark - scrollView 代理方法

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self endDecelerating:scrollView];
}
- (void)endDecelerating:(UIScrollView *)scrollView
{
    if (self.scrollView.contentOffset.x == 0) {
        if (self.isOrientationLandscape && self.pptsFunctionView.fullScreenBtn.selected==NO && IsIPAD) {
            _longCoverTFView.hidden = NO;
        }
    }else{
        _longCoverTFView.hidden = YES;
    }
    if (!IsIPAD && self.isOrientationLandscape) {
        return;
    }
    if (self.scrollView == scrollView) {
        NSInteger num = round((scrollView.contentOffset.x) / self.scrollView.frame.size.width);
        
        //
        if (self.enable) {
            self.onlineLabel.hidden = NO;
        }else{
            self.onlineLabel.hidden = YES;
        }
        if (num==0) {
            //聊天栏显示
            self.chatTFView.hidden = NO;
            //提问隐藏
            self.askTFView.hidden = YES;
        }else if (num ==1){
            //            self.onlineLabel.hidden = YES;
            //聊天栏显示
            self.chatTFView.hidden = YES;
            //提问隐藏
            self.askTFView.hidden = NO;
        }else if (num ==2){
            //聊天栏显示
            self.chatTFView.hidden = YES;
            //提问隐藏
            self.askTFView.hidden = YES;
            //            self.onlineLabel.hidden = YES;
        }
        
        //        [self.view endEditing:YES];
        [self expressionsViewShow:NO];
        TalkfunNewButtonViewButton * btn = [self.buttonView viewWithTag:500+num];
        [self.buttonView selectButton:btn];
        if (scrollView.contentOffset.x > self.scrollView.frame.size.width * (self.tableViewNum - 1)) {
            self.scrollView.contentOffset = CGPointMake(self.scrollView.frame.size.width * (self.tableViewNum - 1), 0) ;
        }
        if (CGRectGetWidth(self.scrollView.frame)) {
            self.buttonView.selectViewLeadingSpace.constant = scrollView.contentOffset.x * (CGRectGetWidth(btn.frame) / CGRectGetWidth(self.scrollView.frame));
        }
    }
}


#pragma mark - 监听键盘
- (void)keyBoardDidShow:(NSNotification *)notification
{
    NSDictionary * keyboardInfo = [notification userInfo];
    NSValue * keyboardFrameEnd  = [keyboardInfo valueForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardFrameEndRect = [keyboardFrameEnd CGRectValue];
    
    CGFloat   YY =  self.view.frame.size.height -keyboardFrameEndRect.size.height -50;
    
    if (self.isOrientationLandscape==NO){
        
        
        self.onlineLabel.frame = CGRectMake(self.view.frame.size.width - 65, YY-50, 65, 25);
    }
    
    //开启了评分
    if(self.isScore){
        
        CGFloat Y =  viewSize.height -  keyboardFrameEndRect.size.height -self.ScoreView.evaluateFrame.size.height+40;
        
        CGFloat H = self.ScoreView.evaluateFrame.size.height;
        CGFloat W = self.ScoreView.evaluateFrame.size.width;
        CGFloat X = self.ScoreView.evaluateFrame.origin.x;
        
        
        self.ScoreView.tempEvaluateFrame = self.ScoreView.evaluateFrame;
        self.ScoreView.evaluate.frame = CGRectMake(X, Y, W, H );
        
        
    }
    
    self.chatTFView.frame = CGRectMake(0, YY, CGRectGetWidth(self.scrollView.frame), 50);
    self.askTFView.frame = CGRectMake(0, YY, CGRectGetWidth(self.scrollView.frame), 50);
    
    //160
    self.longTextfieldView.frame = CGRectMake(0, self.pptView.frame.size.height -keyboardFrameEndRect.size.height-50 -2, CGRectGetWidth(self.pptView.frame), 50);
    
}
- (void)keyBoardDidHide:(NSNotification *)notification
{
    //开启了评分
    if(self.isScore){
        if( self.ScoreView.tempEvaluateFrame.size.width>0){
            self.ScoreView.evaluate.frame  =  self.ScoreView.tempEvaluateFrame;
        }
        
    }
    
    self.chatTFView.frame = CGRectMake(0, self.view.frame.size.height -50, CGRectGetWidth(self.scrollView.frame), 50);
    
    self.askTFView.frame =  CGRectMake(0, CGRectGetHeight(self.view.frame)-50, CGRectGetWidth(self.scrollView.frame), 50);
    
    self.longTextfieldView.frame = CGRectMake(0, self.pptView.frame.size.height -50 -2, CGRectGetWidth(self.pptView.frame)-160, 50);
}
//longTF与chatTF切换
- (void)infoAction:(NSNotification *)notification
{
    id obj = notification.object;
    if (obj != self.chatTFView.tf && obj != self.longTextfieldView.tf && obj != _longCoverTFView.tf) {
        return;
    }
    if (self.chatTFView.tf == obj) {
        if (self.chatTFView.tf.text.length != 0) {
            [self.chatTFView showSendButton:YES];
        }else{
            [self.chatTFView showSendButton:NO];
        }
        self.longTextfieldView.tf.text = self.chatTFView.tf.text;
        _longCoverTFView.tf.text = self.chatTFView.tf.text;
    }else if (_longCoverTFView.tf == obj){
        if (_longCoverTFView.tf.text.length != 0) {
            [_longCoverTFView showSendButton:YES];
            [self.chatTFView showSendButton:YES];
        }else{
            [_longCoverTFView showSendButton:NO];
            [self.chatTFView showSendButton:NO];
        }
        self.chatTFView.tf.text = _longCoverTFView.tf.text;
        self.longTextfieldView.tf.text = _longCoverTFView.tf.text;
    }else{
        self.chatTFView.tf.text = self.longTextfieldView.tf.text;
        _longCoverTFView.tf.text = self.chatTFView.tf.text;
    }
}

#pragma mark - 旋转
- (BOOL)shouldAutorotate{
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    if (self.isOrientationLandscape) {
        return UIInterfaceOrientationMaskLandscapeRight;
    }
    return UIInterfaceOrientationMaskPortrait;
}

//加载数据
- (void)loadData:(NSString *)data
{
    if (self.pptsFunctionView.danmuBtn.selected) {
        return;
    }
    ColorArray
    UIColor *tempColor = TempColor;
    [self.barrageRender initWithContent:data ontOfSize:14 textColor:tempColor];
    
}

#pragma mark - alertView delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView == _forceoutAlertView){ //被迫下线
        if (buttonIndex == 1) {
            [self refresh];
        }else if (buttonIndex == 0){
            [self quit];
        }
    }else if (alertView == _kickoutAlertView){ //被提出房间
        if (buttonIndex == 0) {
            [self quit];
        }
    }
}

- (void)quit{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    });
    
    if (self.isOrientationLandscape) {
        [UIApplication sharedApplication].statusBarOrientation = UIInterfaceOrientationPortrait;
    }

    [self timerInvalidate];
    [self.talkfunSDK destroy];
    
    QUITCONTROLLER(self)
}

#pragma mark - 上传视频进度到后台
- (void)uploadProgress {
    
    NSDictionary *dic = @{@"type":@"2",@"product_id":self.videoItem.product_id,@"live_id":self.videoItem.live_id,@"time":[NSString stringWithFormat:@"%ld",(long)self.liveTime],@"total_time":@"0"};
    [[NetworkManager sharedManager] postJSON:URL_LiveProgress parameters:dic imageDataArr:nil imageName:nil completion:^(id responseData, RequestState status, NSError *error) {
        if (status == Request_Success) {
            
        }
    }];
}

- (void)timerInvalidate
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.layerTimer invalidate];
        _layerTimer = nil;
        
        [self.layer removeFromSuperlayer];
        self.layer = nil;
        [self.dismissTimer invalidate];
        _dismissTimer = nil;
    });
    
}
- (void)refresh{
    
    [self.talkfunSDK reload];
}

#pragma mark - textfield delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField == self.chatTFView.tf) {
        [self expressionsViewShow:NO];
        [self.chatTFView expressionBtnSelected:NO];
    }else if (textField == self.longTextfieldView.tf){
        [self expressionsViewShow:NO];
        self.inputBackgroundView.hidden = NO;
        [self.longTextfieldView expressionBtnSelected:NO];
    }else if (textField == _longCoverTFView.tf){
        [self expressionsViewShow:NO];
        [_longCoverTFView expressionBtnSelected:NO];
        CGRect frame = _longCoverTFView.frame;
        frame.origin.x = 0;
        frame.size.width = viewSize.width;
        _longCoverTFView.frame = frame;
        //        _longCoverTFView.frame = CGRectMake(0, CGRectGetMaxY(self.scrollView.frame)-CGRectGetHeight(self.chatTFView.frame), viewSize.width, CGRectGetHeight(self.chatTFView.frame));
    }
    return YES;
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    if (textField == self.longTextfieldView.tf) {
        self.inputBackgroundView.hidden = YES;
    }
    else if (textField == _longCoverTFView.tf){
        CGRect frame = _longCoverTFView.frame;
        frame.origin.x = CGRectGetMaxX(self.pptView.frame);
        frame.size.width = CGRectGetWidth(self.scrollView.frame);
        _longCoverTFView.frame = frame;
        //        _longCoverTFView.frame = CGRectMake(CGRectGetMaxX(self.pptView.frame), CGRectGetMaxY(self.scrollView.frame)-CGRectGetHeight(self.chatTFView.frame), CGRectGetWidth(self.scrollView.frame), CGRectGetHeight(self.chatTFView.frame));
    }
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (string.length == 0) {
        NSDictionary * textMessage = GetTextMessage(textField.text);
        BOOL match = [textMessage[@"match"] boolValue];
        if (match) {
            NSRange range = NSRangeFromString(textMessage[@"range"]);
            textField.text = [textField.text stringByReplacingCharactersInRange:range withString:string];
            return NO;
        }
    }
    return YES;
}


- (void)dealloc{
    onceToken = 0;
    
}

#pragma mark - 懒加载
//MARK:scrollView及其上面的东西
- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initScrollViewWithTarget:self frame:CGRectMake(0, CGRectGetMaxY(self.pptView.frame) + ButtonViewHeight, viewSize.width, viewSize.height - CGRectGetMaxY(self.pptView.frame) - ButtonViewHeight)];
        _scrollView.delegate = self;
        _scrollView.backgroundColor = DARKBLUECOLOR;
    }
    return _scrollView;
}
- (UIView *)shadowView{
    if (!_shadowView) {
        _shadowView = [[UIView alloc] initShadowViewWithFrame:self.scrollView.frame];
    }
    return _shadowView;
}
- (TalkfunButtonView *)buttonView{
    if (!_buttonView) {
        _buttonView = [TalkfunButtonView initView];
        [_buttonView buttonsAddTarget:self action:@selector(btnViewButtonsClicked:)];
        _buttonView.frame = CGRectMake(0, CGRectGetMaxY(self.pptView.frame) - 1, viewSize.width, ButtonViewHeight);
        [_buttonView selectButton:_buttonView.chatBtn];
    }
    return _buttonView;
}

- (TalkfunNewTextfieldView *)chatTFView{
    if (!_chatTFView) {
        _chatTFView = [TalkfunNewTextfieldView initView];
        _chatTFView.frame = CGRectMake(0, CGRectGetHeight(self.view.frame)-50, CGRectGetWidth(self.scrollView.frame), 50);
        [_chatTFView createChatTFView:self action:@selector(chatButtonClicked:)];
        [_chatTFView.expressionButton addTarget:self action:@selector(expressionsBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        _chatTFView.userInteractionEnabled = NO;
    }
    return _chatTFView;
}
- (TalkfunTextfieldView *)askTFView{
    if (!_askTFView) {
        _askTFView = [[NSBundle mainBundle] loadNibNamed:@"TalkfunTextfieldView" owner:nil options:nil][0];
        _askTFView.frame = CGRectMake(0, CGRectGetHeight(self.view.frame) - 50, CGRectGetWidth(self.scrollView.frame), 50);
        [_askTFView createAskTFView:self action:@selector(askButtonClicked:)];
        _askTFView.myTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"我要提问..." attributes:@{NSForegroundColorAttributeName: LIGHTBLUECOLOR}];
    }
    return _askTFView;
}
- (TalkfunNewTextfieldView *)longCoverTFView{
    if (!_longCoverTFView && IsIPAD) {
        _longCoverTFView = [TalkfunNewTextfieldView initView];
        _longCoverTFView.tag = 866;
        [_longCoverTFView createChatTFView:self action:@selector(chatButtonClicked:)];
        [_longCoverTFView.expressionButton addTarget:self action:@selector(expressionsBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        _longCoverTFView.tf.text = self.chatTFView.tf.text;
        [_longCoverTFView flower:self.chatTFView.hasFlower number:0];
    }
    return _longCoverTFView;
}
- (TalkfunExpressionViewController *)expressionViewVC{
    if (!_expressionViewVC) {
        WeakSelf
        _expressionViewVC = [[TalkfunExpressionViewController alloc] init];
        __weak typeof(_longCoverTFView) weakLongCoverTFView = _longCoverTFView;
        _expressionViewVC.expressionBlock = ^(NSString * expressionName){
            if ([expressionName isEqualToString:@"delete"]) {
                if (weakSelf.longTextfieldView.tf.text.length != 0) {
                    NSDictionary * textMessage = GetTextMessage(weakSelf.longTextfieldView.tf.text);
                    NSRange range = NSRangeFromString(textMessage[@"range"]);
                    if (range.length==weakSelf.chatTFView.tf.text.length) {
                        [weakSelf.chatTFView showSendButton:NO];
                    }
                    weakSelf.longTextfieldView.tf.text = [weakSelf.longTextfieldView.tf.text stringByReplacingCharactersInRange:range withString:@""];
                    weakSelf.chatTFView.tf.text = [weakSelf.chatTFView.tf.text stringByReplacingCharactersInRange:range withString:@""];
                    weakLongCoverTFView.tf.text = [weakLongCoverTFView.tf.text stringByReplacingCharactersInRange:range withString:@""];
                }else{
                    [weakSelf.chatTFView showSendButton:NO];
                }
            }else{
                TalkfunNewTextfieldView * longView = [weakSelf.view viewWithTag:866];
                weakSelf.longTextfieldView.tf.text = [NSString stringWithFormat:@"%@[%@]",weakSelf.longTextfieldView.tf.text,expressionName];
                weakSelf.chatTFView.tf.text = weakSelf.longTextfieldView.tf.text;
                [weakSelf.chatTFView showSendButton:YES];
                if (longView) {
                    longView.tf.text = weakSelf.chatTFView.tf.text;
                    [longView showSendButton:YES];
                }
            }
        };
        //        _expressionViewVC.view.hidden = YES;
    }
    return _expressionViewVC;
}
//MARK:滚动通知的整条东西
- (TalkfunHornView *)hornView
{
    if (!_hornView) {
        _hornView = [[NSBundle mainBundle] loadNibNamed:@"TalkfunHornView" owner:nil options:nil][0];
        _hornView.frame = CGRectMake(0, CGRectGetMaxY(self.pptView.frame) - 25, CGRectGetWidth(self.pptView.frame), 25);
        _hornView.hidden = YES;
    }
    return _hornView;
}
//ppt信息及按钮
- (TalkfunNewFunctionView *)pptsFunctionView{
    if (!_pptsFunctionView) {
        _pptsFunctionView = [TalkfunNewFunctionView initView];
        _pptsFunctionView.frame = CGRectMake(0, 0, CGRectGetWidth(self.pptView.frame), CGRectGetHeight(self.pptView.frame));
        [_pptsFunctionView buttonsAddTarget:self action:@selector(pptsFunctionButtonClicked:)];
        _pptsFunctionView.hidden = YES;
        
        self.longTextfieldView.frame = CGRectMake(0, CGRectGetHeight(self.pptView.frame)-50 -2, CGRectGetWidth(self.pptView.frame)-160, 50);
        [self.pptsFunctionView addSubview:self.longTextfieldView];
        WeakSelf
        _pptsFunctionView.definitionBlock = ^(NSString *definition){
            
            //设置清晰度
            [weakSelf.talkfunSDK setVideoDefinition:definition];
            
        };
        
    }
    return _pptsFunctionView;
}
- (TalkfunLongTextfieldView *)longTextfieldView{
    if (!_longTextfieldView) {
        _longTextfieldView = [TalkfunLongTextfieldView initView];
        [_longTextfieldView.sendBtn addTarget:self action:@selector(chatButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_longTextfieldView.expressionBtn addTarget:self action:@selector(expressionsBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        _longTextfieldView.tf.delegate = self;
        _longTextfieldView.hidden = YES;
        _longTextfieldView.backgroundColor = [UIColor clearColor];
        _longTextfieldView.tf.backgroundColor = [UIColor clearColor];
    }
    return _longTextfieldView;
}

- (HYAlertView*)alertContent:(NSString*)content {
    HYAlertView *alert = [[HYAlertView alloc]init];
    [alert presentViewController:self content:content  actionWithTitle:@"确定"];
    return alert;
}

- (void)pptsFunctionButtonClicked:(UIButton *)btn {
    NSLog(@"____click %ld____",(long)btn.tag);
    //返回按钮
    if (btn.tag == returnButton) {
        if ([AppChannel isEqualToString:@"1"]
            && self.is_review == NO
            && [self.videoItem.type isEqualToString:@"3"]
            && self.liveTime>=30*60) { //超职、回放/直播
            [self.commentView showView];
        } else {
            WeakSelf
            HYAlertView *alert =  [self alertContent: @"确定要退出直播间吗"];
#pragma mark - ---超职修改
            alert.isOrientationLandscape = NO;
#pragma mark - 超职修改---
            alert.clickEventBlock =^(NSString *title){
                
                if ([title isEqualToString:@"确定"]) {
                    [weakSelf quit];
                }
            };
        }
    }
    //隐藏camera按钮
    else if (btn.tag == hiddenCameraButton){
        if (self.unStart || self.isDesktop) {
            return;
        }
        
        if(!self.cameraShow)
        {
            return;
        }
        btn.selected = !btn.selected;
        if (btn.selected) {
            if (self.talkfunSDK.isExchanged) {
                [self.talkfunSDK exchangePPTAndCameraContainer];
            }
            self.cameraView.hidden = YES;
            [btn setImage:[UIImage imageNamed:@"关闭摄像头"] forState:UIControlStateNormal];
            //            [self.talkfunSDK hideCamera];
        }else{
            if (self.talkfunSDK.isExchanged) {
                [self.talkfunSDK exchangePPTAndCameraContainer];
            }
            self.cameraView.hidden = NO;
            [btn setImage:[UIImage imageNamed:@"开启摄像头"] forState:UIControlStateNormal];
            //            [self.talkfunSDK showCamera];
        }
        if (IsIPAD && self.isOrientationLandscape && !self.pptsFunctionView.fullScreenBtn.selected) {
            [self reloadScrollView:btn.selected];
        }
    }
    //切换ppt和camera
    else if (btn.tag == statusSwitchingButton)
    {
        if (self.cameraView.hidden) {
            return;
        }
        [self.talkfunSDK exchangePPTAndCameraContainer];
        
        [self updateChrysanthemum];
    }
    //刷新
    else if (btn.tag == refreshButton){
        [self refresh];
    }
    //网络选择按钮
    else if (btn.tag == networkSelectionButton){
        if (self.unStart) {
            [self.view toast:@"直播未开始" position:ToastPosition];
            return;
        }
    
        WeakSelf
        [self.talkfunSDK getNetworkList:^(id result) {
            
            if ([result[@"code"] intValue] == TalkfunCodeSuccess) {
                
                //判断如果是直播
                if ([result[@"isVodLive"] intValue ]==0)
                {
                    //默认的ip数据
                    weakSelf.networkSelectionVC.network = result[@"network"];
                    weakSelf.networkSelectionVC.networkSelectionArray = result[@"data"];
                    if ( weakSelf.networkSelectionVC.networkSelectionArray.count<=0) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [weakSelf.view toast:@"该课程当前无线路切换"  position:ToastPosition];
                            
                        });
                        
                        
                        return ;
                    }
                    
                    PERFORM_IN_MAIN_QUEUE(
                                          //TODO:网络选择控制器
                                          [weakSelf.view addSubview:weakSelf.networkSelectionVC.view];
                                          )
                    
                    
                    
                }
                
                //判断如果是伪直播
                else{
                    
                    UIView * view = [[UIApplication sharedApplication].keyWindow viewWithTag:123];
                    if (!view) {
                        
                        //TODO:线路选择
                        TalkfunNetworkLines * networkLinesView = [[NSBundle mainBundle] loadNibNamed:@"TalkfunNetworkLines" owner:nil options:nil][0];
                        networkLinesView.tag = 123;
                        
                        
                        networkLinesView.networkLinesArray = result[@"data"][@"operators"];
                        
                        networkLinesView.frame = CGRectMake(0, 0, viewSize.width, viewSize.height);
                        WeakSelf
                        networkLinesView.networkLineBlock = ^(NSNumber * networkLineIndex){
                            [weakSelf.talkfunSDK  setNetwork:nil selectedSegmentIndex:[networkLineIndex intValue]];
                            
                        };
                        PERFORM_IN_MAIN_QUEUE(
                                              [weakSelf.view addSubview:networkLinesView];
                                              )
                    }
                    
                    
                }
                
                
            }else{
                [weakSelf.view toast:result[@"msg"] position:ToastPosition];
            }
            
            
        }];
        
        
        
        
    }
    //弹幕
    else if (btn.tag == barrageButton){
        
        //申请上讲台
        //        [self podiumApply];
        btn.selected = !btn.selected;
        if (!btn.selected) {
            [btn setImage:[UIImage imageNamed:@"开启弹幕"] forState:UIControlStateNormal];
            
            self.barrageRender.bulletSwitch = YES;
        }else{
            [btn setImage:[UIImage imageNamed:@"关闭弹幕"] forState:UIControlStateNormal];
            
            self.barrageRender.bulletSwitch = NO;
        }
    }
    //全屏按钮
    else if (btn.tag == fullScreenButton){
        //        self.expressionsView.hidden = YES;
        //        self.expressionsView2.hidden = YES;
        //        if ([DEVICEMODEL hasPrefix:@"iPad"]) {
        if (btn.selected == NO && self.isOrientationLandscape) {
            [self manualFullScreen:YES];
        }else if (btn.selected == YES && fromLandscape == YES){
            [self manualFullScreen:NO];
        }else{
            self.iPadAutoRotate = NO;
            [self fullScreen];
        }
        //        }
    }
    //清晰度选择
    else if (btn.tag == smoothButton){
        
        NSArray *array =   [self.talkfunSDK getVideoDefinitionList];
        NSLog(@"%@",array);
        
        [self.pptsFunctionView setVideoDefinition:array];
    }
    
}
- (void)reloadScrollView:(BOOL)cameraHide{
    [UIView animateWithDuration:0.25 animations:^{
        CGRect buttonViewFrame = self.buttonView.frame;
        buttonViewFrame.origin.y = cameraHide?0:CGRectGetMaxY(self.cameraView.frame);
        self.buttonView.frame = buttonViewFrame;
        
        //修改scrollView的frame和contentSize
        self.scrollView.frame = CGRectMake(CGRectGetMaxX(self.pptView.frame), CGRectGetMaxY(self.buttonView.frame), self.view.bounds.size.width - CGRectGetMaxX(self.pptView.frame), self.view.bounds.size.height - CGRectGetMaxY(self.buttonView.frame));
        self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.scrollView.frame) * self.tableViewNum, CGRectGetHeight(self.scrollView.frame));
        //        self.scrollView.contentOffset = CGPointMake(0, 0);
        
        //修改tableView的frame和刷新tableView
        for (int i = 0; i < self.tableViewNum; i ++) {
            UIView * tableView = (UIView *)[self.scrollView viewWithTag:300 + i];
            tableView.frame    = CGRectMake(i * self.scrollView.frame.size.width, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height - 50);
            if (i == 2) {
                tableView.frame = CGRectMake(i * self.scrollView.frame.size.width, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height);
            }
            id tableViewV = tableView.nextResponder;
            RootTableViewController * tableViewVC = tableViewV;
            [tableViewVC recalculateCellHeight];
        }
        self.shadowView.frame = self.scrollView.frame;
        
        //修改chatTF和askTF的frame
        self.chatTFView.frame = CGRectMake(0, CGRectGetHeight(self.view.frame) - 50, CGRectGetWidth(self.scrollView.frame), 50);
        self.askTFView.frame = CGRectMake(CGRectGetWidth(self.view.frame), CGRectGetHeight(self.scrollView.frame) - 50, CGRectGetWidth(self.scrollView.frame), 50);
        
        //改变输入框下划线长度
        [self.askTFView askTFFrameChanged];
    }];
}
static BOOL fromLandscape = NO;
- (void)manualFullScreen:(BOOL)fullScreen{
    [self removeNetworkTipsView];
    [self removeReplyTipsView];
    fromLandscape = fullScreen;
    [UIView animateWithDuration:0.25 animations:^{
        self.buttonView.hidden = fullScreen;
        self.scrollView.hidden = fullScreen;
        self.shadowView.hidden = fullScreen;
        
        self.pptView.frame = fullScreen?CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height):CGRectMake(0, 0, self.view.bounds.size.width * 7 / 10, self.view.bounds.size.height);
        self.longTextfieldView.frame = CGRectMake(0, CGRectGetHeight(self.pptView.frame)-50-2, CGRectGetWidth(self.pptView.frame)-160, 50);
        self.inputBackgroundView.frame = self.view.bounds;
        self.longTextfieldView.hidden = !fullScreen;
        self.expressionViewVC.view.frame = CGRectMake(0, viewSize.height, viewSize.width,ExpressionViewHeight());
        
        //改变喇叭滚动条的frame
        self.hornView.frame = CGRectMake(0, CGRectGetMaxY(self.pptView.frame) - 25, CGRectGetWidth(self.pptView.frame), 25);
        
        //加动画
        [self.hornView rollLabelAddAnimation];
        
        //修改摄像头的frame
        //        self.cameraView.transform = CGAffineTransformIdentity;
        self.cameraView.frame = !fullScreen?CGRectMake(CGRectGetMaxX(self.pptView.frame), 0, CGRectGetWidth(self.view.bounds)-CGRectGetWidth(self.pptView.frame), (viewSize.width-CGRectGetWidth(self.pptView.frame))*3.0/4.0):CGRectMake(CGRectGetMaxX(self.pptView.frame) - CGRectGetHeight(self.view.bounds)*3.0/10.0, CGRectGetMaxY(self.pptView.frame)-50-(CGRectGetHeight(self.view.bounds)*3.0/10.0)*3.0/4.0, CGRectGetHeight(self.view.bounds)*3.0/10.0, (CGRectGetHeight(self.view.bounds)*3.0/10.0)*3.0/4.0);
        
        self.buttonView.frame = CGRectMake(CGRectGetMaxX(self.pptView.frame), self.cameraView.hidden?0:CGRectGetMaxY(self.cameraView.frame), viewSize.width-CGRectGetWidth(self.pptView.frame), ButtonViewHeight);
    }];
    self.pptsFunctionView.fullScreenBtn.selected = fullScreen;
    [self.pptsFunctionView.fullScreenBtn setImage:[UIImage imageNamed:fullScreen?@"退出全屏":@"全屏"] forState:UIControlStateNormal];
    CGRect frame = _longCoverTFView.frame;
    frame.origin.x = CGRectGetMaxX(self.pptView.frame);
    _longCoverTFView.frame = frame;
    _longCoverTFView.hidden = fullScreen;
    
    if(self.disableAll ==YES){
        [self setWordsNotAllowed];
    }else{
        [self setWordsAllowed];
    }
}
- (void)fullScreen{
    [self expressionsViewShow:NO];
    [self.view endEditing:YES];
    
    if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait) {
        self.onlineLabel.hidden = YES;
#pragma mark - ---超职修改
        NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeRight];
        [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
#pragma mark - 超职修改---
        self.pptsFunctionView.fullScreenBtn.selected = YES;
        [self.pptsFunctionView.fullScreenBtn setImage:[UIImage imageNamed:@"退出全屏"] forState:UIControlStateNormal];
        [self orientationLandscape];
        
    }else{
        if( self.onlineLabel.text.length>0){
            self.onlineLabel.hidden = NO;
        }
#pragma mark - ---超职修改
        NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
        [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
#pragma mark - 超职修改---
        self.pptsFunctionView.fullScreenBtn.selected = NO;
        [self.pptsFunctionView.fullScreenBtn setImage:[UIImage imageNamed:@"全屏"] forState:UIControlStateNormal];
        [self orientationPortrait];
        
    }
    self.iPadAutoRotate = YES;
    
    if(self.disableAll ==YES){
        [self setWordsNotAllowed];
    }else{
        [self setWordsAllowed];
    }
}

- (UIAlertView *)quitAlertView{
    if (!_quitAlertView) {
        _quitAlertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定要退出吗" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    }
    return _quitAlertView;
}

//网络选择懒加载
- (NetworkSelectionViewController *)networkSelectionVC
{
    if (_networkSelectionVC == nil) {
        _networkSelectionVC = [[NetworkSelectionViewController alloc] init];
        _networkSelectionVC.view.frame = self.view.frame;
        WeakSelf
        _networkSelectionVC.networkOperators = ^(NSDictionary *str){
            
            [weakSelf.talkfunSDK setNetwork:str[@"operatorID"]  selectedSegmentIndex:[str[@"selectedSegmentIndex"] integerValue]];
        };
        
        
        
    }
    return _networkSelectionVC;
}
//投票
- (NSMutableDictionary *)voteNewDict
{
    if (!_voteNewDict) {
        _voteNewDict =  [NSMutableDictionary new];
    }
    return _voteNewDict;
}
- (NSMutableDictionary *)votePubDict
{
    if (!_votePubDict) {
        _votePubDict = [NSMutableDictionary new];
    }
    return _votePubDict;
}
- (NSMutableArray *)voteFinishArray
{
    if (!_voteFinishArray) {
        _voteFinishArray = [NSMutableArray new];
    }
    return _voteFinishArray;
}
- (VoteViewController *)voteVC
{
    if (!_voteVC) {
        _voteVC = [VoteViewController new];
        _voteVC.view.frame = self.view.frame;
        WeakSelf
        _voteVC.voteBlock = ^(NSString *vid,NSArray *optionsArray){
            
            [weakSelf.voteVC.view removeFromSuperview];
            
            NSMutableString * arrString = [NSMutableString new];
            [arrString appendString:@"["];
            if (optionsArray.count == 1) {
                [arrString appendFormat:@"%@]",optionsArray[0]];
            }else
            {
                NSString * composeStr = [optionsArray componentsJoinedByString:@","];
                [arrString appendFormat:@"%@]",composeStr];
            }
            NSDictionary * params = @{@"vid":vid, @"option":arrString};
            [weakSelf.talkfunSDK emit:TALKFUN_EVENT_VOTE_SUBMIT parameter:params callback:^(id obj) {
                PERFORM_IN_MAIN_QUEUE(
                                      if ([obj[@"code"] isEqualToNumber:@(0)]) {
                                          weakSelf.voteEndVC.voteTitle.text = @"投票成功";
                                          weakSelf.voteEndVC.message = @"投票成功";
                                          //已经投票的加入已投票数组
                                          [weakSelf.voteFinishArray addObject:vid];
                                          weakSelf.voteEndVC.statusImageView.image = [UIImage imageNamed:@"tick"];
                                      }else
                                      {
                                          weakSelf.voteEndVC.voteTitle.text = @"投票失败";
                                          if ([obj[@"data"] isKindOfClass:[NSString class]]) {
                                              weakSelf.voteEndVC.message = obj[@"data"];
                                          }else if ([obj[@"msg"] isKindOfClass:[NSString class]]){
                                              weakSelf.voteEndVC.message = obj[@"msg"];
                                          }
                                          weakSelf.voteEndVC.statusImageView.image = [UIImage imageNamed:@"failP"];
                                      }
                                      weakSelf.voteEndVC.view.alpha = 1.0;
                                      [weakSelf.view addSubview:weakSelf.voteEndVC.view];
                                      [weakSelf.voteEndVC refreshUIWithAfterCommitted];
                                      )
            }];
        };
    }
    return _voteVC;
}

- (TalkfunSignViewController*)sign{
    if (_sign==nil) {
        _sign = [[TalkfunSignViewController alloc]init];
        
        WeakSelf
        _sign.signIdBlock = ^(NSString *signId){
            
            NSDictionary *dict = @{@"signId":signId};
            
            
            [weakSelf.talkfunSDK emit:TALKFUN_SIGN_IN parameter:dict callback:^(id obj) {
                
                
                //签到成功
                if ([obj[@"code"] isEqualToNumber:@(0)]) {
                    
                    
                    
                    NSString * message  = [NSString stringWithFormat:@"通知:你已确认签到"];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"broadcastInfo" object:nil userInfo:@{@"vote:pub":message}];
                    
                    [weakSelf.sign deleteClicked];
                }
                
            }];
            
        };
        
        _sign.view.frame = CGRectMake(0, 0, viewSize.width,  viewSize.height);
        [self.view addSubview:_sign.view];
    }
    
    return _sign;
}

- (VoteEndViewController *)voteEndVC
{
    if (!_voteEndVC) {
        _voteEndVC = [VoteEndViewController new];
        _voteEndVC.view.frame = self.view.frame;
    }
    return _voteEndVC;
}

//MARK:抽奖
- (LotteryViewController *)lotteryVC
{
    if (!_lotteryVC) {
        _lotteryVC = [LotteryViewController new];
        _lotteryVC.view.frame = self.view.frame;
    }
    return _lotteryVC;
}
- (MyLotteryViewController *)myLotteryVC
{
    if (!_myLotteryVC) {
        _myLotteryVC = [MyLotteryViewController new];
        _myLotteryVC.view.frame = self.view.frame;
    }
    return _myLotteryVC;
}
//MARK:遮布
- (UIView *)coverView
{
    if (!_coverView) {
        _coverView = [[UIView alloc] initWithFrame:self.view.frame];
        _coverView.backgroundColor = [UIColor whiteColor];
        PERFORM_IN_MAIN_QUEUE(_coverView.hidden = YES;
                              [self.view addSubview:_coverView];)
    }
    return _coverView;
}
//MARK:视频切换、暂停提示
- (UILabel *)tipsLabel
{
    if (!_tipsLabel) {
        _tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMinY(self.pptsFunctionView.frame)+50, 100, 30)];
        _tipsLabel.textColor = [UIColor whiteColor];
        _tipsLabel.backgroundColor = [UIColor redColor];
        _tipsLabel.textAlignment = NSTextAlignmentCenter;
        _tipsLabel.font = [UIFont systemFontOfSize:14];
    }
    return _tipsLabel;
}

//被逼下线
- (UIAlertView *)forceoutAlertView{
    if (!_forceoutAlertView) {
        _forceoutAlertView = [[UIAlertView alloc] initWithTitle:@"你被迫下线了" message:nil delegate:self cancelButtonTitle:@"退出" otherButtonTitles:@"刷新", nil];
    }
    return _forceoutAlertView;
}

//被踢出房间
- (UIAlertView *)kickoutAlertView{
    if (!_kickoutAlertView) {
        _kickoutAlertView = [[UIAlertView alloc] initWithTitle:@"你被踢出房间了" message:nil delegate:self cancelButtonTitle:@"退出" otherButtonTitles:nil, nil];
    }
    return _kickoutAlertView;
}

//MARK:弹幕
- (BulletView *)barrageRender{
    if (!_barrageRender) {
        _barrageRender = [[BulletView alloc]init];
        _barrageRender.bulletSwitch = NO;
        [self.pptView.layer addSublayer:_barrageRender.layer];
    }
    return _barrageRender;
}

//MARK:网络较差提示
- (UIImageView *)networkTipsImageView{
    if (!_networkTipsImageView) {
        CGRect rect = [self.view convertRect:self.pptsFunctionView.networkBtn.frame toView:self.view];
        CGRect frame;
        UIImage * image;
        if (self.isOrientationLandscape) {
            image = [UIImage imageNamed:@"网络提示1"];
            frame = CGRectMake(0, CGRectGetMaxY(rect), 210, 40);
        }else{
            image = [UIImage imageNamed:@"网络提示2"];
            frame = CGRectMake(0, CGRectGetMinY(rect)-40, 210, 40);
        }
        _networkTipsImageView = [[UIImageView alloc] initWithFrame:frame];
        _networkTipsImageView.center = CGPointMake(CGRectGetMidX(rect), _networkTipsImageView.center.y);
        _networkTipsImageView.contentMode = UIViewContentModeScaleAspectFit;
        _networkTipsImageView.image = image;
        UITapGestureRecognizer * tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(networkTipsTap:)];
        [_networkTipsImageView addGestureRecognizer:tapGR];
        _networkTipsImageView.userInteractionEnabled = YES;
    }
    return _networkTipsImageView;
}

- (void)networkTipsTap:(UITapGestureRecognizer *)tapGR{
    [UIView animateWithDuration:0.25 animations:^{
        self.networkTipsImageView.alpha = 0.0;
    }completion:^(BOOL finished) {
        [self removeNetworkTipsView];
    }];
}

- (void)removeNetworkTipsView{
    [_networkTipsImageView removeFromSuperview];
    _networkTipsImageView = nil;
}

- (void)removeReplyTipsView{
    [_replyTipsView removeFromSuperview];
    _replyTipsView = nil;
}

- (UIView *)inputBackgroundView{
    if (!_inputBackgroundView) {
        _inputBackgroundView = [[UIView alloc] initWithFrame:self.pptsFunctionView.frame];
        _inputBackgroundView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        _inputBackgroundView.hidden = YES;
    }
    return _inputBackgroundView;
}

- (TalkfunLoadingView *)loadingView{
    if (!_loadingView) {
        _loadingView = [TalkfunLoadingView initView];
        _loadingView.frame = self.view.bounds;
    }
    return _loadingView;
}

- (TalkfunReplyTipsView *)replyTipsView{
    if (!_replyTipsView) {
        _replyTipsView = [[NSBundle mainBundle] loadNibNamed:@"TalkfunReplyTipsView" owner:nil options:nil][0];
        CGRect frame = CGRectMake(0, CGRectGetHeight(self.view.bounds)-100, CGRectGetWidth(self.view.bounds), 50);
        if (IsIPAD && self.isOrientationLandscape && self.pptsFunctionView.fullScreenBtn.selected == NO) {
            frame = CGRectMake(CGRectGetMaxX(self.pptView.frame), CGRectGetHeight(self.view.bounds)-100, CGRectGetWidth(self.view.bounds)-CGRectGetWidth(self.pptView.frame), 50);
        }
        _replyTipsView.frame = frame;
        [_replyTipsView.tipsButton addTarget:self action:@selector(replyTipsButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        WeakSelf
        _replyTipsView.closeBtnBlock = ^(){
            [weakSelf removeReplyTipsView];
        };
    }
    return _replyTipsView;
}
- (void)replyTipsButtonClicked:(UIButton *)button{
    [self btnViewButtonsClicked:self.buttonView.askBtn];
    [self removeReplyTipsView];
}







- (NSMutableArray  *)videoSessions
{
    if (_videoSessions==nil) {
        _videoSessions = [NSMutableArray array];
    } return _videoSessions;
}



- (TalkfunScoreView*)ScoreView
{
    if(_ScoreView==nil){
        
        _ScoreView = [[TalkfunScoreView alloc]init];
        _ScoreView.frame = CGRectMake(0, 0, viewSize.width, viewSize.height);
        
        WeakSelf
        _ScoreView.currentScoreChangeBlock = ^(NSMutableDictionary* dict){
            //传评价给sdk
            [weakSelf.talkfunSDK sendScore:dict callback:^(id result) {
                
                if ([result[@"code"]  integerValue]==0) {
                    
                    //清除自己;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [weakSelf.view toast:@"评分成功" position:ToastPosition];
                        [weakSelf.ScoreView removeFromSuperview];
                        weakSelf.isScore = NO;
                        _ScoreView = nil;
                        
                    });
                    
                }else if ([result[@"code"]  integerValue]==-1) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [weakSelf.view toast:result[@"msg"]?result[@"msg"] :@"" position:ToastPosition];
                        [weakSelf.ScoreView removeFromSuperview];
                        weakSelf.isScore = NO;
                        _ScoreView = nil;
                        
                    });
                }else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [weakSelf.view toast:result[@"msg"]?result[@"msg"] :@"" position:ToastPosition];
                        
                        
                    });
                    
                }
                //打印提交得分结果
                NSLog(@"currentScoreChangeBlock===>%@",result);
                
            }];
        };
        
        
        //退出
        _ScoreView.exitBlock = ^(NSDictionary *cict){
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.ScoreView removeFromSuperview];
                weakSelf.isScore = NO;
                _ScoreView = nil;
                
            });
            
        };
        
        
        
    }
    return _ScoreView;
}
/** 平移手势响应事件  */
- (void)pptHandlePan:(UIPanGestureRecognizer *)swipe
{
    if (self.bitmapView.hidden == YES) {
        
        
        if (swipe.state == UIGestureRecognizerStateBegan) {
            self.lastVolume = [self.modulation bfGetCurrentVolume];
            
            self.origin = 0;
        }
        
        if (swipe.state == UIGestureRecognizerStateChanged) {
            [self volumeAdjustment:[swipe translationInView:self.view]];
        }
    }
}
/** 判断手势方向  */
- (void)volumeAdjustment:(CGPoint)curP {
    
    NSInteger Y = 0;
    if (curP.y>0) {
        Y =   curP.y -   self.origin;
    }else{
        Y  =  abs((int)curP.y - self.origin);
    }
    
    if (  Y >10) {
        
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
- (TalkfunModulation* )modulation
{
    if (_modulation==nil) {
        _modulation = [TalkfunModulation shared];
    }
    return _modulation;
}
@end

