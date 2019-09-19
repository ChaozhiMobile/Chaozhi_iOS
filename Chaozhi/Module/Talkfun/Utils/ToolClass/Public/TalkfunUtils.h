//
//  TalkfunTools.h
//  TalkfunMediaPlayerDemo
//
//  Created by LuoLiuyou on 16/7/5.
//  Copyright © 2016年 luoliuyou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface TalkfunUtils : NSObject

//获取字符串的MD5
+ (NSString *)md5:(NSString *)string;

//获取data的MD5
+ (NSString*)getMd5_32Bit_Data:(NSData*)data;

//获取时间戳
+ (NSInteger)getTimestamp;

//urlEncode
+ (NSString *)urlencode:(NSString *)input;

//获取手机UUID
+ (NSString *)UUID;

//字典转为字符串
+ (NSString *)jsonEncode:(NSDictionary *)input;

//获取名字跟时间
+ (NSMutableAttributedString *)getUserNameAndTimeWith:(NSDictionary *)params playback:(BOOL)playback;

//根据提供的字符串、最大size和字符串字体大小获取CGRect
+ (CGRect)getRectWithString:(NSString *)string size:(CGSize)size fontSize:(CGFloat)fontSize;

//根据提供的字符串、最大size和字符串字体大小获取CGRect(传入属性值)
+ (CGRect)getRectWithString:(NSString *)string size:(CGSize)size fontSize:(CGFloat)fontSize attributes:(NSDictionary<NSString *, id> *)attributes;

//图文混排
+ (NSDictionary *)assembleAttributeString:(NSString *)string boundingSize:(CGSize)size fontSize:(CGFloat)fontSize shadow:(BOOL)shadow;

//提供字节数计算出文件大小
+ (NSString *)fileSizeWithInterge:(NSInteger)size;

//图片修正方向
+ (UIImage *)fixOrientation:(UIImage *)aImage;

//图片压缩
+ (UIImage*)imageWithImage:(UIImage*)image;

//获取图片大小
+ (CGFloat)getSize:(UIImage *)image;

@end
