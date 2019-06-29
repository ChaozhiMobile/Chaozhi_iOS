//
//  BaseTableViewController.m
//  Talkfun_demo
//
//  Created by talk－fun on 16/1/25.
//  Copyright © 2016年 talk-fun. All rights reserved.
//

#import "BaseTableViewController.h"

@interface BaseTableViewController ()

@end

@implementation BaseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.sum                   = 0;
    self.cellNum               = 0;

    self.view.backgroundColor  = [UIColor whiteColor];

    self.dataSource            = [NSMutableArray new];

    //row高度
    self.heightArray           = [NSMutableArray new];
    //answer高度
    self.answerHeightDict      = [NSMutableDictionary new];
    //存数据的字典
    self.dataDict              = [NSMutableDictionary new];
    //记住cell的selected
    self.selectedArray         = [NSMutableArray new];
    //显示的cell
//    self.displayCellArray = [NSMutableArray new];
    [self.selectedArray addObject:@(0)];
    //上拉加载 下拉刷新
//    self.headerView            = [MJRefreshHeaderView header];
//    self.footerView            = [MJRefreshFooterView footer];

//    self.headerView.scrollView = self.tableView;
//    self.footerView.scrollView = self.tableView;
//    self.headerView.delegate   = self;
//    self.footerView.delegate   = self;
    
    self.expressionDict = @{@"[fd]":@"[hard]",
                            @"[lg]":@"[aha]",
                            @"[qu]":@"[why]",
                            @"[fl]":@"[rose]",
                            @"[kl]":@"[pitiful]",
                            @"[jy]":@"[amaz]",
                            @"[gz]":@"[good]",
                            @"[hx]":@"[cool]",
                            @"[tx]":@"[love]",
                            @"[ag]":@"[bye]",
                            @"[S_FLOWER]":@"[rose]"};
    
    /*================= 监听app状态 =======================*/
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(onUIApplicationDidEnterBackgroundNotification:)
//                                                 name:UIApplicationDidEnterBackgroundNotification
//                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeAllData) name:@"deleteData" object:nil];
}

- (void)removeAllData
{
    [self.dataSource removeAllObjects];
    [self.dataDict removeAllObjects];
    [self.heightArray removeAllObjects];
    [self.answerHeightDict removeAllObjects];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView reloadData];
}

- (void)recalculateCellHeight
{
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
}

- (void)refreshUIWithDuration:(CGFloat)duration
{
    
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataSource.count + 1;
}

//根据duration自动获取缓存数据
- (void)dataWithDuration:(CGFloat)duration andFilePath:(NSString *)filePath
{
        
    NSMutableArray * mutableArr = [NSMutableArray new];
    NSArray * arr               = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:filePath error:nil];
    for (NSString * string in arr) {
        [mutableArr addObject:@([string integerValue])];
    }
    NSArray * sortedArr = [mutableArr sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2];
    }];
    if (sortedArr.count == 0) {
        return;
    }
    NSNumber * number = sortedArr[0];
    int i = 0;
    for (i = 0; i < sortedArr.count; i ++) {
        if ([sortedArr[i] floatValue] > duration) {
//            NSLog(@"%@",number);
            break;
        }
    }
//    NSLog(@"%d %@",i,number);
    
    if (i == 0) {
        
        NSString * numberStr = [NSString stringWithFormat:@"%@",sortedArr[0]];
        number               = sortedArr[0];
        if ([[number stringValue] isEqualToString:self.numberStr]) {
            return;
        }
        self.numberStr       = numberStr;
        [self.dataSource removeAllObjects];
        [self.selectedArray removeAllObjects];
        NSData * data = [self getDataWithUrlStringAndParams:numberStr withTimeInterval:36000 inFilePath:filePath];
        if (data != nil) {
            NSArray * cachesArr = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            [self.dataSource addObjectsFromArray:cachesArr];
        }
    }
    else
    {
        NSString * numberStr = [NSString stringWithFormat:@"%@",sortedArr[i - 1]];
        number = sortedArr[i - 1];
        if ([[number stringValue] isEqualToString:self.numberStr]) {
            return;
        }
        self.numberStr = numberStr;
        [self.dataSource removeAllObjects];
        [self.selectedArray removeAllObjects];
        NSData * data = [self getDataWithUrlStringAndParams:numberStr withTimeInterval:36000 inFilePath:filePath];
        if (data != nil) {
            NSArray * cachesArr = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            [self.dataSource addObjectsFromArray:cachesArr];
        }
        
    }
    self.sum = 0;
    [self.selectedArray addObject:@(0)];
    for (int j = 0; j < self.dataSource.count; j ++) {
        [self.selectedArray addObject:@(0)];
    }
    
    [self recalculateCellHeight];
}

