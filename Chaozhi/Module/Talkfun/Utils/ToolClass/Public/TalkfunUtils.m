//
//  TalkfunTools.m
//  TalkfunMediaPlayerDemo
//
//  Created by LuoLiuyou on 16/7/5.
//  Copyright © 2016年 luoliuyou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TalkfunUtils.h"
#import <CommonCrypto/CommonDigest.h>
#import <sys/sysctl.h>
#import <net/if.h>
#import <net/if_dl.h>

#define BEGIN_FLAG @"["
#define END_FLAG @"]"
#define KFacialSizeHeight 18
#define KFacialSizeWidth  18
#define MAX_WIDTH [UIScreen mainScreen].bounds.size.width - 40

//typedef NS_ENUM(NSInteger, TFDirectory) {
//    TFDirectoryDocuments     = 0,
//    TFDirectoryLibrary      = 1,
//    TFDirectoryTemp         = 2,
//};

@implementation TalkfunUtils

+ (NSString *)md5:(NSString *)string
{
    const char *cStr = [string UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (int)strlen(cStr), result);
    return [[NSString stringWithFormat:
            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]] lowercaseString];
}

+ (NSString*)getMd5_32Bit_Data:(NSData*)data
{
    
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5((data.bytes),(CC_LONG)(data.length) ,digest);
    
    NSMutableString*result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH*2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++){
        
        [result appendFormat:@"%02x", digest[i]];
    }
    
    return result;
}

+ (NSInteger)getTimestamp
{
    return (NSInteger)[[NSDate date] timeIntervalSince1970];
}

