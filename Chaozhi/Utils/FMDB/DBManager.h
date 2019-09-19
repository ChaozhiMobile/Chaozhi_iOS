//
//  DBManager.h
//  Chaozhi
//
//  Created by Jason_zyl on 2019/7/4.
//  Copyright © 2019 Jason_hzb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VideoItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface DBManager : NSObject

/**
 创建对象
 @return 返回DBManager 对象
 */
+ (instancetype)shareManager;

/**
 创建数据库和表
 */
- (void)createDBAndTable;

/**
 新增视频数据
 @param item 视频model
 */
- (void)insertVideo:(VideoItem *)item;

/**
 删除视频数据
 @param item 视频model
 */
- (void)deleteVideo:(VideoItem *)item;

/**
 查询某个视频数据是否存在
 
 @return YES/NO
 */
- (BOOL)existVideo:(VideoItem *)item;

/**
 查询所有视频数据
 
 @return 返回查询到的当前用户视频数据
 */
- (NSMutableArray *)getAllVideo;

@end

NS_ASSUME_NONNULL_END