- (void)refreshUIWithIndex:(int)index
{
    if (self.dataSource.count == 0) {
        return;
    }
    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    
    for (int j = 1; j < self.selectedArray.count; j ++) {
        [self.selectedArray replaceObjectAtIndex:j withObject:@(0)];
    }
    [self.selectedArray replaceObjectAtIndex:index withObject:@(1)];
    [self.tableView reloadData];
    
    UITableViewCell * cell = [self.tableView cellForRowAtIndexPath:indexPath];
    if (cell) {
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    }
    
}

//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    [self.displayCellArray addObject:indexPath];
//}
//
//- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    [self.displayCellArray removeObject:indexPath];
//}

//=============== 获取时间和用户名 ======================
- (NSString *)getUserNameAndTimeWith:(NSDictionary *)params
{
    NSString * userName  = params[@"nickname"];
    NSString * starttime = params[@"starttime"];
    if (!starttime) {
        starttime = params[@"startTime"];
    }
    NSInteger time    = [starttime integerValue];
    NSInteger hour    = time / 3600;
    NSInteger minutes = (time - hour * 3600) / 60;
    NSInteger second  = time - minutes * 60 - hour * 3600;
    
    return [NSString stringWithFormat:@"%@:(%02ld:%02ld:%02ld)",userName,(long)hour,(long)minutes,(long)second];
}

//====================== 图文混排 =====================
- (void)getImageRange:(NSString*)message :(NSMutableArray*)array
{
    NSRange range = [message rangeOfString:BEGIN_FLAG];
    NSRange range1 = [message rangeOfString:END_FLAG];
    //判断当前字符串是否还有表情的标志。
    if (range.length > 0 && range1.length > 0) {
        if (range.location > 0) {
            [array addObject:[message substringToIndex:range.location]];
            [array addObject:[message substringWithRange:NSMakeRange(range.location, range1.location+1-range.location)]];
            NSString * str = [message substringFromIndex:range1.location+1];
            [self getImageRange:str :array];
        }else {
            NSString * nextstr = [message substringWithRange:NSMakeRange(range.location, range1.location+1-range.location)];
            //排除文字是“”的
            if (![nextstr isEqualToString:@""]) {
                [array addObject:nextstr];
                NSString * str = [message substringFromIndex:range1.location + 1];
                [self getImageRange:str :array];
            }else {
                return;
            }
        }
        
    }
    else if (message != nil) {
        [array addObject:message];
    }
}

