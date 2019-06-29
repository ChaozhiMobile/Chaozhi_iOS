//
//  BaseTableViewController.h
//  Talkfun_demo
//
//  Created by talk－fun on 16/1/25.
//  Copyright © 2016年 talk-fun. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "MJRefresh.h"
#define BEGIN_FLAG @"["
#define END_FLAG @"]"
#define KFacialSizeWidth  18
#define KFacialSizeHeight 18
#define MAX_WIDTH self.view.frame.size.width - 40
//章节图片缓存
#define FilePath [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/ImageCaches"]
//聊天数据缓存
#define FilePath2 [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/DataCaches"]
//提问数据缓存
#define FilePath3 [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/DataCaches2"]

@interface BaseTableViewController : UITableViewController

@property (nonatomic,strong                       ) NSMutableArray      * dataSource;
@property (nonatomic,strong                       ) NSMutableArray      * heightArray;
@property (nonatomic,strong                       ) NSMutableDictionary * answerHeightDict;
@property (nonatomic,strong                       ) NSMutableDictionary * dataDict;
@property (nonatomic,strong                       ) NSMutableArray      * selectedArray;
@property (nonatomic,strong                       ) NSDictionary        * expressionDict;
//@property (nonatomic,strong                       ) MJRefreshHeader * headerView;
//@property (nonatomic,strong                       ) MJRefreshFooter * footerView;
@property (nonatomic,assign                       ) BOOL                rotated;

@property (nonatomic,copy) void (^setDurationBlock) (CGFloat    duration);
@property (nonatomic,copy) void (^setAlbumBlock   ) (NSString * access_token);

@property (nonatomic,assign                       ) int                 cellNum;
@property (nonatomic,assign                       ) NSInteger           sum;
@property (nonatomic,copy                         ) NSString            * numberStr;
@property (nonatomic,copy) NSString * playbackID;
//@property (nonatomic,strong) NSMutableArray * displayCellArray;

- (void)removeAllData;
- (void)refreshUIWithDuration:(CGFloat)duration;
- (void)refreshUIWithIndex:(int)index;
- (void)recalculateCellHeight;
- (void)saveData:(NSData *)data WithUrlStringAndParams:(NSString *)string inFilePath:(NSString *)filePath;
- (NSData *)getDataWithUrlStringAndParams:(NSString *)string withTimeInterval:(NSTimeInterval)interval inFilePath:(NSString *)filePath;
- (NSString *)getUserNameAndTimeWith:(NSDictionary *)params;
- (UIView *)assembleMessageAtIndex:(NSString *)message;
- (void)dataWithDuration:(CGFloat)duration andFilePath:(NSString *)filePath;
- (void)getDataWithFilePath:(NSString *)filePath andString:(NSString *)string;
- (void)removeExtraData;

@end
