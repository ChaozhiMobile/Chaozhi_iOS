//
//  NetworkManager.m
//  ArtEast
//
//  Created by yibao on 16/9/28.
//  Copyright © 2016年 北京艺宝网络文化有限公司. All rights reserved.
//

#import "NetworkManager.h"
#import <AFNetworking.h>
#import "Utils.h"
#import "XLGExternalTestTool.h"

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
    
    if (![Utils getNetStatus]) {
        [Utils showToast:@"检测到您的网络异常，请检查网络"];
        return;
    }
    
    [self configNetManager];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",domainUrl(),name];
    
    [JHHJView showLoadingOnTheKeyWindowWithType:JHHJViewTypeSingleLine]; //开始加载
    
    NSMutableDictionary *paramDic = [parameters mutableCopy];
    if ([Utils isLoginWithJump:NO]) {
        NSLog(@"token值：%@",[UserInfo share].token);
        [paramDic setObject:[UserInfo share].token forKey:@"token"];
    }

    [self POST:urlStr parameters:paramDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [JHHJView hideLoading]; //结束加载
        
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
        NSLog(@"状态码：%ld",(long)response.statusCode);
        if([self isTokenInvalid:(int)response.statusCode]) {
            return;
        }
        
        id _Nullable object = [NSDictionary changeType:responseObject];
        [self printLogInfoWith:urlStr WithParam:paramDic andResult:object];
        
        NSString *code = [NSString stringWithFormat:@"%@",object[@"code"]];
        if ([code isEqualToString:@"200"]) { //成功
            id _Nullable dataObject = object[@"data"];
            completion(dataObject,Request_Success,nil);
        } else if ([code intValue]>=600&&[code intValue]<700) { //重新登录
            [self reLogin];
        } else if ([code isEqualToString:@"210"]&&[name isEqualToString:URL_CheckVersion]) {
            //已经是最新版本
        }
        else {
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
        [self printLogInfoWith:urlStr WithParam:paramDic andResult:[error localizedDescription]];
        [Utils showToast:@"请求超时"];
        [JHHJView hideLoading]; //结束加载
    }];
}

- (void)getJSON:(NSString *)name
     parameters:(NSDictionary *)parameters
     completion:(RequestCompletion)completion {
    
    if (![Utils getNetStatus]) {
        [Utils showToast:@"检测到您的网络异常，请检查网络"];
        return;
    }
    
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
        } else if ([object[@"code"] intValue]>=600&&[object[@"code"] intValue]<700) { //重新登录
            [self reLogin];
        }
        else {
            completion(nil,Request_Fail,nil);
            [Utils showToast:object[@"msg"]];
        }
        [self printLogInfoWith:urlStr WithParam:parameters andResult:object];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
        NSLog(@"状态码：%ld",(long)response.statusCode);
        if([self isTokenInvalid:(int)response.statusCode]) {
            return;
        }
        
        completion(nil,Request_TimeoOut,error);
        [self printLogInfoWith:urlStr WithParam:parameters andResult:[error localizedDescription]];
        [Utils showToast:@"请求超时"];
        [JHHJView hideLoading]; //结束加载
    }];
}

- (void)postJSON:(NSString *)name
      parameters:(NSDictionary *)parameters
      imageDataArr:(NSMutableArray *)imgDataArr
       imageName:(NSString *)imageName
      completion:(RequestCompletion)completion {
    
    if (![Utils getNetStatus]) {
        [Utils showToast:@"检测到您的网络异常，请检查网络"];
        return;
    }
    
    [self configNetManager];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",domainUrl(),name];
    
    [JHHJView showLoadingOnTheKeyWindowWithType:JHHJViewTypeSingleLine]; //开始加载
    
    NSMutableDictionary *paramDic = [parameters mutableCopy];
    if ([Utils isLoginWithJump:NO]) {
        NSLog(@"token值：%@",[UserInfo share].token);
        [paramDic setObject:[UserInfo share].token forKey:@"token"];
    }
    
    [self POST:urlStr parameters:paramDic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
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
        [self printLogInfoWith:urlStr WithParam:paramDic andResult:object];
        
        NSString *code = [NSString stringWithFormat:@"%@",object[@"code"]];
        if ([code isEqualToString:@"200"]) { //成功
            id _Nullable dataObject = object[@"data"];
            completion(dataObject,Request_Success,nil);
        } else if ([code intValue]>=600&&[code intValue]<700) { //重新登录
            [self reLogin];
        }
        else {
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
        [self printLogInfoWith:urlStr WithParam:paramDic andResult:[error localizedDescription]];
        [Utils showToast:@"请求超时"];
        [JHHJView hideLoading]; //结束加载
    }];
}

- (void)printLogInfoWith:(NSString *)url WithParam:(id)param andResult:(id)result {
    NSLog(@"%@",[NSString stringWithFormat:@"时间：%@\n参数：%@ \n %@\n返回结果：%@",[Utils getCurrentDate],url,param,result]);
    if (!KOnline) {
        XLGExternalTestTool *tool = [XLGExternalTestTool shareInstance];
        tool.logTextViews.text = [NSString stringWithFormat:@"时间：%@\n参数：%@ \n %@\n返回结果：%@ \n\n\n%@",[Utils getCurrentDate],url,param,result,tool.logTextViews.text];
    }
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
    
//    if ([Utils isLoginWithJump:NO]) {
//        NSLog(@"token值：%@",[UserInfo share].token);
//        [self.requestSerializer setValue:[UserInfo share].token forHTTPHeaderField:@"Token"];
//    }
}

//token失效判断
- (BOOL)isTokenInvalid:(int)statusCode {
    if (statusCode==403) { //token失效或者账号在其它地方登录
        [self reLogin];
        return YES;
    } else {
        return NO;
    }
}

// 重新登录
- (void)reLogin {
    [Utils showToast:@"登录失效，请重新登录"];
    [[UserInfo share] setUserInfo:nil]; //清除用户信息
    //跳转到登录页
    [Utils isLoginWithJump:YES];
}

@end
