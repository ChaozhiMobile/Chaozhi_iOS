//
//  CZCommentView.m
//  Chaozhi
//
//  Created by zhanbing han on 2019/8/19.
//  Copyright © 2019 Jason_hzb. All rights reserved.
//

#import "CZCommentView.h"
#import "CZStarView.h"
#import "XLGCustomButton.h"

@interface CZCommentView()
{
    UIView *bgWhiteView;
    UILabel *_titleLab;
    UILabel *pointLab;
    UIView *shadowView;
    NSInteger lineCount;
    NSMutableDictionary *singleButtonDic;
    UIButton *_closeBtn;
    UIButton *submitBtn;
}
/** 选中的数据 */
@property (nonatomic,retain) NSMutableDictionary *selectDic;
@end

CZCommentView *singleton;
static dispatch_once_t onceToken;// 这个拿到函数体外,成为全局的.

@implementation CZCommentView

+ (CZCommentView *)sharedInstance {
    // dispatch_once 无论使用多线程还是单线程，都只执行一次
    dispatch_once(&onceToken, ^{
        singleton = [[CZCommentView alloc] init];
    });
    return singleton;
}

- (instancetype)initWithFrame:(CGRect)frame {
    CGRect rect = CGRectMake(0, 0, WIDTH, HEIGHT);
    self = [super initWithFrame:rect];
    if (self) {
        [self setupData];
        [self refreshUI];
    }
    return self;
}

- (void)setupData {
    lineCount = 3 ;
    singleButtonDic = [NSMutableDictionary dictionary];
    _selectDic = [NSMutableDictionary dictionary];
}

- (void)refreshUI {
    self.hidden = YES;
    self.layer.zPosition = 2000;
    shadowView = [[UIView alloc]initWithFrame:self.bounds];
    shadowView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.7];
    [self addSubview:shadowView];
    
    bgWhiteView = [[UIView alloc]initWithFrame:CGRectMake(0, HEIGHT-autoScaleW(250), self.width, HEIGHT/3*2)];
    bgWhiteView.backgroundColor = [UIColor whiteColor];
    [self addSubview:bgWhiteView];
    
    _titleLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.width, autoScaleW(50))];
    _titleLab.text = @"评价";
    _titleLab.font = [UIFont systemFontOfSize:17 weight:UIFontWeightMedium];
    _titleLab.textAlignment = NSTextAlignmentCenter;
    [_titleLab sizeToFit];
    _titleLab.centerX = bgWhiteView.width/2.0;
    _titleLab.height = autoScaleW(50);
    _titleLab.top = 0;
    [bgWhiteView addSubview:_titleLab];
    
//    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, _titleLab.bottom-1,  self.width, 1)];
//    lineView.backgroundColor = RGBValue(0xf0f0f0);
//    [bgWhiteView addSubview:lineView];
    
    _bgScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, _titleLab.bottom, self.width, autoScaleW(200))];
    _bgScrollView.backgroundColor = kWhiteColor;
    [bgWhiteView addSubview:_bgScrollView];
    [self reloadData];
    
    _closeBtn = [[UIButton alloc]initWithFrame:CGRectMake(bgWhiteView.width-80, 0, 80, autoScaleW(50))];
    [_closeBtn addTarget:self action:@selector(hiddenView) forControlEvents:UIControlEventTouchUpInside];
    [_closeBtn setImage:[UIImage imageNamed:@"evaluate_icon_close"] forState:UIControlStateNormal];
    _closeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    _closeBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
    [bgWhiteView addSubview:_closeBtn];
    
    submitBtn = [[UIButton alloc]initWithFrame:CGRectMake(12, _bgScrollView.bottom+TopSpace, self.width-24, ViewH)];
    [submitBtn setTitle:@"提交评价并退出直播" forState:UIControlStateNormal];
    submitBtn.cornerRadius = ViewH/2.0;
    submitBtn.backgroundColor = AppThemeColor;
    submitBtn.layer.masksToBounds = YES;
    [submitBtn addTarget:self action:@selector(submitDataAction) forControlEvents:UIControlEventTouchUpInside];
    [bgWhiteView addSubview:submitBtn];
    
    _viewHeight = autoScaleW(400);
}

