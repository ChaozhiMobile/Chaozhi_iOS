//
//  RootTableViewController.m
//  Talkfun_demo
//
//  Created by talk－fun on 16/1/26.
//  Copyright © 2016年 talk-fun. All rights reserved.
//

#import "RootTableViewController.h"

@interface RootTableViewController ()

@end

@implementation RootTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createArrayAndOther];
    
}

- (void)createArrayAndOther
{
    self.view.backgroundColor = [UIColor whiteColor];

    self.dataSource           = [NSMutableArray new];
    //问答顺序排序
    self.rankArray            = [NSMutableArray new];
    //row高度
    self.heightArray          = [NSMutableArray new];
    //answer高度
    self.answerHeightDict     = [NSMutableDictionary new];
    //存数据的字典
    self.dataDict             = [NSMutableDictionary new];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clearData:) name:@"clear" object:nil];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)clearData:(NSNotification *)notification
{
    [self.dataSource removeAllObjects];
    [self.rankArray removeAllObjects];
    [self.heightArray removeAllObjects];
    [self.answerHeightDict removeAllObjects];
    [self.dataDict removeAllObjects];
    
    [self.tableView reloadData];
}

- (void)recalculateCellHeight
{
    
}

#pragma mark - Table view data source
#pragma mark - tableView dataSource 代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

//=============== 获取时间和用户名 ======================
- (NSString *)getUserNameAndTimeWith:(NSDictionary *)params
{
    NSString * userName            = params[@"nickname"];
    NSString * time                = params[@"time"];

    NSTimeInterval timeInterval    = [time doubleValue];
    NSDate *detaildate             = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"HH:mm"];

    NSString * currentDateStr      = [dateFormatter stringFromDate: detaildate];
    
    return [NSString stringWithFormat:@"%@:(%@)",userName,currentDateStr];
}

//====================== 图文混排 =====================
- (void)getImageRange:(NSString*)message :(NSMutableArray*)array {
    NSRange range  = [message rangeOfString:BEGIN_FLAG];
    NSRange range1 = [message rangeOfString:END_FLAG];
    //判断当前字符串是否还有表情的标志。
    if (range.length>0 && range1.length>0) {
        if (range.location > 0) {
            [array addObject:[message substringToIndex:range.location]];
            [array addObject:[message substringWithRange:NSMakeRange(range.location, range1.location+1-range.location)]];
            NSString *str=[message substringFromIndex:range1.location+1];
            [self getImageRange:str :array];
        }else {
            NSString *nextstr=[message substringWithRange:NSMakeRange(range.location, range1.location+1-range.location)];
            //排除文字是“”的
            if (![nextstr isEqualToString:@""]) {
                [array addObject:nextstr];
                NSString *str=[message substringFromIndex:range1.location+1];
                [self getImageRange:str :array];
            }else {
                return;
            }
        }
        
    } else if (message != nil) {
        [array addObject:message];
    }
}

- (UIView *)assembleMessageAtIndex:(NSString *)message
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [self getImageRange:message :array];
    UIView * returnView   = [[UIView alloc] initWithFrame:CGRectZero];
    NSArray * data        = array;
    UIFont * fon          = [UIFont systemFontOfSize:13.0f];
    CGFloat upX           = 0;
    CGFloat upY           = 0;
    CGFloat X             = 0;
    CGFloat Y             = 0;
    if (data) {
        for (int i = 0;i < [data count]; i++) {
            NSString *str = [data objectAtIndex:i];
            NSLog(@"str--->%@",str);
            if ([str hasPrefix: BEGIN_FLAG] && [str hasSuffix: END_FLAG])
            {
                if (upX >= MAX_WIDTH)
                {
                    upY = upY + KFacialSizeHeight;
                    upX = 0;
                    X   = 150;
                    Y   = upY;
                }
                NSLog(@"str(image)---->%@",str);
                NSString * imageName=[str substringWithRange:NSMakeRange(1, str.length - 2)];
                UIImageView *img=[[UIImageView alloc]initWithImage:[UIImage imageNamed:imageName]];
                img.frame = CGRectMake(upX, upY, KFacialSizeWidth, KFacialSizeHeight);
                [returnView addSubview:img];
                upX       = KFacialSizeWidth+upX;
                if (X < 150) X = upX;
                
                
            } else {
                for (int j = 0; j < [str length]; j++) {
                    NSString *temp = [str substringWithRange:NSMakeRange(j, 1)];
                    if (upX >= MAX_WIDTH)
                    {
                        upY = upY + KFacialSizeHeight;
                        upX = 0;
                        X   = 150;
                        Y   = upY;
                    }
                    CGRect rect        = [temp boundingRectWithSize:CGSizeMake(150, 40) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];
                    //                    CGSize size = [temp sizeWithFont:fon constrainedToSize:CGSizeMake(150, 40)];
                    UILabel *la        = [[UILabel alloc] initWithFrame:CGRectMake(upX,upY,rect.size.width,rect.size.height)];
                    la.font            = fon;
                    la.text            = temp;
                    la.backgroundColor = [UIColor clearColor];
                    [returnView addSubview:la];
                    upX                = upX + rect.size.width;
                    if (X < 150) {
                        X = upX;
                    }
                }
            }
        }
    }
    
    returnView.frame = CGRectMake(20.0f,27.0f, X, Y); //@ 需要将该view的尺寸记下，方便以后使用
    NSLog(@"%.1f %.1f", X, Y);
    return returnView;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
