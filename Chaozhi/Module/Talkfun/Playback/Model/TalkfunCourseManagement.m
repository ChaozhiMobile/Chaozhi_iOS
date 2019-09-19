//
//  TalkfunPlayProgressManagement.m
//  TalkfunSDKDemo
//
//  Created by 莫瑞权 on 2019/3/14.
//  Copyright © 2019年 Talkfun. All rights reserved.
//
#define playProgressKey  @"TalkfunPlayProgressKey"

#import "TalkfunCourseManagement.h"

@implementation TalkfunCourseManagement


//保存进度
+(void)setPlay:(NSInteger)roomId   progress:(NSInteger)second
{
    // 6.回到主线程更新UI
    dispatch_async(dispatch_get_main_queue(), ^{
        //所有已经保存的房间进度
        NSMutableArray *allPlayProgress =[NSMutableArray arrayWithArray: [self getAllPlayProgress]];
        if (allPlayProgress.count>100) {
            [allPlayProgress removeObjectAtIndex:0];
        }

//   [arr replaceObjectAtIndex:索引 withObject:替换的元素];
        NSInteger    Index = 0;
        
        NSMutableDictionary *copyDict = nil;
        for (NSInteger i = 0; i < allPlayProgress.count; i ++) {
           NSDictionary*dict =   allPlayProgress[i];
          //找到已经存在的人
          if ([dict[@"roomId"] integerValue]==roomId) {
      
              Index = i;
              copyDict = [NSMutableDictionary dictionaryWithDictionary:dict];
              [copyDict setObject:@(second) forKey:@"second"];
              break;
          }
          
        }
        
        
        //找到了替换 //更新存在的进度
        if (copyDict) {
            [allPlayProgress replaceObjectAtIndex:Index withObject:copyDict];
            
        }else{
            //新添一个进度
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setObject:@(roomId) forKey:@"roomId"];
            [dict setObject:@(second) forKey:@"second"];
            
            [allPlayProgress addObject:dict];
        }
        
        //本地保存进度
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:allPlayProgress forKey:playProgressKey];
        [userDefaults synchronize];
        
    });

   
}

+(NSMutableArray*)getAllPlayProgress
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *array = [defaults objectForKey:playProgressKey];
    [defaults synchronize];
    if (array) {
        return array;
    }else{
        return [NSMutableArray array];
    }
}
//读取
+(NSInteger)getPlayProgress:(NSInteger)roomId
{
    
      NSInteger second  = 0;
    
    //所有已经保存的房间进度
    NSMutableArray *allPlayProgress =[NSMutableArray arrayWithArray: [self getAllPlayProgress]];

    //更新存在的进度
    for (NSMutableDictionary *dict in allPlayProgress) {
        //找到已经存在的人
        if ([dict[@"roomId"] integerValue]==roomId) {
           
            second = [dict[@"second"] integerValue];
        }
    }
    
    return second;
    
}

//=================================================================
+(NSMutableArray*)getAllLogoUrl
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *array = [defaults objectForKey:@"TalkfunLogoUrl"];
    [defaults synchronize];
    if (array) {
        return array;
    }else{
        return [NSMutableArray array];
    }
}
//保存进度
+(void)saveLogoUrl:(NSString*)url   roomId:(NSInteger)roomId  title:(NSString*)title
{
    if (url&&title) {
        
    
    // 6.回到主线程更新UI
    dispatch_async(dispatch_get_main_queue(), ^{
        //所有已经保存的房间进度
        NSMutableArray *allUrl =[NSMutableArray arrayWithArray: [self getAllLogoUrl]];
        if (allUrl.count>100) {
            [allUrl removeObjectAtIndex:0];
        }
        //         [arr replaceObjectAtIndex:索引 withObject:替换的元素];
        NSInteger    Index = 0;
        
        NSMutableDictionary *copyDict = nil;
        for (NSInteger i = 0; i < allUrl.count; i ++) {
            NSDictionary*dict =   allUrl[i];
            //找到已经存在的人
            if ([dict[@"roomId"] integerValue]==roomId) {
                
                Index = i;
                copyDict = [NSMutableDictionary dictionaryWithDictionary:dict];
                [copyDict setObject:url forKey:@"url"];
                [copyDict setObject:title forKey:@"title"];
                
                break;
            }
            
        }
        
        
        //找到了替换 //更新存在的进度
        if (copyDict) {
            [allUrl replaceObjectAtIndex:Index withObject:copyDict];
            
        }else{
            //新添一个进度
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setObject:@(roomId) forKey:@"roomId"];
            [dict setObject:url forKey:@"url"];
            [dict setObject:title forKey:@"title"];
            
            [allUrl addObject:dict];
        }
        
        //本地保存进度
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:allUrl forKey:@"TalkfunLogoUrl"];
        [userDefaults synchronize];
        
    });
    
    }
}
//读取
+(NSDictionary*)getLogoUrl:(NSInteger)roomId
{
    
    NSMutableDictionary* copyDict  = nil;
    
    //所有已经保存的房间进度
    NSMutableArray *allPlayProgress =[NSMutableArray arrayWithArray: [self getAllLogoUrl]];
    

    //更新存在的进度
    for (NSMutableDictionary *dict in allPlayProgress) {
        //找到已经存在的人
        if ([dict[@"roomId"] integerValue]==roomId) {
            
            copyDict = [NSMutableDictionary dictionaryWithDictionary:dict ] ;
        }
    }
    
    return copyDict?copyDict:@{};
    
}
+(BOOL)skipAdvertising:(NSInteger)roomId
{
    
     NSMutableArray *allPlayProgress =[NSMutableArray arrayWithArray: [self getAdvertising]];
    
    BOOL skip = NO;
    for (NSDictionary *dict in allPlayProgress) {
        if ([dict[@"roomId"] integerValue]==roomId) {
            skip = YES;
            break;
        }
    }
   
    return skip;
}
+(void)saveSkip:(NSInteger)roomId
{
    // 6.回到主线程更新UI
    dispatch_async(dispatch_get_main_queue(), ^{
        //所有已经保存的房间进度
        NSMutableArray *allPlayProgress =[NSMutableArray arrayWithArray: [self getAdvertising]];
        if (allPlayProgress.count>100) {
            [allPlayProgress removeObjectAtIndex:0];
        }
        
        //   [arr replaceObjectAtIndex:索引 withObject:替换的元素];
        NSInteger    Index = 0;
        
        NSMutableDictionary *copyDict = nil;
        for (NSInteger i = 0; i < allPlayProgress.count; i ++) {
            NSDictionary*dict =   allPlayProgress[i];
            //找到已经存在的人
            if ([dict[@"roomId"] integerValue]==roomId) {
                
                Index = i;
                copyDict = [NSMutableDictionary dictionaryWithDictionary:dict];

                break;
            }
            
        }
        
        
        //找到了替换 //更新存在的进度
        if (copyDict) {
            [allPlayProgress replaceObjectAtIndex:Index withObject:copyDict];
            
        }else{
            //新添一个进度
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setObject:@(roomId) forKey:@"roomId"];

            
            [allPlayProgress addObject:dict];
        }
        
        //本地保存进度
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:allPlayProgress forKey:@"TalkfunAdvertising"];
        [userDefaults synchronize];
        
    });

}
+(NSMutableArray*)getAdvertising
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *array = [defaults objectForKey:@"TalkfunAdvertising"];
    [defaults synchronize];
    if (array) {
        return array;
    }else{
        return [NSMutableArray array];
    }
}
@end
