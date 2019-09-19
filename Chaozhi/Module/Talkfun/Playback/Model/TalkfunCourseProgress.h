//
//  TalkfunPlayProgressManagement.h
//  TalkfunSDKDemo
//
//  Created by 莫瑞权 on 2019/3/14.
//  Copyright © 2019年 Talkfun. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface TalkfunCourseProgress : NSObject



//保存进度
+(void)setPlay:(NSInteger)roomId   progress:(NSInteger)second;
//读取
+(NSInteger)getPlayProgress:(NSInteger)roomId;
@end