//获取手机UUID  
+ (NSString *)UUID
{
    return [[[UIDevice currentDevice] identifierForVendor] UUIDString];
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
/*
+ (NSString *)jsonEncode:(NSArray *)input {
    NSError *error;
    
    NSData *offersJSONData = [NSJSONSerialization dataWithJSONObject:input options:0 error:&error];
    
    return [[NSString alloc] initWithData:offersJSONData encoding:NSUTF8StringEncoding];
}
 */

+ (NSString *)jsonEncode:(NSDictionary *)input {
    NSError *error;
    NSData *offersJSONData = [NSJSONSerialization dataWithJSONObject:input options:0 error:&error];
    return [[NSString alloc] initWithData:offersJSONData encoding:NSUTF8StringEncoding];
}

////获取沙盒路径
//+ (NSString *)stringWithDirectory:(TFDirectory)name
//{
//    NSString * directory;
//    
//    switch (name) {
//        case TFDirectoryDocuments: {
//            directory = @"Documents";
//            break;
//        } case TFDirectoryLibrary: {
//            directory = @"Library/Caches/TalkfunCloudLive";
//            break;
//        } case TFDirectoryTemp: {
//            directory = @"tmp";
//            break;
//        }
//        default:
//            break;
//    }
//    NSString * path = [NSHomeDirectory() stringByAppendingPathComponent:directory];
//    
//    if(![[NSFileManager defaultManager] fileExistsAtPath:path])
//    {
//        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
//    }
//    return path;
//}

+ (CGRect)getRectWithString:(NSString *)string size:(CGSize)size fontSize:(CGFloat)fontSize
{
    if ([string isKindOfClass:[NSString class]]) {
        NSStringDrawingOptions opts = NSStringDrawingUsesLineFragmentOrigin |
        NSStringDrawingUsesFontLeading;
        
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
        [style setLineBreakMode:NSLineBreakByWordWrapping];
        
        NSDictionary *attributes = @{ NSFontAttributeName : [UIFont systemFontOfSize:fontSize], NSParagraphStyleAttributeName : style };
        
        CGRect frame = [string boundingRectWithSize:size options:opts attributes:attributes context:nil];
        CGRect rect = CGRectMake(frame.origin.x, frame.origin.y, ceil(frame.size.width), ceil(frame.size.height));
        return rect;
    }
    else
    {
        return CGRectZero;
    }
}

//根据提供的字符串、最大size和字符串字体大小获取CGRect(传入属性值)
+ (CGRect)getRectWithString:(NSString *)string size:(CGSize)size fontSize:(CGFloat)fontSize attributes:(NSDictionary<NSString *, id> *)attributes
{
    if ([string isKindOfClass:[NSString class]]) {
        NSStringDrawingOptions opts = NSStringDrawingUsesLineFragmentOrigin |
        NSStringDrawingUsesFontLeading;
        
//        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
//        [style setLineBreakMode:NSLineBreakByWordWrapping];
//        
//        NSDictionary *attributes = @{ NSFontAttributeName : [UIFont systemFontOfSize:fontSize], NSParagraphStyleAttributeName : style };
        
        CGRect frame = [string boundingRectWithSize:size options:opts attributes:attributes context:nil];
        CGRect rect = CGRectMake(frame.origin.x, frame.origin.y, ceil(frame.size.width), ceil(frame.size.height));
        return rect;
    }
    else
    {
        return CGRectZero;
    }
}

//获取mac地址
+ (NSString *)getMacAddress
{
    return [[UIDevice currentDevice].identifierForVendor UUIDString];
}

+ (NSMutableAttributedString *)getUserNameAndTimeWith:(NSDictionary *)params playback:(BOOL)playback
{
    if (playback) {
        NSString * userName  = params[@"nickname"];
        NSString * starttime = params[@"time"];
        if (!starttime) {
            starttime = params[@"startTime"];
        }
        NSInteger time       = [starttime integerValue];
        NSInteger hour       = time / 3600;
        NSInteger minutes    = (time - hour * 3600) / 60;
        NSInteger second     = time - minutes * 60 - hour * 3600;

        if (hour==00) {
            return [TalkfunUtils getAttributeNameStr:[NSString stringWithFormat:@"%@ %02ld:%02ld",userName,(long)minutes,(long)second] range:NSMakeRange(0, userName.length)];
        }else{
            return [TalkfunUtils getAttributeNameStr:[NSString stringWithFormat:@"%@ %02ld:%02ld:%02ld",userName,(long)hour,(long)minutes,(long)second] range:NSMakeRange(0, userName.length)];
        }
        
        
//        NSTimeInterval timeInterval    = [starttime doubleValue];
//        NSDate *detaildate             = [NSDate dateWithTimeIntervalSince1970:timeInterval];
//        //实例化一个NSDateFormatter对象
//        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//        //设定时间格式,这里可以设置成自己需要的格式
//        [dateFormatter setDateFormat:@"HH:mm"];
//        
//        NSString * currentDateStr      = [dateFormatter stringFromDate: detaildate];
//        
//         return [NSString stringWithFormat:@"%@:(%@)",userName?userName:@"",currentDateStr?currentDateStr:@""];
    }else{
        NSString * userName = params[@"nickname"];
        NSString * time     = params[@"time"];
        if (params[@"amount"]) {
            return [TalkfunUtils getAttributeNameStr:[NSString stringWithFormat:@"%@:(%@)",userName,time]range:NSMakeRange(0, userName.length)];
        }
        NSTimeInterval timeInterval    = [time doubleValue];
        NSDate *detaildate             = [NSDate dateWithTimeIntervalSince1970:timeInterval];
        //实例化一个NSDateFormatter对象
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        //设定时间格式,这里可以设置成自己需要的格式
        [dateFormatter setDateFormat:@"HH:mm"];
        
        NSString * currentDateStr      = [dateFormatter stringFromDate: detaildate];
        
    
        return [TalkfunUtils getAttributeNameStr:[NSString stringWithFormat:@"%@ %@",userName?userName:@"",currentDateStr?currentDateStr:@""]range:NSMakeRange(0, userName.length)] ;
    }
}

//====================== 图文混排 =====================
+ (void)getImageRange:(NSString*)message :(NSMutableArray*)array {
    
    NSRange range = [message rangeOfString:BEGIN_FLAG];
    NSRange range1 = [message rangeOfString:END_FLAG];
    //判断当前字符串是否还有表情的标志。
    if (range.length > 0 && range1.length > 0) {
        if (range.location > 0) {
            [array addObject:[message substringToIndex:range.location]];
            [array addObject:[message substringWithRange:NSMakeRange(range.location, range1.location+1-range.location)]];
            NSString * str = [message substringFromIndex:range1.location+1];
            [self getImageRange:str :array];
        }else {
            NSString * nextstr = [message substringWithRange:NSMakeRange(range.location, range1.location+1-range.location)];
            //排除文字是“”的
            if (![nextstr isEqualToString:@""]) {
                [array addObject:nextstr];
                NSString * str = [message substringFromIndex:range1.location + 1];
                [self getImageRange:str :array];
            }else {
                return;
            }
        }
        
    }
    else if (message != nil) {
        [array addObject:message];
    }
    
}

+ (UIView *)assembleMessageAtIndex:(NSString *)message
{
    NSMutableArray * array = [[NSMutableArray alloc] init];
    [TalkfunUtils getImageRange:message :array];
    UIView * returnView = [[UIView alloc] initWithFrame:CGRectZero];
    NSArray * data      = array;
    UIFont * fon        = [UIFont systemFontOfSize:13.0f];
    CGFloat upX         = 0;
    CGFloat upY         = 0;
    CGFloat X           = 0;
    CGFloat Y           = 0;
    if (data) {
        for (int i = 0;i < [data count]; i++) {
            NSString * str = [data objectAtIndex:i];
            if ([str hasPrefix:BEGIN_FLAG] && [str hasSuffix:END_FLAG])
            {
                if (upX >= MAX_WIDTH)
                {
                    upY = upY + KFacialSizeHeight;
                    upX = 0;
                    X   = 150;
                    Y   = upY;
                }
                
                NSString * imageName = [str substringWithRange:NSMakeRange(1, str.length - 2)];
                UIImageView * img    = [[UIImageView alloc]initWithImage:[UIImage imageNamed:imageName]];
                img.frame            = CGRectMake(upX, upY, KFacialSizeWidth, KFacialSizeHeight);
                [returnView addSubview:img];
                upX                  = KFacialSizeWidth+upX;
                if (X < 150) X = upX;
                
                
            } else {
                for (int j = 0; j < [str length]; j++) {
                    NSString * temp = [str substringWithRange:NSMakeRange(j, 1)];
                    if (upX >= MAX_WIDTH)
                    {
                        upY = upY + KFacialSizeHeight;
                        upX = 0;
                        X   = 150;
                        Y   = upY;
                    }
                    CGRect rect        = [temp boundingRectWithSize:CGSizeMake(150, 40) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];
                    //                    CGSize size = [temp sizeWithFont:fon constrainedToSize:CGSizeMake(150, 40)];
                    UILabel * la       = [[UILabel alloc] initWithFrame:CGRectMake(upX,upY,rect.size.width,rect.size.height)];
                    la.font            = fon;
                    la.text            = temp;
                    la.textAlignment   = NSTextAlignmentCenter;
                    la.backgroundColor = [UIColor clearColor];
                    [returnView addSubview:la];
                    upX                = upX + rect.size.width;
                    if (X < 150) {
                        X = upX;
                    }
                }
            }
        }
    }
    
    returnView.frame = CGRectMake(2.0f, 2.0f, X, Y); //@ 需要将该view的尺寸记下，方便以后使用
    
    return returnView;
}

+ (NSDictionary *)assembleAttributeString:(NSString *)string boundingSize:(CGSize)size fontSize:(CGFloat)fontSize shadow:(BOOL)containShadow
{
    if (!string || ![string isKindOfClass:[NSString class]]) {
        return nil;
    }
    
    NSDictionary *expressionDict = @{@"[fd]":@"[hard]",
                                     @"[lg]":@"[aha]",
                                     @"[qu]":@"[why]",
                                     @"[fl]":@"[flower]",
                                     @"[kl]":@"[pitiful]",
                                     @"[jy]":@"[amaz]",
                                     @"[gz]":@"[good]",
                                     @"[hx]":@"[cool]",
                                     @"[tx]":@"[love]",
                                     @"[ag]":@"[bye]",
                                     @"[S_FLOWER]":@"[rose]"};
    @synchronized (self) {
        for (NSString * name in expressionDict) {
            string = [string stringByReplacingOccurrencesOfString:name withString:expressionDict[name]];
        }
        
        NSShadow * shadow = [[NSShadow alloc] init];
        if (containShadow) {
            shadow.shadowOffset = CGSizeMake(0.5, 0.5);
            shadow.shadowColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        }
        
        CGFloat forgottenLength = 0;
        NSMutableAttributedString * originalAttributedString = [NSMutableAttributedString new];
        NSArray * leftArr = [string componentsSeparatedByString:@"["];
        NSAttributedString * attrStr = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",leftArr.firstObject] attributes:@{NSShadowAttributeName:shadow}];
        
        //先拼接一开始的那个
        [originalAttributedString appendAttributedString:attrStr];
        
        for (int i = 1; i < leftArr.count; i ++) {
            NSArray * leftRightArr = [leftArr[i] componentsSeparatedByString:@"]"];
            NSString * imageName = leftRightArr[0];
            if ([imageName isEqualToString:@"鲜花"]) {
                imageName = @"flower";
            }
            UIImage * image = [UIImage imageNamed:imageName];
            if (image) {
                // 添加表情
                NSTextAttachment *attch = [[NSTextAttachment alloc] init];
                // 表情图片
                attch.image = image;
                // 设置图片大小
                attch.bounds = CGRectMake(0, -5, 20, 20);
                
                NSAttributedString *attchStr = [NSAttributedString attributedStringWithAttachment:attch];
                
                //第一次拼接
                [originalAttributedString appendAttributedString:attchStr];
                
                NSTextAttachment * att = [[NSTextAttachment alloc] init];
                att.bounds = CGRectMake(0, 0, 2, 20);
                NSAttributedString * attStr = [NSAttributedString attributedStringWithAttachment:att];
                [originalAttributedString appendAttributedString:attStr];
                
                //计算少了多少长度
                forgottenLength += 4;
            }
            else
            {
                //第一次拼接
                NSAttributedString * firstStr = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"[%@]",leftRightArr.firstObject]];
                [originalAttributedString appendAttributedString:firstStr];
            }
            
            NSAttributedString * secondStr = [[NSAttributedString alloc] initWithString:leftRightArr.lastObject attributes:@{NSShadowAttributeName:shadow}];
            
            //如果有多个"]"
            if (leftRightArr.count > 2) {
                NSMutableArray * arr = [NSMutableArray arrayWithArray:leftRightArr];
                if (arr.count>0) {
                     [arr removeObjectAtIndex:0];
                }
               
                secondStr = [[NSAttributedString alloc] initWithString:[arr componentsJoinedByString:@"]"]];
            }
            
            //第二次拼接
            [originalAttributedString appendAttributedString:secondStr];
            
        }
        
        NSMutableString * str = [[NSMutableString alloc] initWithString:[originalAttributedString string]];
        
        for (int i = 0; i < forgottenLength; i ++) {
            [str appendString:@"a"];
        }
        
        CGRect rect = [TalkfunUtils getRectWithString:str size:CGSizeMake(size.width, size.height) fontSize:fontSize];
        
        NSString * rectStr = NSStringFromCGRect(rect);
        
        return @{AttributeStr:originalAttributedString,TextRect:rectStr};
    }
    
}

