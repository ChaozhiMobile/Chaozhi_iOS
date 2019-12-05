//
//  XLGExternalTestTool.m
//  SharenGo
//  Notes：
//
//  Created by Jason on 2018/5/10.
//  Copyright © 2018年 小灵狗出行. All rights reserved.
//

#import "XLGExternalTestTool.h"
#import "XLGChangeServerVC.h"
#import "XLGLogVC.h"
#import "XLGInternalTestVC.h"

#define MenuImageName @[@"ChangeServer",@"LogIcon",@"InternetCheckIcon"]
#define Radius 150 //半径
#define SpaceAgle  M_PI/4//60度
#define SpaceOAgle (M_PI/2 - SpaceAgle)//

@interface XLGExternalTestTool()
{
    UIPanGestureRecognizer *panGesture; //拖动手势
    UITapGestureRecognizer *tapGesture; //点击手势
}
@property (nonatomic,retain) UIButton *shadowViewBtn;
@property (nonatomic,retain) UIButton *logShowBtn;

@end

@implementation XLGExternalTestTool

+ (instancetype)shareInstance {
    static XLGExternalTestTool *singleton = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleton = [[XLGExternalTestTool alloc] init];
        singleton.tag = 10001;
    });
    return singleton;
}

- (id)init {
    self = [super init];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)setupView {
    
    self.frame = CGRectMake(0, 0 , WIDTH, HEIGHT);
    self.clipsToBounds = YES;
    _shadowViewBtn = [[UIButton alloc]initWithFrame:self.frame];
    _shadowViewBtn.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.6];
    _shadowViewBtn.clipsToBounds = YES;
    [self addSubview:_shadowViewBtn];
    
    _logShowBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, (HEIGHT-50)/2, 50, 50)];
    [_logShowBtn setImage:[UIImage imageNamed:@"DebugIcon"] forState:UIControlStateNormal];
    _logShowBtn.cornerRadius = 8;
    _logShowBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [_logShowBtn setTitleColor:[UIColor blackColor] forState:0];
    [_logShowBtn addTarget:self action:@selector(showMenuView:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_logShowBtn];

    for (int i=0; i<MenuImageName.count; i++) {
        UIButton *shareBtn = [[UIButton alloc]initWithFrame:CGRectMake((WIDTH-60)/2, 310, 60, 60)];
        shareBtn.center = _logShowBtn.center;
        shareBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [shareBtn setImage:[UIImage imageNamed:MenuImageName[i]] forState:UIControlStateNormal];
        [shareBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        shareBtn.tag=2000+i;
        [shareBtn addTarget:self action:@selector(buttonIndexClick:) forControlEvents:UIControlEventTouchUpInside];
        shareBtn.hidden = YES;
        [self addSubview:shareBtn];
    }
    [_logShowBtn.superview bringSubviewToFront:_logShowBtn];
    
    [self hiddenView];
    
    panGesture=[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePan:)]; //按钮添加拖动手势
    [self setUserInteractionEnabled:YES];//开启图片控件的用户交互
    [self addGestureRecognizer:panGesture];//给图片添加手势
    
   [self addPanGestureRecognizer];
    _shadowViewBtn.enabled = YES;
    
    _logTextViews = [[UITextView alloc]initWithFrame:CGRectMake(15, 30, WIDTH-30, HEIGHT-60)];
}

- (void)addPanGestureRecognizer{
    panGesture=[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePan:)]; //按钮添加拖动手势
    [self addGestureRecognizer:panGesture];//给图片添加手势
}

- (void)addTapGestureRecognizer{
    tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hiddenAllView)];
    [self addGestureRecognizer:tapGesture];//给图片添加手势
}

- (void)hiddenAllView{
    [self showMenuView:_logShowBtn];
}

-(void)handlePan:(UIPanGestureRecognizer *)rec {
    
    //返回在横坐标上、纵坐标上拖动了多少像素
    CGPoint point=[rec translationInView:self];
    rec.view.center=CGPointMake(rec.view.center.x+point.x, rec.view.center.y+point.y);
    //拖动完之后，每次都要用setTranslation:方法制0这样才不至于不受控制般滑动出视图
    [rec setTranslation:CGPointMake(0, 0) inView:self];
}

- (void)buttonIndexClick:(UIButton *)sender {
    
    [self showMenuView:_logShowBtn];
    
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    //如果window已有弹出的视图，会导致界面无法弹出，页面卡死，这里需要先把视图关闭，再弹出
    if (keyWindow.rootViewController.presentedViewController != nil) {
        [keyWindow.rootViewController dismissViewControllerAnimated:NO completion:nil];
    }
    
    switch (sender.tag) {
        case 2000: //环境切换
        {
            XLGChangeServerVC *vc = [[XLGChangeServerVC alloc] init];
            vc.modalPresentationStyle = UIModalPresentationFullScreen;
            [keyWindow.rootViewController presentViewController:vc animated:NO completion:nil];
        }
            break;
        case 2001: //接口日志
        {
            XLGLogVC *vc = [[XLGLogVC alloc] init];
            vc.modalPresentationStyle = UIModalPresentationFullScreen;
            [keyWindow.rootViewController presentViewController:vc animated:NO completion:nil];
        }
            break;
        case 2002://内部测试
        {
            XLGInternalTestVC *vc = [[XLGInternalTestVC alloc] init];
            vc.modalPresentationStyle = UIModalPresentationFullScreen;
            [keyWindow.rootViewController presentViewController:vc animated:NO completion:nil];
        }
            break;
            
        default:
        
            break;
    }
}

