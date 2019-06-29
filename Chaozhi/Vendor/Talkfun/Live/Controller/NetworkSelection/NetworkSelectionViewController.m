//
//  NetworkSelectionViewController.m
//  Talkfun_demo
//
//  Created by moruiwei on 16/1/27.
//  Copyright © 2016年 talk-fun. All rights reserved.
//


#import "NetworkSelectionViewController.h"
#import "ChoiceButton.h"
#import "MJExtension.h"
#import "NetworkModel.h"

@interface NetworkSelectionViewController ()
//背景
@property (weak, nonatomic) IBOutlet UIView             *view_bgView;
//整体
@property (weak, nonatomic) IBOutlet UIView             *WholeView;

//UIScrollView内容
@property (weak, nonatomic) IBOutlet UIScrollView       *scview;
//约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgViewH;

@property(nonatomic,assign)CGFloat temp_bgViewH;

//线路分段选择器
@property (weak, nonatomic) IBOutlet UISegmentedControl *RouteSelection;


//线路选择器宽度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *RouteSelectionWidth;
@property (weak, nonatomic) IBOutlet UILabel *networkSpeedLabel;
@property (nonatomic,assign) TalkfunNetworkStatus networkStatus;


//装 所有  button
@property(nonatomic,strong)NSMutableArray *btnArray;


//默认与选择转换 线路
@property(nonatomic,assign)BOOL Line_Switching;


@property(nonatomic,strong)NSDictionary *operationDict;

//使用记录的  数据     位置
@property(nonatomic,assign)BOOL  useRecord;
 //30 的高度  加上上下 间距  10
@property(nonatomic,assign) CGFloat CurrentNetworkPromptHeight;//你的网络运营商电信IP116.22.35.93

@property (weak, nonatomic) IBOutlet UILabel *CurrentNetworkPromp;
@property (weak, nonatomic) IBOutlet UILabel *OptimalText;


@end

@implementation NetworkSelectionViewController

