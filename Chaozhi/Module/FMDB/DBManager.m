//
//  DBManager.m
//  Chaozhi【https://www.jianshu.com/p/d3c4545b2474】
//
//  Created by Jason_zyl on 2019/7/4.
//  Copyright © 2019 Jason_hzb. All rights reserved.
//

#import "DBManager.h"
#import "FMDB.h"

/** 本地保存的数据库版本 */
NSString * const kdbManagerVersion = @"DBManagerVersion";
/** 当前数据库版本 */
const static NSInteger DB_MANAGER_VER = 0;

@interface DBManager ()

@property (nonatomic, strong) FMDatabase * db;

@end

@implementation DBManager

static DBManager *_manager = nil;

+ (instancetype)shareManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (_manager == nil) {
            _manager = [[DBManager alloc]init];
        }
    });
    return _manager;
}

/**
 创建数据库和表
 */
- (void)createDBAndTable {
    
    NSString * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    //拼接文件名
    NSString * sqlitPath = [path stringByAppendingPathComponent:@"CZDataBase.sqlite"];
    NSLog(@"数据库路径:%@",sqlitPath);
    //创建数据库,加入到队列中
    self.db = [FMDatabase databaseWithPath:sqlitPath];
    
    NSInteger oldVersion = [[NSUserDefaults standardUserDefaults] integerForKey:kdbManagerVersion];
    if (oldVersion >= DB_MANAGER_VER) {
        if ([self.db open]) {
            BOOL result = [self.db executeUpdate:@"create table if not exists t_video (type text,product_id text,live_id text,user_id text)"];
            if (result) {
                NSLog(@"t_video表创建成功");
            } else {
                NSLog(@"t_video表创建失败");
            }
        } else {
            NSLog(@"数据库打开失败");
        }
    } else { //升级数据库
        [self upgrade];
    }
}

/**
 数据库升级
 */
- (void)upgrade {
    // 获取旧版本号
    NSInteger oldVersionNum = [[NSUserDefaults standardUserDefaults] integerForKey:kdbManagerVersion];
    // 升级
    [self upgrade:oldVersionNum];
    // 保存新版本号
    [[NSUserDefaults standardUserDefaults] setInteger:DB_MANAGER_VER forKey:kdbManagerVersion];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/**
 升级操作【版本0->版本1，版本1->版本2...】
 */
- (void)upgrade:(NSInteger)oldVersion {
    
    if (oldVersion >= DB_MANAGER_VER) {
        return;
    }
    switch (oldVersion) {
        case 0:
            NSLog(@"----0变1- 未做--");
            break;
        case 1:
            NSLog(@"----1变2- 未做--");
            break;
        default:
            break;
    }
    oldVersion++;
    // 判断是否需要升级
    [self upgrade:oldVersion];
}

/**
 新增视频数据
 @param item 视频model
 */
- (void)insertVideo:(VideoItem *)item {
    if ([[DBManager shareManager] existVideo:item]) {
        return;
    }
    BOOL result = [self.db executeUpdate:@"insert into t_video (type,product_id,live_id,user_id) values (?,?,?,?)",item.type,item.product_id,item.live_id,[UserInfo share].ID];
    if (result) {
        NSLog(@"新增视频数据成功");
    } else {
        NSLog(@"新增视频数据失败");
    }
}

/**
 删除视频数据
 @param item 视频model
 */
- (void)deleteVideo:(VideoItem *)item {
    BOOL result = [self.db executeUpdate:@"delete from t_video where product_id = ? and live_id = ? and user_id = ?",item.product_id,item.live_id,[UserInfo share].ID];
    if (result) {
        NSLog(@"删除视频数据成功");
    } else {
        NSLog(@"删除视频数据失败");
    }
}

/**
 查询某个视频数据是否存在
 
 @return YES/NO
 */
- (BOOL)existVideo:(VideoItem *)item {
    FMResultSet * setResult = [self.db executeQuery:@"select * from t_video where product_id = ? and live_id = ? and user_id = ?",item.product_id,item.live_id,[UserInfo share].ID];
    if ([setResult next]) {
        return YES;
    } else {
        return NO;
    }
}

/**
 查询所有视频数据
 
 @return 返回查询到的当前用户视频数据
 */
- (NSMutableArray *)getAllVideo {
    NSMutableArray * array = [NSMutableArray array];
    FMResultSet * setResult = [self.db executeQuery:@"select * from t_video where user_id = ?",[UserInfo share].ID];
    while ([setResult next]) {
        //先将数据存放到字典
        VideoItem *item = [[VideoItem alloc] init];
        item.type = [setResult stringForColumn:@"type"];
        item.product_id = [setResult stringForColumn:@"product_id"];
        item.live_id = [setResult stringForColumn:@"live_id"];
        //然后将字典存放到数组
        [array addObject:item];
    }
    return array;
}

@end