//计算出大小
+ (NSString *)fileSizeWithInterge:(NSInteger)size
{
    // 1k = 1024, 1m = 1024k
    if (size < 1024) {// 小于1k
        return [NSString stringWithFormat:@"%ldB",(long)size];
    }else if (size < 1024 * 1024){// 小于1m
        CGFloat aFloat = size/1024;
        return [NSString stringWithFormat:@"%.0fK",aFloat];
    }else if (size < 1024 * 1024 * 1024){// 小于1G
        CGFloat aFloat = size/(1024 * 1024);
        return [NSString stringWithFormat:@"%.1fM",aFloat];
    }else{
        CGFloat aFloat = size/(1024*1024*1024);
        return [NSString stringWithFormat:@"%.1fG",aFloat];
    }
}

+ (CGRect)estimateFrame:(CGRect)containerFrame imageViewFrame:(CGRect)imageViewFrame
{
    CGRect rect = imageViewFrame;
    
    CGFloat width = rect.size.height * (4 / 3.0);
    CGFloat distant;
    
    //如果容器的高度的4 / 3 大于它的宽度（贴着容器上下边）
    if (width > rect.size.width) {
        CGFloat height = rect.size.width * (3 / 4.0);
        distant = height - rect.size.height;
        
        return CGRectMake(0, 0 - distant / 2, rect.size.width, height);
        
    }
    //贴着容器左右边
    else
    {
        distant = width - rect.size.width;
        return CGRectMake(- distant / 2, 0, width, rect.size.height);
    }
}