- (NSMutableArray*)btnArray{
    if(_btnArray==nil){
        _btnArray = [NSMutableArray array];
    }
    return _btnArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //设置默认值
    [self moren];
    self.useRecord = NO;
    //退出按键
    [self.exit addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    //
    self.CurrentNetworkPromptHeight = 40;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.view.alpha = 1.0;
    self.view.hidden = YES;
    for (UIView * view in self.scview.subviews) {
        
        if ([view isKindOfClass:[ChoiceButton class]]) {
            [view removeFromSuperview];
        }
        
    }
    
}

- (void)moren
{
    
    self.scview.layer.cornerRadius = 6;
    self.scview.layer.masksToBounds = YES;
    
    self.scview.backgroundColor = [UIColor whiteColor ];
    self.scview.contentSize = CGSizeMake(0, 0);
    self.scview.showsVerticalScrollIndicator = YES;
    
    self.view_bgView.backgroundColor = [UIColor colorWithRed:0 / 255.0 green:0 / 255.0 blue:0 / 255.0 alpha:1];
    self.view_bgView.alpha = 0.2;
    self.WholeView.layer.cornerRadius = 10;
    //超出主层边框的都会被裁减调用
    self.WholeView.layer.masksToBounds = YES;
    
    [self.scview flashScrollIndicators];
    
    int number = -10000;
    
    self.selectedNumber = number;
}

//运营商 数据
- (void)setNetworkSelectionArray:(NSMutableArray *)networkSelectionArray

{
    _networkSelectionArray = networkSelectionArray;
    
    if (self.useRecord ) {
        if(self.operationDict[@"selectedNumber"]){
            NSNumber *selectedNumber =    self.operationDict[@"selectedNumber"];
            int selected = [selectedNumber intValue];
            
            self.selectedNumber = selected;
        }
        
        
    }
    
    
    [self initWithArray:networkSelectionArray lineSwitching:self.RouteSelection.selectedSegmentIndex];
    
}

- (void)initWithArray:(NSMutableArray*)NetworkSelectionDict lineSwitching:(NSInteger)number
{
    
    
    if (self.btnArray.count>0) {
        [self.btnArray removeAllObjects];
        
        [self.choiceArray removeAllObjects];
    }
    
    
    for(UIView *mylabelview in [self.scview subviews])
    {
        if ([mylabelview isKindOfClass:[ChoiceButton class]]) {
            [mylabelview removeFromSuperview];
        }
    }
    
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        
        int count =   (int)self.RouteSelection.numberOfSegments;
        
        
        
        
        NSArray *NetworkSelectionArray = self.networkSelectionArray;
        
        if (NetworkSelectionArray.count<=0) {
            return ;
        }
        //总数为1的时候 不用选择
        if (NetworkSelectionArray.count==1) {
            self.RouteSelection.hidden = YES;
        }else{
            self.RouteSelection.hidden = NO;
        }
        
        if (count!=NetworkSelectionArray.count) {
            if (count>NetworkSelectionArray.count) {
                
                
                for (int i = 1; i < count ; i++) {
                    
                    [self.RouteSelection removeSegmentAtIndex:i animated:NO];
                }
                self.RouteSelectionWidth.constant = 70;
            }
            
            //如果有大于2 条的线路
            else   if (NetworkSelectionArray.count>2) {
                
                if(NetworkSelectionArray.count==3)
                {
                    self.RouteSelectionWidth.constant = (140/2)*3;
                    [self.RouteSelection  insertSegmentWithTitle:@"线路3" atIndex:2 animated:NO];
                }else if (NetworkSelectionArray.count==4){
                    self.RouteSelectionWidth.constant = (140/2)*4;
                    [self.RouteSelection  insertSegmentWithTitle:@"线路3" atIndex:2 animated:NO];
                    [self.RouteSelection  insertSegmentWithTitle:@"线路4" atIndex:3 animated:NO];
                }
                
                
                
            } 
        }
    
        
        self.RouteSelection.alpha = 1.0;
        
        NSArray *array=  NetworkSelectionArray[number];
        
        //        NSArray *array = dict[@"operators"];
        
        self.choiceArray = [NetworkModel mj_objectArrayWithKeyValuesArray:array];
        
        
        
        CGFloat buttonW = self.scview.bounds.size.width;
        //每行显示个数
        int totalColumn = 2;
        
        CGFloat gap = 15;
        
        for (int i = 0; i < self.choiceArray.count; i++) {
            
            ChoiceButton * buttonChoice = [ChoiceButton buttonWithType:UIButtonTypeCustom];
            //添加监听按钮点击    按钮添加点击
            [buttonChoice addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            
            
            
            //当前子view的行号 = 当前遍历到得索引值 / 总列数
            int row = i / totalColumn;
            //当前子view的列号 = 当前遍历到得索引值 % 总列数
            int column = i % totalColumn;
            
            CGFloat tempFrameW = (buttonW - (3 * gap)) * 0.5;
            CGFloat tempFrameH = 35;
            CGFloat tempFrameX = gap + column * (gap + tempFrameW);
            CGFloat tempFrameY = gap + row * (gap + tempFrameH);
            
            buttonChoice.frame = CGRectMake(tempFrameX, tempFrameY, tempFrameW, tempFrameH);
            buttonChoice.tag = i;
            buttonChoice.layer.cornerRadius = 6;
            //gray
            buttonChoice.layer.borderWidth = 0.5;
            buttonChoice.layer.borderColor = [UIColor colorWithRed:170.0 / 225 green:170.0 / 225 blue:170.0 / 225 alpha:1].CGColor;
            //设置用户选择的网络颜色
            if (i ==  self.selectedNumber ) {
                buttonChoice.backgroundColor = [UIColor colorWithRed:226 / 255.0 green:237 / 255.0 blue:255 / 255.0 alpha:1];
                buttonChoice.layer.borderColor= [UIColor colorWithRed:66 / 255.0 green:133 / 255.0 blue:244 / 225.0 alpha:1].CGColor;
            }
            buttonChoice.Network = self.choiceArray[i];
            
            [self.scview  addSubview:buttonChoice];
            
            
            [self.btnArray addObject:buttonChoice];
            
         
            
            CGSize size =  CGSizeMake(0, CGRectGetMaxY(buttonChoice.frame) + gap);
            
            if (size.height +self.scview.frame.origin.y<=self.view.frame.size.height) {
                
                self.bgViewH.constant = size.height +self.scview.frame.origin.y;
                
               
            }else{
                
                self.bgViewH.constant   = self.view.frame.size.height - 10;
            }
            
            self.scview.contentSize =size;
            
            self.view.hidden = NO;
            
 
        }
        
        //加上提示的高度
         self.bgViewH.constant = self.bgViewH.constant  +  self.CurrentNetworkPromptHeight;
        
        
//        self.network
        if (self.network[@"ip"]&&self.network[@"isp"]) {
            self.CurrentNetworkPromp.hidden = NO;
            NSString *text = @"你的网络运营商 ";
                     text = [text stringByAppendingString:self.network[@"isp"]];
                     text = [text stringByAppendingString:@"  "];
                     text = [text stringByAppendingString:@"IP "];
                     text = [text stringByAppendingString:self.network[@"ip"]];
//             电信 IP 116.22.35.93
            
            // 1.创建NSMutableAttributedString实例
            NSMutableAttributedString *fontAttributeNameStr = [[NSMutableAttributedString alloc]initWithString:text];
            
            // 2. 你的网络运营商
            [fontAttributeNameStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(0, 8)];
            
            [fontAttributeNameStr addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, 8)];
            
            
            
            
            // 2. 电信
            [fontAttributeNameStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(8, 11)];
            
            [fontAttributeNameStr addAttribute:NSForegroundColorAttributeName value:self.OptimalText.textColor range:NSMakeRange(8, 11)];
            
            
            
            // 2. IP
            [fontAttributeNameStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(11, 14)];
            
            [fontAttributeNameStr addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(11, 14)];
            
            
            
            
            // 116.22.35.93
            [fontAttributeNameStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(14, text.length - 14)];
            //设置颜色
            [fontAttributeNameStr addAttribute:NSForegroundColorAttributeName value:self.OptimalText.textColor range:NSMakeRange(14, text.length - 14)];
            
            // 3.给label赋值
            self.CurrentNetworkPromp.attributedText = fontAttributeNameStr;
        }else{
             self.CurrentNetworkPromp.hidden = YES;
        }
        
        
        
    });
    
    
    
    
}
//用户选择的结果
- (void)buttonClick:(ChoiceButton *)button
{
    
    self.useRecord = NO;
    NSInteger Index = self.RouteSelection.selectedSegmentIndex;
    
    

    
    for (ChoiceButton *button in self.scview.subviews) {
        button.backgroundColor = [UIColor clearColor];
    }
    button.backgroundColor = [UIColor colorWithRed:226 / 255.0 green:237 / 255.0 blue:255 / 255.0 alpha:1];
    button.layer.borderColor= [UIColor colorWithRed:66 / 255.0 green:133 / 255.0 blue:244 / 225.0 alpha:1].CGColor;
    
    //用户选择的网络
    self.selectedNumber = button.tag;
    //保存用户选中的key传出去
    NSString *operatorID =  [self.choiceArray [button.tag] key];
    
    
    NSDictionary *BlockDict = @{@"operatorID":operatorID,
                                
                                //                                    @"sourceName":sourceName,
                                @"selectedSegmentIndex":@(Index)
                                };
    //记录 选择的 线路与运营 商
    self.operationDict = @{@"selectedSegmentIndex":@(Index),
                           
                           @"selectedNumber":@(self.selectedNumber)
                           
                           };
    
    if (self.networkOperators) {
        self.networkOperators(BlockDict);
    }
    //    }
    
    
    
    [UIView animateWithDuration:0.5 animations:^{
        self.view.alpha = 0.0;
    }completion:^(BOOL finished) {
        [self.view removeFromSuperview];
    }];
    
}




