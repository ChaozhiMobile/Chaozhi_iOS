//
//  NetworkManager.h
//  ArtEast
//
//  Created by yibao on 16/9/28.
//  Copyright © 2016年 北京艺宝网络文化有限公司. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

typedef enum
{
    Request_Success = 0,  // 请求结果返回成功
    Request_Fail = 1,     // 请求结果返回失败
    Request_TimeoOut = 2, // 请求超时
    Request_NonNet = 3,   // 无网
}RequestState;

typedef void(^RequestCompletion)(id responseData,RequestState status,NSError *error);

@interface NetworkManager : AFHTTPSessionManager

+ (instancetype)sharedManager;

/**
 *  POST请求
 *
 *  @param name       接口名称
 *  @param parameters 传参
 *  @param completion 结果回调
 */
- (void)postJSON:(NSString *)name
      parameters:(NSDictionary *)parameters
      completion:(RequestCompletion)completion;

/**
 *  GET请求
 *
 *  @param name       接口名称
 *  @param parameters 传参
 *  @param completion 结果回调
 */
- (void)getJSON:(NSString *)name
     parameters:(NSDictionary *)parameters
     completion:(RequestCompletion)completion;

/**
 *  POST请求【上传单张或者多张图片】
 *
 *  @param name       接口名称
 *  @param parameters 传参
 *  @param imgDataArr   二进制图片数组
 *  @param completion 结果回调
 */
- (void)postJSON:(NSString *)name
      parameters:(NSDictionary *)parameters
       imageDataArr:(NSMutableArray *)imgDataArr
       imageName:(NSString *)imageName
      completion:(RequestCompletion)completion;


@end
