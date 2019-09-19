//
//  TalkfunHttpRequest.m
//  TalkfunSDKDemo
//
//  Created by 孙兆能 on 16/9/26.
//  Copyright © 2016年 talk-fun. All rights reserved.
//

#import "TalkfunHttpTools.h"

@implementation TalkfunHttpTools

+ (void)post:(NSString *)url params:(NSDictionary *)params callback:(void (^)(id))callback
{
    NSURL *urlReq = [NSURL URLWithString:url];
    NSError *error;
    //拼接字符串
    NSMutableArray *array = [NSMutableArray array];
    for (NSString *key in params) {
        NSString *value = [params objectForKey:key];
        
        if([value isKindOfClass:[NSDictionary class]]
           || [value isKindOfClass:[NSMutableDictionary class]]
           || [value isKindOfClass:[NSArray class]]
           || [value isKindOfClass:[NSMutableArray class]]
           ){
            
            NSData *offersJSONData = [NSJSONSerialization dataWithJSONObject:value options:0 error:&error];
            [array addObject:[NSString stringWithFormat:@"%@=%@", key,[self urlencode:[[NSString alloc] initWithData:offersJSONData encoding:NSUTF8StringEncoding]]]];
        }else{
            [array addObject:[NSString stringWithFormat:@"%@=%@", key, value]];
        }
    }
    NSString * paramStr = [array componentsJoinedByString:@"&"];
    
    //创建请求
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:urlReq cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10];
    //将字符串转换为NSData对象
    NSData *data = [paramStr dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    [request setHTTPMethod:@"POST"];
    
    //创建异步连接
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionTask *task = [session dataTaskWithRequest:request
                                        completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                            /*
                                            NSMutableDictionary *retval = [[NSMutableDictionary alloc] init];
                                            if(!error){
                                                NSError *err;
                                                //把服务器返回的json字符串的Data转成字典
                                                NSMutableDictionary *parse = [NSJSONSerialization JSONObjectWithData:data options:0 error:&err];
                                                
                                                if(err){
                                                    NSHTTPURLResponse * res = (NSHTTPURLResponse *)response;
                                                    NSLog(@"statusCode:%ld",(long)res.statusCode);
                                                    [retval setObject:@(res.statusCode) forKey:@"code"];
                                                    [retval setObject:response forKey:@"msg"];
                                                }else{
                                                    retval = parse;
                                                }
                                            }else{
                                                NSLog(@"asdfadfff:%@ %@",error.userInfo[NSLocalizedDescriptionKey],error.userInfo[NSURLErrorFailingURLStringErrorKey]);
                                                [retval setObject:@(-101) forKey:@"code"];
                                                [retval setObject:@"访问网络失败" forKey:@"msg"];
                                            }
                                            
                                            if (callback) {
                                                callback(retval);
                                            }
                                             */
                                            if (error) {
                                                if (callback) {
                                                    callback(error);
                                                }
                                            }
                                            else{
                                                NSError * err = nil;
                                                NSDictionary *dic =[NSJSONSerialization JSONObjectWithData:data options:0 error:&err];
                                                
                                                if (err) {
                                                    //NSLog(@"errrrrr:%@ url:%@",err,response.URL.absoluteString);
                                                    if (callback) {
                                                        callback(err);
                                                    }
                                                    
                                                }
                                                else{
                                                    callback(dic);
                                                }
                                            }
                                            
                                        }];
    
    [task resume];
    
}

+ (NSString *)urlencode: (NSString *) input
{
    NSString *escapedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                                                                    NULL,
                                                                                                    (__bridge CFStringRef) input,
                                                                                                    NULL,
                                                                                                    CFSTR("!*'();:@&=+$,/?%#[]\" "),
                                                                                                    kCFStringEncodingUTF8));
    
    return escapedString;
}

@end