+ (UIImage *)fixOrientation:(UIImage *)aImage {
    
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    
    return img;
}

+ (UIImage*)imageWithImage:(UIImage*)image
{
    CGSize imageSize = image.size;
    if (imageSize.height <= 1280 && imageSize.width <= 1280) {
        return image;
    }
    CGSize newSize = CGSizeZero;
    if (imageSize.height > imageSize.width) {
        newSize.height = 1280;
        newSize.width = imageSize.width / (imageSize.height / 1280);
    }
    else
    {
        newSize.width = 1280;
        newSize.height = imageSize.height / (imageSize.width / 1280);
    }
    
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    // Return the new image.
    return newImage;
}

//获取图片大小
+ (CGFloat)getSize:(UIImage *)image
{
    int  perMBBytes = 1024*1024;
    
    CGImageRef cgimage = image.CGImage;
    size_t bpp = CGImageGetBitsPerPixel(cgimage);
    size_t bpc = CGImageGetBitsPerComponent(cgimage);
    size_t bytes_per_pixel = bpp / bpc;
    
    CGFloat lPixelsPerMB  = perMBBytes / bytes_per_pixel * 1.0;
    
    
    long totalPixel = CGImageGetWidth(image.CGImage) * CGImageGetHeight(image.CGImage);
    
    
    CGFloat totalFileMB = totalPixel / lPixelsPerMB / 1.0;
    
    return totalFileMB;
}
+(NSMutableAttributedString*)getAttributeNameStr:(NSString*)str  range:(NSRange)range
{
    
     NSMutableAttributedString *fontAttributeNameStr = [[NSMutableAttributedString alloc]initWithString:str];
    
    
    if (range.length<fontAttributeNameStr.length) {
        //名字
        [fontAttributeNameStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:range];
        
        [fontAttributeNameStr addAttribute:NSForegroundColorAttributeName value:LIGHTBLUECOLOR range:range];
        
        
        
        //时间
        [fontAttributeNameStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(range.length, str.length - range.length)];
        //设置颜色
        [fontAttributeNameStr addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(range.length, str.length - range.length)];
        
    }
   
    
    return fontAttributeNameStr;
}
@end