- (void)hiddenView {
    __weak typeof(self) weakSelf = self;
    
    [UIView animateWithDuration:0.2 animations:^{
        weakSelf.shadowViewBtn.alpha = 0.0;
    } completion:^(BOOL finished) {
        self.frame = CGRectMake(-25, (HEIGHT-50)/2, 50, 50);
        weakSelf.logShowBtn.top = 0;
        weakSelf.shadowViewBtn.hidden = YES;
    }];
    [self removeGestureRecognizer:tapGesture];
    [self addPanGestureRecognizer];
}

- (void)showCurrentView {
    __weak typeof(self) weakSelf = self;
    self.frame = CGRectMake(0, 0, WIDTH, HEIGHT);
    _logShowBtn.top = (HEIGHT-_logShowBtn.height)/2.0;
    _shadowViewBtn.alpha = 0.0;
    _shadowViewBtn.hidden = NO;
    [UIView animateWithDuration:0.2 animations:^{
        weakSelf.shadowViewBtn.alpha = 1.0;
    } completion:^(BOOL finished) {
        
    }];
    [self removeGestureRecognizer:panGesture];
    [self addTapGestureRecognizer];
}

- (void)showMenuView:(UIButton *)sender {
    sender.userInteractionEnabled = NO;
    if (!_logShowBtn.selected) {
        [self showCurrentView];
        [self extandShapeView];
        _shadowViewBtn.enabled = NO;
    } else {
        [self drawBackShapView];
        _shadowViewBtn.enabled = YES;
        [self hiddenView];
    }
    [self performSelector:@selector(operateView) withObject:nil afterDelay:0.3f];//防止用户重复点击
}

- (void)operateView {
    _logShowBtn.userInteractionEnabled = YES;
    _logShowBtn.selected = !_logShowBtn.selected;
}

/** 展开*/
-(void)extandShapeView {
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.logShowBtn.transform = CGAffineTransformMakeRotation(M_PI_2);
        weakSelf.logShowBtn.top = (HEIGHT-weakSelf.logShowBtn.height)/2.0;
        CGPoint center = weakSelf.logShowBtn.center;
        for (int i=0; i<MenuImageName.count; i++) {
            UIButton *shareBtn = [self viewWithTag:2000+i];
            shareBtn.hidden = NO;
            CGPoint btnCenter = CGPointMake(center.x+sinf(SpaceOAgle+SpaceAgle*i)*Radius, center.y-cosf(SpaceOAgle+SpaceAgle*i)*Radius);
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(i*0.05*NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.4 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                    shareBtn.center=btnCenter;
                    shareBtn.transform=CGAffineTransformIdentity;
                    [self drawLineView:weakSelf.logShowBtn.center WithEndPoint:shareBtn.center];
                    [shareBtn.superview bringSubviewToFront:shareBtn];
                    [weakSelf.logShowBtn.superview bringSubviewToFront:weakSelf.logShowBtn];
                } completion:^(BOOL finished) {
                    
                }];
            });
        }
    }];
}

-(void)drawBackShapView {
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.logShowBtn.transform = CGAffineTransformIdentity;
        
        CGPoint center = weakSelf.logShowBtn.center;
        for (int i=0; i<MenuImageName.count; i++) {
            UIButton *shareBtn = [self viewWithTag:2000+i];
            shareBtn.hidden = NO;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(i*0.05*NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [UIView animateWithDuration:0.2 animations:^{
                    shareBtn.center=center;
                    shareBtn.transform=CGAffineTransformMakeRotation(M_PI_4);
                } completion:^(BOOL finished) {
                    shareBtn.hidden = YES;
                }];
            });
        }
        [weakSelf.logShowBtn.superview bringSubviewToFront:weakSelf.logShowBtn];
    }];
}

- (void)drawLineView:(CGPoint)startPoint WithEndPoint:(CGPoint)endPoint {
    // 线的路径
    UIBezierPath *linePath = [UIBezierPath bezierPath];
    // 起点
    [linePath moveToPoint:startPoint];
    // 其他点
    //    [linePath addLineToPoint:CGPointMake(160, 160)];
    [linePath addLineToPoint:endPoint];
    
    CAShapeLayer *lineLayer = [CAShapeLayer layer];
    
    lineLayer.lineWidth = 1;
    lineLayer.strokeColor = [UIColor colorWithWhite:1.0 alpha:0.3].CGColor;
    lineLayer.path = linePath.CGPath;
    lineLayer.fillColor = nil; // 默认为blackColor
    
    [self.layer addSublayer:lineLayer];
}

@end
