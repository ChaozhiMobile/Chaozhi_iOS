//
//  TalkfunDownloadManager.h
//  TalkfunDownloadManager
//
//  Created by 孙兆能 on 16/7/22.
//  Copyright © 2016年 talk-fun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TalkfunSDK.h"
typedef void (^BGCompletedHandler)(void);
typedef void (^ TalkfunDiskLowReminderValueCallback)(void);

//下载状态(未开始  、 暂停  、 等待中 、 正在下载  、 下载完成 、 下载错误)
typedef enum {
    
    TalkfunDownloadStatusUnstart    = 0, //未开始
    TalkfunDownloadStatusPrepare    = 1, //等待中
    TalkfunDownloadStatusStart      = 2, //正在下载
    TalkfunDownloadStatusPause      = 3, //暂停
    TalkfunDownloadStatusFinish     = 4, //下载完成
    TalkfunDownloadStatusError      = 5  //下载错误
    
}TalkfunDownloadStatus;

/**
 *  缓存路径
 */
typedef enum {
    
    TalkfunCachePathDocuments = 0,
    TalkfunCachePathLibrary   = 1
    
}TalkfunCachePath;

@interface TalkfunDownloadManager : NSObject

@property (nonatomic, copy) BGCompletedHandler _Nullable completedHandler;


//下载线程数(最大为3）
@property (nonatomic,assign) NSInteger downloadThreadNumber;
@property (nonatomic,assign) TalkfunCachePath cachePath;



//警告磁盘空间不足
@property (nonatomic, copy) TalkfunDiskLowReminderValueCallback _Nullable diskLowReminderValueCallback;


/**
 *  默认值是200M (最小值为200)
 *  磁盘空间小于这个阀值,会停止下载,   diskLowReminderValueCallback弹窗提示
 */
@property(nonatomic,assign)NSInteger diskLowReminderValue;
/**
 *  单例
 */
+ (nullable id)shareManager;


/**
 *  开关日志输出
 */
- (void)setLogEnable:(BOOL)enable;


/**
 *  配置日志输出等级
 */
- (void)setLogLevel:(TalkfunLoggerLevel)level;

/**
 *  下载某个点播
 *
 *  @param access_token是点播的access_token（不可为空）
 *  @param placbackID是点播对应的ID（不可为空,用于区分离线数据）
 *  @param title是显示在下载列表中的title（可传nil,显示playbackID）
 */
- (void)appendDownloadWithAccessToken:(nonnull NSString *)access_token playbackID:(nonnull NSString *)playbackID title:(nullable NSString *)title;

/**
 *  下载某个点播
 *
 *  @param accessKey不可为空
 *  @param placbackID是点播对应的ID（不可为空,用于区分离线数据）
 *  @param title是显示在下载列表中的title（可传nil,显示playbackID）
 */
- (void)appendDownloadWithAccessKey:(nonnull NSString *)accessKey playbackID:(nonnull NSString *)playbackID title:(nullable NSString *)title;

/**
 *  获取下载列表
 */
- (nullable NSArray *)getDownloadList;

/**
 *  根据状态获取相应的下载列表
 */
- (nullable NSArray *)getDownloadListWithStatus:(TalkfunDownloadStatus)downloadStatus;

/**
 *  全部下载任务暂停
 */
- (void)pauseAllDownload;

/**
 *  开始对应的下载任务
 *
 *  playbackID是对应的任务
 */
- (void)startDownload:(nonnull NSString *)playbackID;

/**
 *  暂停对应的下载任务
 *
 *  playbackID是对应的任务
 */
- (void)pauseDownload:(nonnull NSString *)playbackID;

/**
 *  删除对应的点播
 *
 *  删除是否成功的信息在callback中
 */
- (void)deleteDownload:(nonnull NSString *)playbackID success:(void (^ __nullable)(id __nullable result))successBlock;


/**
 *  监听事件，处理回调数据
 *
 *  监听事件，event为事件名，获取的数据在回调的callback里面
 **/
- (void)on:(nullable NSString *)event callback:(void (^__nullable)(id __nullable result))callback;

/**
 *  监听事件，处理回调数据
 *
 *  监听事件，event为事件名，获取的数据在回调的callback里面
 **/
- (void)on:(nullable NSString *)event withCallback:(void (^__nullable)(id __nullable result))callback NS_DEPRECATED(2_0, 2_0, 2_0, 2_0, "该方法已过期");

/**
 *  判断下载列表是否有对应playbackID
 **/
- (BOOL)containsPlaybackID:(nonnull NSString *)playbackID;

/**
 *  按照playbackID获取对应信息
 **/
- (nullable id)getInfoWithPlaybackID:(nonnull NSString *)playbackID;

/**
 *  这个课程是否下载完成
 **/

- (BOOL)isFinishDownload:(NSString *_Nullable)playbackID;


//
//-(void)addCompletionHandler:(BGCompletedHandler _Nonnull )handler identifier:(NSString *_Nullable)identifier;

//回放视频类型。1：普通大班回放，2：纯视频类型回放
- (NSString*_Nullable)getVideoType:(NSString*_Nonnull)playbackID;
@end
