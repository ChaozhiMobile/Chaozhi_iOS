//
//  TalkfunPlayProgressManagement.h
//  TalkfunSDKDemo
//
//  Created by 莫瑞权 on 2019/3/14.
//  Copyright © 2019年 Talkfun. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface TalkfunCourseManagement : NSObject



//保存进度
+(void)setPlay:(NSInteger)roomId   progress:(NSInteger)second;
//读取
+(NSInteger)getPlayProgress:(NSInteger)roomId;



//保存url
+(void)saveLogoUrl:(NSString*)url   roomId:(NSInteger)roomId  title:(NSString*)title;

//读取
+(NSDictionary*)getLogoUrl:(NSInteger)roomId;


//是否能跳过广告
+(BOOL)skipAdvertising:(NSInteger)roomId;
+(void)saveSkip:(NSInteger)roomId;
@end