- (void)reloadData {

    [_bgScrollView.subviews  makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [_selectDic removeAllObjects];
//    CGFloat viewBottom = 0;
    UIView *view =  [self createStarView:_dataSource];
    view.top = 0;
    [_bgScrollView addSubview:view];
//    _bgScrollView.contentSize = CGSizeMake(0, viewBottom+20);
    
}

#pragma mark - 提交数据
/** 提交数据 */
- (void)submitDataAction {
    
//        if (selectStar==NO) {
//            _submitBlock(tempArr);
//            [self hiddenView];
//        }
    
}



-(void)showMoreView {
    _bgScrollView.scrollEnabled = YES;
    [UIView animateWithDuration:0.5 animations:^{
        bgWhiteView.top = HEIGHT- bgWhiteView.height;
    }];
}


#pragma mark - 创建带有星星的评价
/** 创建带有星星的评价 */
- (UIView *)createStarView:(id )data {
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _bgScrollView.width, autoScaleW(60))];
    
    CZStarView *starView = [[CZStarView alloc] initWithFrame1:CGRectMake((WIDTH-autoScaleW(280))/2.0, 0, autoScaleW(280), autoScaleW(40))];
    [view addSubview:starView];
    
    UILabel *contentLab = [[UILabel alloc]initWithFrame:CGRectMake(starView.left, starView.bottom+autoScaleW(10),starView.width, autoScaleW(20))];
    contentLab.text = @"";
    contentLab.textColor = RGBValue(0xb4b4b4);
    contentLab.font = [UIFont systemFontOfSize:12.5 weight:UIFontWeightMedium];
    contentLab.textAlignment = NSTextAlignmentCenter;
    [view addSubview:contentLab];
    
    NSDictionary *commentDic = data[@"meta"];
    __weak typeof(self) weakSelf = self;
    starView.starClick = ^(NSInteger score) {
        NSString *keysStr = [NSString stringWithFormat:@"%d",(int)score];
        AnswerModel *model = [AnswerModel mj_objectWithKeyValues:commentDic[keysStr]];
        contentLab.text = model.title;
       UIView *tempView = [weakSelf createMultipleViewWithData:model.tag];
        [view addSubview:tempView];
        tempView.top = contentLab.bottom+10;
        view.height = tempView.bottom+10;

    } ;
    view.height = contentLab.bottom+ (ViewH +BottomSpace)*2;
    return view;
}



#pragma mark - 创建多选
/** 创建多选 */
- (UIView *)createMultipleViewWithData:(NSArray *)data {
    UIView *vv = [self viewWithTag:9999];
    if (vv) {
       [ vv.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [vv removeFromSuperview];
    }
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _bgScrollView.width, autoScaleW(100))];
    view.tag = 9999;
    NSInteger lineCount = data.count%2==0?data.count/2:(data.count/2+1);
    NSInteger index = 0;
    CGFloat viewW = (WIDTH-LeftSpace*2-ViewSpace)/2.0;
    for (NSInteger line=0; line<lineCount; line++) {
        for (NSInteger i = 0; i < 2; i ++) {
            if (index>=data.count) {
                break;
            }
            XLGMyButton *btn = [[XLGMyButton alloc]initWithFrame:CGRectMake(LeftSpace+(viewW+ViewSpace)*i, BottomSpace+(ViewH+BottomSpace)*line, viewW, ViewH)];
            btn.isSelect = NO;
            btn.cornerRadius = 5;
            [btn setTitleColor:RGBValue(0x646464) forState:UIControlStateNormal];;
            btn.titleLabel.font = [UIFont systemFontOfSize:14];
            [btn setTitle:data[index] forState:UIControlStateNormal];
            [view addSubview:btn];
            [btn addTarget:self action:@selector(commentClick:) forControlEvents:UIControlEventTouchUpInside];
            index++;
        }
    }
    
    return view;
}

- (void)commentClick:(XLGMyButton *)sender {
    
}

- (void)showView {
    self.hidden = NO;
    bgWhiteView.top = HEIGHT;
    shadowView.alpha = 0.0;
    self.alpha = 1.0;
    if (self.viewHeight>autoScaleW(250)) {
        self.bgScrollView.scrollEnabled = YES;
    }
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        bgWhiteView.top = HEIGHT-weakSelf.viewHeight;
        shadowView.alpha = 1.0;
    }];
}


- (void)hiddenView {
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        bgWhiteView.top = HEIGHT;
        shadowView.alpha = 0.0;
    } completion:^(BOOL finished) {
        weakSelf.hidden = YES;
        weakSelf.alpha = 0.0;
    }];
}

-(void)setDataSource:(id)dataSource {
    if (_dataSource!=dataSource) {
        _dataSource = dataSource;
    }
    [self reloadData];
}

@end


@implementation CommentDataModel

@end

@implementation AnswerModel


@end
