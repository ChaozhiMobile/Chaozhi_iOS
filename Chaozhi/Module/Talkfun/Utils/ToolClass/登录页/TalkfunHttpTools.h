//
//  TalkfunHttpRequest.h
//  TalkfunSDKDemo
//
//  Created by 孙兆能 on 16/9/26.
//  Copyright © 2016年 talk-fun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TalkfunHttpTools : NSObject

+ (void)post:(NSString *)url params:(NSDictionary *)params callback:(void (^)(id))callback;

@end
