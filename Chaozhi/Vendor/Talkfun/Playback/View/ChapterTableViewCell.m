//
//  ChapterTableViewCell.m
//  Talkfun_demo
//
//  Created by talk－fun on 15/12/25.
//  Copyright © 2015年 talk-fun. All rights reserved.
//

#import "ChapterTableViewCell.h"
#import "ChapterModel.h"
#import "NSString+Hashing.h"
#import <SDWebImage/SDWebImageManager.h>
#import "TalkfunCacheImage.h"
#define FilePath [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/ImageCaches"]
@interface ChapterTableViewCell()
@property(nonatomic,strong)TalkfunCacheImage *dataManager;
@end
@implementation ChapterTableViewCell
- (TalkfunCacheImage *)dataManager
{
    if (_dataManager==nil) {
        _dataManager = [[TalkfunCacheImage alloc] init];
    }
    return _dataManager;
}
- (void)setModel:(ChapterModel *)Model

{  _Model = Model;
    self.course.textColor = [UIColor whiteColor];
    self.course.text                = Model.course;
    self.page.textColor = [UIColor whiteColor];
    NSString * starttime = [self getTimeStr:[Model.starttime floatValue]];
    self.page.text                  = [NSString stringWithFormat:@"第%@页（%@）",Model.page,starttime];
    self.chapter.backgroundColor    = [UIColor clearColor];
    self.chapter.textColor          = LIGHTBLUECOLOR;
    self.chapter.text               = [NSString stringWithFormat:@"第%ld章",(long)self.number];
    self.chapter.layer.cornerRadius = 5;
    self.chapter.clipsToBounds      = YES;
    //    self.chapter.alpha              = 0.65;
    //        cell.selected = NO;
    self.backgroundColor =[UIColor clearColor];
    if ([self.selectedArray[self.number] integerValue] == 1) {
        //            cell.selected = YES;
        self.backgroundColor         = [UIColor colorWithRed:200 / 255.0 green:200 / 255.0 blue:200 / 255.0 alpha:1];
        self.chapter.backgroundColor = [UIColor colorWithRed:68 / 255.0 green:135 / 255.0 blue:1 alpha:1];
        //        self.chapter.alpha           = 1;
        self.chapter.text            = @"播放中";
        self.chapter.textColor       = [UIColor whiteColor];
    }
    
    
    UIImage * cachedImage = [self.dataManager getImageWithUrlString:Model.thumb];
    if(cachedImage){
           self.thumb.image = cachedImage;
        
        return;
    }
    
    
    
    WeakSelf
    SDWebImageManager * manager = [SDWebImageManager sharedManager];
    [manager loadImageWithURL:[NSURL URLWithString: Model.thumb] options:32 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        
    } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (image) {
                weakSelf.thumb.image = image;
            }
            
            if (error && ![Model.thumb hasPrefix:@"http"] && [Model.course isEqualToString:@"黑板"]) {
                weakSelf.page.text                  = [NSString stringWithFormat:@"黑板%@（%@）",Model.page,starttime];
                weakSelf.thumb.image = [UIImage imageNamed:@"blackboard"];
            }
        });
    }];
    /*
     dispatch_queue_t queue = dispatch_queue_create("chapter", DISPATCH_QUEUE_CONCURRENT);
     dispatch_async(queue, ^{
     
     NSData * data = [self getDataWithUrlStringAndParams:Model.thumb withTimeInterval:7200 inFilePath:FilePath];
     if (data == nil) {
     
     data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:Model.thumb]];
     [self saveData:data WithUrlStringAndParams:Model.thumb inFilePath:FilePath];
     
     }
     
     dispatch_async(dispatch_get_main_queue(), ^{
     
     self.thumb.image = [UIImage imageWithData:data];
     
     if ([self.selectedArray[self.number] integerValue] == 1) {
     
     self.backgroundColor = NEWBLUECOLOR;
     //                self.backgroundColor         = [UIColor colorWithRed:200 / 255.0 green:200 / 255.0 blue:200 / 255.0 alpha:1];
     self.chapter.backgroundColor = [UIColor colorWithRed:68 / 255.0 green:135 / 255.0 blue:1 alpha:1];
     //                self.chapter.alpha           = 1;
     
     }
     
     });
     });
     */
    if (self.rotated) {
        self.course.hidden = YES;
        self.page.hidden = YES;
    }
    else
    {
        self.course.hidden = NO;
        self.page.hidden = NO;
    }
}

#pragma mark - 缓存
- (void)saveData:(NSData *)data WithUrlStringAndParams:(NSString *)string inFilePath:(NSString *)filePath
{
    NSString * str = [string MD5Hash];
    NSString * fileP = [filePath stringByAppendingPathComponent:str];
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    [data writeToFile:fileP atomically:YES];
}

- (NSData *)getDataWithUrlStringAndParams:(NSString *)string withTimeInterval:(NSTimeInterval)interval inFilePath:(NSString *)filePath
{
    NSDate * date = [self calculateTimeIntervalWithString:string inFilePath:filePath];
    NSTimeInterval realInterval = [[NSDate date] timeIntervalSinceDate:date];
    if (realInterval > interval) {
        return nil;
    }
    
    NSString * str  = [string MD5Hash];
    NSString * path = [filePath stringByAppendingPathComponent:str];
    NSData * data   = [[NSData alloc] initWithContentsOfFile:path];
    
    return data;
}
- (NSDate *)calculateTimeIntervalWithString:(NSString *)string inFilePath:(NSString *)filePath
{
    NSString * str      = [string MD5Hash];
    NSString * path     = [filePath stringByAppendingPathComponent:str];
    NSDictionary * dict = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil];
    NSDate * date       = dict[NSFileModificationDate];
    return date;
}
- (NSString *)getTimeStr:(CGFloat)duration{
    NSInteger hour   = duration / 3600;
    NSInteger minute = (duration - hour * 3600) / 60;
    NSInteger second = duration - minute * 60 - hour * 3600;
    return [NSString stringWithFormat:@"%02ld:%02ld:%02ld",(long)hour,(long)minute,(long)second];
}
@end