- (UIView *)assembleMessageAtIndex:(NSString *)message
{
    NSMutableArray * array = [[NSMutableArray alloc] init];
    [self getImageRange:message :array];
    UIView * returnView = [[UIView alloc] initWithFrame:CGRectZero];
    NSArray * data      = array;
    UIFont * fon        = [UIFont systemFontOfSize:13.0f];
    CGFloat upX         = 0;
    CGFloat upY         = 0;
    CGFloat X           = 0;
    CGFloat Y           = 0;
    if (data) {
        for (int i = 0;i < [data count]; i++) {
            NSString * str = [data objectAtIndex:i];
            if ([str hasPrefix:BEGIN_FLAG] && [str hasSuffix:END_FLAG])
            {
                if (upX >= MAX_WIDTH)
                {
                    upY = upY + KFacialSizeHeight;
                    upX = 0;
                    X   = 150;
                    Y   = upY;
                }
                
                NSString * imageName = [str substringWithRange:NSMakeRange(1, str.length - 2)];
                UIImageView * img    = [[UIImageView alloc]initWithImage:[UIImage imageNamed:imageName]];
                img.frame            = CGRectMake(upX, upY, KFacialSizeWidth, KFacialSizeHeight);
                [returnView addSubview:img];
                upX                  = KFacialSizeWidth+upX;
                if (X < 150) X = upX;
                
                
            } else {
                for (int j = 0; j < [str length]; j++) {
                    NSString * temp = [str substringWithRange:NSMakeRange(j, 1)];
                    if (upX >= MAX_WIDTH)
                    {
                        upY = upY + KFacialSizeHeight;
                        upX = 0;
                        X   = 150;
                        Y   = upY;
                    }
                    CGRect rect = [temp boundingRectWithSize:CGSizeMake(150, 40) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];
                    //                    CGSize size = [temp sizeWithFont:fon constrainedToSize:CGSizeMake(150, 40)];
                    UILabel * la       = [[UILabel alloc] initWithFrame:CGRectMake(upX,upY,rect.size.width,rect.size.height)];
                    la.font            = fon;
                    la.text            = temp;
                    la.textAlignment   = NSTextAlignmentCenter;
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
    
    returnView.frame = CGRectMake(20.0f,22.0f, X, Y); //@ 需要将该view的尺寸记下，方便以后使用
    
    return returnView;
}

#pragma mark - 缓存
- (void)saveData:(NSData *)data WithUrlStringAndParams:(NSString *)string inFilePath:(NSString *)filePath
{
    //    NSString * str = [string MD5Hash];
    NSString * fileP = [filePath stringByAppendingPathComponent:string];
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    [data writeToFile:fileP atomically:YES];
}

- (NSData *)getDataWithUrlStringAndParams:(NSString *)string withTimeInterval:(NSTimeInterval)interval inFilePath:(NSString *)filePath
{
    NSDate * date = [self calculateTimeIntervalWithString:string inFilePath:filePath];
    NSTimeInterval realInterval = [[NSDate date] timeIntervalSinceDate:date];
    if (realInterval > interval) {
        return nil;
    }
    //    NSString * str = [string MD5Hash];
    NSString * path = [filePath stringByAppendingPathComponent:string];
    NSData * data   = [NSData dataWithContentsOfFile:path];
    
    return data;
}
- (NSDate *)calculateTimeIntervalWithString:(NSString *)string inFilePath:(NSString *)filePath
{
    //    NSString * str = [string MD5Hash];
    NSString * path     = [filePath stringByAppendingPathComponent:string];
    NSDictionary * dict = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil];
    NSDate * date       = dict[NSFileModificationDate];
    return date;
}

- (void)removeExtraData
{
    if (self.sum == 0) {
        return;
    }
    [self.dataSource removeObjectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, self.sum)]];
    [self.selectedArray removeObjectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, self.sum)]];
    [self recalculateCellHeight];
    self.sum = 0;
}

//刷新拿数据
- (void)getDataWithFilePath:(NSString *)filePath andString:(NSString *)string
{
    NSMutableArray * mutableArr = [NSMutableArray new];
    
    NSArray * arr = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:filePath error:nil];
    for (NSString * string in arr) {
        
        [mutableArr addObject:@([string integerValue])];
        
    }
    NSArray * sortedArr = [mutableArr sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        
        return [obj1 compare:obj2];
        
    }];
    
    NSString * str = self.dataSource.firstObject[string];
    
    int i = 0;
    for (i = 0; i < sortedArr.count; i ++) {
        
        if ([sortedArr[i] integerValue] == [str integerValue]) {
            
            break;
        }
        
    }
    
    if (i == 0) {
        
        return;
    }
    else
    {
        NSString * string = [sortedArr[i - 1] stringValue];
        NSData * data = [self getDataWithUrlStringAndParams:string withTimeInterval:36000 inFilePath:filePath];
        if (data == nil) {
            return;
        }
        NSArray * cachesArr = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        [self.dataSource insertObjects:cachesArr atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, cachesArr.count)]];
        
        for (int j = 0; j < cachesArr.count; j ++) {
            [self.selectedArray insertObject:@(0) atIndex:0];
        }
        
        self.sum += cachesArr.count;
        
        [self recalculateCellHeight];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:cachesArr.count inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
        });
        
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
//    self.headerView.scrollView = nil;
//    self.footerView.scrollView = nil;
//    self.headerView            = nil;
//    self.footerView            = nil;
}

@end
