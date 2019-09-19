//
//  RootTableViewController.h
//  Talkfun_demo
//
//  Created by talk－fun on 16/1/26.
//  Copyright © 2016年 talk-fun. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "TalkfunSDK.h"

#define BEGIN_FLAG @"["
#define END_FLAG @"]"
#define KFacialSizeWidth  18
#define KFacialSizeHeight 18
#define MAX_WIDTH self.view.frame.size.width - 40

@interface RootTableViewController : UITableViewController

@property (nonatomic,strong               ) NSMutableArray      * dataSource;
@property (nonatomic,copy) void (^btnBlock) (BOOL,NSString            *);
@property (nonatomic,strong               ) NSMutableArray      * heightArray;
@property (nonatomic,strong               ) NSMutableArray      * rankArray;
@property (nonatomic,strong               ) NSMutableDictionary * answerHeightDict;
@property (nonatomic,strong               ) NSMutableDictionary * dataDict;
@property (nonatomic,strong               ) UILabel             * timeLabel;
@property (nonatomic,strong               ) UILabel             * gongGaoLabel;
@property (nonatomic,strong               ) UILabel             * content;
@property (nonatomic,assign               ) CGFloat             advanceHeight;
@property (nonatomic,copy                 ) NSString            * xid;
//记住自己信息的字典
@property (nonatomic,strong               ) NSDictionary        * me;

- (void)recalculateCellHeight;
- (NSString *)getUserNameAndTimeWith:(NSDictionary *)params;
- (void)getImageRange:(NSString*)message :(NSMutableArray*)array;
- (UIView *)assembleMessageAtIndex:(NSString *)message;
- (void)clearData:(NSNotification *)notification;
- (void)createArrayAndOther;

@end
