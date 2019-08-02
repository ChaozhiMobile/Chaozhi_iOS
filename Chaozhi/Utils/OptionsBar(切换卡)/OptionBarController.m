//
//  OptionBarController.m
//  SuperMarket
//
//  Created by hanzhanbing on 16/7/15.
//  Copyright © 2016年 柯南. All rights reserved.
//

#import "OptionBarController.h"
#import "OptionsBarView.h"

@interface OptionBarController()<UIScrollViewDelegate,OptionsBarViewDelegate>
@property (nonatomic,strong)NSArray *titles;
@property (nonatomic,weak)OptionsBarView *lhOptionsBarView;
@property (nonatomic,weak)UIScrollView *mainView;
@end

@implementation OptionBarController

-(void)viewDidLoad{
    [super viewDidLoad];
    [self createView];
    [self createTitles:self.controllersArr];
}

-(void)createTitles:(NSArray *)subViewControllers{
    NSMutableArray *temp=[NSMutableArray array];
    for (UIViewController *controller in subViewControllers) {
        NSString *title=controller.title;
        [temp addObject:title];
    }
    self.titles=temp;
    self.lhOptionsBarView.titles=_titles;
}

-(void)createView{
    _linecolor = _linecolor ? _linecolor : AppThemeColor;
    OptionsBarView *optionBarView=[[OptionsBarView alloc]initWithFrame:_frame];
    optionBarView.backgroundColor = _selectedViewColor;
    self.lhOptionsBarView=optionBarView;
    [self.view addSubview:optionBarView];
    optionBarView.delegate=self;
    optionBarView.showSeprateLine=_showLineView;
    optionBarView.showBottomLine = _showBottomView;
    optionBarView.bottomLineColor=_linecolor;
    optionBarView.selectedTextColor = _selectedTextColor;
    optionBarView.selectedViewColor = _selectedViewColor;
    UIScrollView *scrollerView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.lhOptionsBarView.frame), WIDTH,HEIGHT)];
    self.mainView=scrollerView;
    [self.view addSubview:scrollerView];
    _mainView.delegate=self;
    _mainView.pagingEnabled=YES;
    _mainView.showsHorizontalScrollIndicator = NO;
    _mainView.contentSize = CGSizeMake(WIDTH * _controllersArr.count, 0);
    //_mainView.contentSize = CGSizeMake(0, 0); //屏蔽左右滑动
    _mainView.bounces=NO;
    [_controllersArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIViewController *viewController = (UIViewController *)_controllersArr[idx];
        viewController.view.frame = CGRectMake(idx * WIDTH, 0, WIDTH, _mainView.bounds.size.height);
        [_mainView addSubview:viewController.view];
    }];
}

- (instancetype)initWithFrame:(CGRect)frame andSubViewControllers:(NSArray *)subViewControllers andSelectedViewColor:(UIColor *)selectedViewColor andSelectedTextColor:(UIColor *)selectedTextColor andShowSeperateLine:(BOOL)showSeperateLine andShowBottomLine:(BOOL)showBottomLine andCurrentPage:(int)page
{
    self = [super init];
    if (self)
    {
        _frame = frame;
        _controllersArr = subViewControllers;
        _showLineView = showSeperateLine;
        _showBottomView = showBottomLine;
        _selectedViewColor = selectedViewColor ? selectedViewColor : AppThemeColor;
        _selectedTextColor = selectedTextColor ? selectedTextColor : [UIColor whiteColor];
        _currentPage = page;
    }
    return self;
}

- (void)addParentController:(UIViewController *)viewController
{
    // Close UIScrollView characteristic on IOS7 and later
    if ([viewController respondsToSelector:@selector(edgesForExtendedLayout)])
    {
        viewController.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    [viewController addChildViewController:self];
    [viewController.view addSubview:self.view];
    
    self.lhOptionsBarView.currentIndex=_currentPage;
    [self.mainView setContentOffset:CGPointMake(_currentPage*WIDTH, 0) animated:NO];
}

/**
 *  设置是否带有分割线
 *
 *  @param showLineView YES:显示 NO:不显示
 */
-(void)setShowLineView:(BOOL)showLineView {
    if(_showLineView!=showLineView){
        _showLineView=showLineView;
    }
}

/**
 *  设置是否带有底部线
 *
 *  @param showBottomView YES:显示 NO:不显示
 */
-(void)setShowBottomView:(BOOL)showBottomView{
    if(_showBottomView!=showBottomView){
        _showBottomView=showBottomView;
    }
}

/**
 *  当前页
 */
- (void)setCurrentPage:(int)currentPage {
    if (_currentPage!=currentPage) {
        _currentPage = currentPage;
    }
}

- (instancetype)initWithFrame:(CGRect)frame andSubViewControllers:(NSArray *)controllersArr andParentViewController:(UIViewController *)viewController andSelectedViewColor:(UIColor *)selectedViewColor andSelectedTextColor:(UIColor *)selectedTextColor andShowSeperateLine:(BOOL)showSeperateLine andShowBottomLine:(BOOL)showBottomLine andCurrentPage:(int)page {
    self=[self initWithFrame:frame andSubViewControllers:controllersArr andSelectedViewColor:selectedViewColor andSelectedTextColor:selectedTextColor andShowSeperateLine:showSeperateLine andShowBottomLine:showBottomLine andCurrentPage:page];
    [self addParentController:viewController];
    return self;
}

#pragma  mark -UICrollerViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSInteger currentIndex=self.mainView.contentOffset.x/WIDTH;
    self.lhOptionsBarView.currentIndex=currentIndex;
    if (self.clickBlock !=nil) {
        self.clickBlock(currentIndex);
    }
}

#pragma mark -LHOptionsBarViewDelegate
-(void)lhOptionBarView:(OptionsBarView *)optionBarView didSelectedItemWithCurrentIndex:(NSInteger)currentIndex{
    [self.mainView setContentOffset:CGPointMake(currentIndex*WIDTH, 0) animated:NO];
    if (self.clickBlock !=nil) {
        self.clickBlock(currentIndex);
    }
}

@end
