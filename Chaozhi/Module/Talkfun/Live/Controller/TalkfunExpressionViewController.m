//
//  TalkfunExpressionViewController.m
//  TalkfunSDKDemo
//
//  Created by 孙兆能 on 2016/12/19.
//  Copyright © 2016年 talk-fun. All rights reserved.
//

#import "TalkfunExpressionViewController.h"
#import "TalkfunExpressionCell.h"
#import "TalkfunExpressionCloseButton.h"

@interface TalkfunExpressionViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@end

@implementation TalkfunExpressionViewController

static NSString * reuseIdentifier = @"ExpressionCell";
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"TalkfunExpressionCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
//    self.view.layer.borderColor = [UIColor colorWithRed:200 / 255.0 green:200 / 255.0 blue:200 / 255.0 alpha:0.5].CGColor;
//    self.view.layer.borderWidth = 1;
    if ([DEVICEMODEL hasPrefix:@"iPad"]) {
        self.collectionViewFlowLayout.minimumInteritemSpacing = 15;
        self.collectionViewFlowLayout.sectionInset = UIEdgeInsetsMake(10, 34, 10, 34);
    }
    [self.collectionView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
    self.view.backgroundColor = NEWBLUECOLOR;
    self.collectionView.backgroundColor = [UIColor clearColor];
    
//    UILongPressGestureRecognizer * longPressGR = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGR:)];
//    [self.deleteBtn addGestureRecognizer:longPressGR];
    [self.deleteBtn addTarget:self action:@selector(touchUp:) forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchUpOutside];
    [self.deleteBtn addTarget:self action:@selector(touchDown:) forControlEvents:UIControlEventTouchDown];
}

- (void)touchUp:(UIButton *)btn{
    [timer invalidate];
}

- (void)touchDown:(UIButton *)btn{
    [timer invalidate];
    timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(deleteTimer:) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

static NSTimer * timer;
//- (void)longPressGR:(UILongPressGestureRecognizer *)longGR{
//    NSLog(@"longlonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglonglong");
//    static int i = 0;
//    i += 1;
//    [timer invalidate];
//    timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(deleteTimer:) userInfo:nil repeats:YES];
//    if (i % 2 == 0) {
//        [timer invalidate];
//    }
//}

- (void)deleteTimer:(NSTimer *)timer{
    [self deleteBtnTouchDown:self.deleteBtn];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"contentSize"]) {
        id obj = change[@"new"];
        self.deleteBtnTopSpace.constant = ([obj CGSizeValue].height-ExpressionViewHeight()/2);
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //NSLog(@"self.view:%@ coll:%@ size:%@",NSStringFromCGRect(self.view.frame),NSStringFromCGRect(self.collectionView.frame),NSStringFromCGSize(self.collectionView.contentSize));
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //NSLog(@"ddself.view:%@ coll:%@ size:%@",NSStringFromCGRect(self.view.frame),NSStringFromCGRect(self.collectionView.frame),NSStringFromCGSize(self.collectionView.contentSize));
}

- (void)viewDidLayoutSubviews{
    UIView  * view = [self.view viewWithTag:212];
    if (!view) {
        UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 0.5)];
        view.backgroundColor = [UIColor blackColor];
        view.tag = 212;
        [self.view addSubview:view];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataSource.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    TalkfunExpressionCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    NSString * imageName = self.dataSource[indexPath.row];
    cell.expressionImageView.image = [UIImage imageNamed:imageName];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.expressionBlock) {
        self.expressionBlock(self.dataSource[indexPath.row]);
    }
}

- (IBAction)deleteBtnTouchDown:(TalkfunExpressionCloseButton *)sender {
    if (self.expressionBlock) {
        self.expressionBlock(@"delete");
    }
}

//- (IBAction)deleteBtnClicked:(TalkfunExpressionCloseButton *)sender {
//    if (self.expressionBlock) {
//        self.expressionBlock(@"delete");
//    }
//}

- (NSMutableArray *)dataSource{
    if (!_dataSource) {
        NSArray * expressionsArray = ExpressionsArray();
        _dataSource = [[NSMutableArray alloc] initWithArray:expressionsArray];
    }
    return _dataSource;
}

- (void)dealloc{
    [self.collectionView removeObserver:self forKeyPath:@"contentSize"];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
}

@end