//退出当=当前
- (void)btnClick
{
    self.useRecord = YES;
    
    
    NSNumber *selectedSegmentIndex =    self.operationDict[@"selectedSegmentIndex"];
    int Index = [selectedSegmentIndex intValue];
    self.RouteSelection.selectedSegmentIndex = Index;
    
    [self.view removeFromSuperview];
    
}


- (IBAction)routeSelection:(UISegmentedControl *)sender {
    
    
    int selectedSegmentIndex = [self.operationDict [@"selectedSegmentIndex"] intValue];
    
    if (selectedSegmentIndex != sender.selectedSegmentIndex) {
        if (self.operationDict [@"selectedSegmentIndex"]) {
            self.selectedNumber = -1000;
        }
        
    }else{
        if (self.operationDict [@"selectedNumber"]) {
            self.selectedNumber =  [self.operationDict [@"selectedNumber"] intValue];
        }
        
        
    }
    
    
    
    [self initWithArray:self.networkSelectionArray lineSwitching:sender.selectedSegmentIndex];
    
    
}

- (void)networkSpeed:(id)obj{
    
    TalkfunNetworkStatus networkStatus = [obj[@"networkStatus"] intValue];
    
    self.networkSpeedLabel.text = [NSString stringWithFormat:@"当前网速%@",obj[@"speed"]];
    if (networkStatus == TalkfunNetworkStatusGood) {
        
        
//        [UIColor greenColor]
        self.networkSpeedLabel.textColor =[UIColor colorWithRed:70 / 255.0 green:114 / 255.0 blue:60 / 255.0 alpha:1];
 
    }else if (networkStatus == TalkfunNetworkStatusGeneral){
        self.networkSpeedLabel.textColor = [UIColor yellowColor];
    }else{
        self.networkSpeedLabel.textColor = [UIColor redColor];
    }
    self.networkStatus = networkStatus;
}

@end

