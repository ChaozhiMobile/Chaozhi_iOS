//
//  NetworkManager.m
//  ArtEast
//
//  Created by yibao on 16/9/28.
//  Copyright © 2016年 北京艺宝网络文化有限公司. All rights reserved.
//

#import "NetworkManager.h"
#import <AFNetworking.h>
#import "NetworkUtil.h"
#import "Utils.h"
#import "BaseNC.h"

#define TIMEOUT 20;

static NetworkManager *_manager = nil;

@implementation NetworkManager

+ (instancetype)sharedManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[NetworkManager alloc] initWithBaseURL:[NSURL URLWithString:domainUrl()]];
    });
    return _manager;
}

- (void)postJSON:(NSString *)name
      parameters:(NSDictionary *)parameters
      completion:(RequestCompletion)completion {
    
    [self configNetManager];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",domainUrl(),name];
    
    [JHHJView showLoadingOnTheKeyWindowWithType:JHHJViewTypeSingleLine]; //开始加载
    
    [self POST:urlStr parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [JHHJView hideLoading]; //结束加载
        
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
        NSLog(@"状态码：%ld",(long)response.statusCode);
        if([self isTokenInvalid:(int)response.statusCode]) {
            return;
        }
        
        id _Nullable object = [NSDictionary changeType:responseObject];
        NSLog(@"参数%@%@\n返回结果：%@",urlStr,parameters,object);
        
        NSString *code = [NSString stringWithFormat:@"%@",object[@"code"]];
        if ([code isEqualToString:@"200"]) { //成功
            id _Nullable dataObject = object[@"data"];
            completion(dataObject,Request_Success,nil);
        } else {
            completion(nil,Request_Fail,nil);
            [Utils showToast:object[@"msg"]];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
        NSLog(@"状态码：%ld",(long)response.statusCode);
        if([self isTokenInvalid:(int)response.statusCode]) {
            return;
        }
        
        completion(nil,Request_TimeoOut,error);
        NSLog(@"参数%@%@\n%@请求失败信息：%@错误码：%ld",urlStr,parameters,name,[error localizedDescription],(long)[error code]);
        [Utils showToast:@"请求超时"];
        [JHHJView hideLoading]; //结束加载
    }];
}

- (void)getJSON:(NSString *)name
     parameters:(NSDictionary *)parameters
     completion:(RequestCompletion)completion {
    
    [self configNetManager];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",domainUrl(),name];
    
    [JHHJView showLoadingOnTheKeyWindowWithType:JHHJViewTypeSingleLine]; //开始加载
    
    [self GET:urlStr parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [JHHJView hideLoading]; //结束加载
        
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
        NSLog(@"状态码：%ld",(long)response.statusCode);
        if([self isTokenInvalid:(int)response.statusCode]) {
            return;
        }
        
        id _Nullable object = [NSDictionary changeType:responseObject];
        if ([object[@"code"] isEqualToString:@"200"]) { //成功
            id _Nullable dataObject = object[@"data"];
            if ([dataObject isKindOfClass:[NSString class]]) {
                completion(@"",Request_Success,nil);
            } else {
                completion(dataObject,Request_Success,nil);
            }
        } else {
            completion(nil,Request_Fail,nil);
            [Utils showToast:object[@"msg"]];
        }
        NSLog(@"参数%@%@\n返回结果：%@",urlStr,parameters,object);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
        NSLog(@"状态码：%ld",(long)response.statusCode);
        if([self isTokenInvalid:(int)response.statusCode]) {
            return;
        }
        
        completion(nil,Request_TimeoOut,error);
        NSLog(@"参数%@%@\n%@请求失败信息：%@",urlStr,parameters,name,[error localizedDescription]);
        [Utils showToast:@"请求超时"];
        [JHHJView hideLoading]; //结束加载
    }];
}

- (void)postJSON:(NSString *)name
      parameters:(NSDictionary *)parameters
      imageDataArr:(NSMutableArray *)imgDataArr
       imageName:(NSString *)imageName
      completion:(RequestCompletion)completion {
    
    [self configNetManager];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",domainUrl(),name];
    
    [JHHJView showLoadingOnTheKeyWindowWithType:JHHJViewTypeSingleLine]; //开始加载
    
    [self POST:urlStr parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        if (imgDataArr.count > 0) {
            //在网络开发中，上传文件时，是文件不允许被覆盖，文件重名。要解决此问题，可以在上传时使用当前的系统事件作为文件名
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyyMMddHHmmss";
            NSString *fileName = [formatter stringFromDate:[NSDate date]];
            
            for (int i = 0; i<imgDataArr.count; i++) {
                NSData *data = (NSData *)imgDataArr[i];
                if (data != NULL) {
                    [formData appendPartWithFileData:data name:imageName fileName:[NSString stringWithFormat:@"%@%d.png",fileName,i] mimeType:@"image/png"];
                }
            }
        }
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [JHHJView hideLoading]; //结束加载
        
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
        NSLog(@"状态码：%ld",(long)response.statusCode);
        if([self isTokenInvalid:(int)response.statusCode]) {
            return;
        }
        
        id _Nullable object = [NSDictionary changeType:responseObject];
        NSLog(@"参数%@%@\n返回结果：%@",urlStr,parameters,object);
        
        NSString *code = [NSString stringWithFormat:@"%@",object[@"code"]];
        if ([code isEqualToString:@"200"]) { //成功
            id _Nullable dataObject = object[@"data"];
            completion(dataObject,Request_Success,nil);
        } else {
            completion(nil,Request_Fail,nil);
            [Utils showToast:object[@"msg"]];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
        NSLog(@"状态码：%ld",(long)response.statusCode);
        if([self isTokenInvalid:(int)response.statusCode]) {
            return;
        }
        
        completion(nil,Request_TimeoOut,error);
        NSLog(@"参数%@%@\n%@请求失败信息：%@错误码：%ld",urlStr,parameters,name,[error localizedDescription],(long)[error code]);
        [Utils showToast:@"请求超时"];
        [JHHJView hideLoading]; //结束加载
    }];
}

//配置请求头
- (void)configNetManager {
    //请求
    self.requestSerializer = [AFJSONRequestSerializer serializer];
    self.requestSerializer.timeoutInterval = TIMEOUT;
    //响应
    AFJSONResponseSerializer *response = [AFJSONResponseSerializer serializer];
    //response.removesKeysWithNullValues = YES;
    self.responseSerializer = response;
    self.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"text/json", @"application/json", nil];
    
    if ([Utils isLoginWithJump:NO]) {
        NSLog(@"token值：%@",[UserInfo share].token);
        [self.requestSerializer setValue:[UserInfo share].token forHTTPHeaderField:@"token"];
    }
}

//token失效判断
- (BOOL)isTokenInvalid:(int)statusCode {
    if (statusCode==403) { //token失效或者账号在其它地方登录
        
        [Utils showToast:@"登录失效，请重新登录"];
        
        [[UserInfo share] setUserInfo:nil]; //清除用户信息
        
        //跳转到登录页
        [Utils isLoginWithJump:YES];
        
        return YES;
    } else {
        return NO;
    }
}

@end
