//
//  CommonRequest.h
//  Chaozhi
//  Notes：网络请求类(Post、Get、上传/下载图片)
//
//  Created by Jason_hzb on 2018/5/29.
//  Copyright © 2018年 小灵狗出行. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^ReqeustSucc)(NSDictionary *data);
typedef void (^ReqeustFailure)(NSString *content);

@interface CommonRequest : NSObject

@property(nonatomic, assign) int uploadType; //选择上传的类型

+ (instancetype)shareRequest;

/**
 GET请求

 @param url 接口地址
 @param param 参数
 @param success 成功回调
 @param failure 失败回调
 */
- (void)requestWithGet:(NSString *)url parameters:(NSDictionary *)param success:(ReqeustSucc)success failure:(ReqeustFailure)failure;

/**
 POST请求

 @param url 接口地址
 @param param 参数
 @param success 成功回调
 @param failure 失败回调
 */
- (void)requestWithPost:(NSString *)url parameters:(NSDictionary *)param success:(ReqeustSucc)success failure:(ReqeustFailure) failure;

/**
 文件上传POST

 @param url 接口地址
 @param param 参数
 @param success 成功回调
 @param failure 失败回调
 */
- (void)requestWithPostUpload:(NSString *)url parameters:(NSDictionary *)param success:(ReqeustSucc)success failure:(ReqeustFailure)failure;

/**
 单链接下载图片

 @param url 图片地址
 @param param 参数
 @return 处理后的图片地址
 */
- (NSString *)requestWithPostDownloadPic:(NSString *)url parameters:(NSDictionary *)param;

@end
