//
//  Talkfun.h
//  Chaozhi
//
//  Created by Jason_zyl on 2019/6/24.
//  Copyright © 2019 Jason_hzb. All rights reserved.
//

#ifndef Talkfun_h
#define Talkfun_h

#define SYSTEMVERSION [UIDevice currentDevice].systemVersion.integerValue
#define DEVICEMODEL [UIDevice currentDevice].model
#define IsIPAD [DEVICEMODEL hasPrefix:@"iPad"]

//****************
//模式
//typedef enum{
//
//    TalkfunModeDefault = 1,    //自定义模式
//    TalkfunModeCustom  = 2     //用户定义模式
//
//}TalkfunMode;
//****************

#import "TalkfunSDK.h"
#import "TalkfunHttpTools.h"
#import "UIView+TalkfunActivityIndicator.h"
#import "TalkfunUtils.h"
//#import "TalkfunUrlManager.h"
#import "MJRefresh.h"

//=========== 方法名 ================
#define AttributeStr @"attributeStr"
#define TextRect @"textRect"
//==================================

#define GREENCOLOR [UIColor colorWithRed:214 / 255.0 green:255 / 255.0 blue:221 / 250.0 alpha:1]
#define YELLOWCOLOR [UIColor colorWithRed:255 / 255.0 green:243 / 255.0 blue:223 / 250.0 alpha:1]
#define REDCOLOR [UIColor colorWithRed:255 / 255.0 green:231 / 255.0 blue:231 / 250.0 alpha:1]
#define FONTGREENCOLOR [UIColor colorWithRed:34 / 255.0 green:172 / 255.0 blue:56 / 250.0 alpha:1]
#define FONTYELLOWCOLOR [UIColor colorWithRed:255 / 255.0 green:186 / 255.0 blue:0 / 250.0 alpha:1]
#define FONTREDCOLOR [UIColor colorWithRed:255 / 255.0 green:0 / 255.0 blue:0 / 250.0 alpha:1]


#define ColorArray NSMutableArray *colorArray = [NSMutableArray array];[colorArray addObject:[UIColor whiteColor]];[colorArray addObject:[UIColor redColor]];[colorArray addObject:[UIColor greenColor]];[colorArray addObject:[UIColor blueColor]];[colorArray addObject:[UIColor cyanColor]];[colorArray addObject:[UIColor magentaColor]];[colorArray addObject:[UIColor purpleColor]];
#define TempColor (UIColor*)colorArray[arc4random_uniform((int)colorArray.count-1)];

#define ScreenSize [UIScreen mainScreen].bounds.size

#define APPLICATION [UIApplication sharedApplication]
#define ORIENTATION [UIDevice currentDevice].orientation
#define UserDefault [NSUserDefaults standardUserDefaults]

#define TEXTFIELDHASNOVALUE(obj) (obj == nil || obj.text == nil || obj.text.length == 0)
#define ToastDuration 1
#define DismissToastDuration 0.2
#define ToastPosition CGPointMake(ScreenSize.width/2.0, ScreenSize.height/2.0 * 0.8)
#define HeightRatio [UIScreen mainScreen].bounds.size.height / 667
#define WidthRatio [UIScreen mainScreen].bounds.size.width / 320

#define WeakSelf __weak typeof(self) weakSelf = self;
#define MSTT_CB_C [UIColor colorWithRed:170.0/255.0 green:170.0/255.0 blue:170.0/255.0 alpha:1]
#define MSCG_CB_C [UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1]

#define MSVC_CB_B [UIColor colorWithRed:70.0/255.0 green:136.0/255.0 blue:241.0/255.0 alpha:1]

#define Colour_HT_B [UIColor colorWithRed:241.0 green:241.0 blue:241.0 alpha:0.3]

#define Colour_Gray [UIColor colorWithRed:174.0/255.0 green:174.0/255.0 blue:174.0/255.0 alpha:1]
#define UIColorFromRGBHex(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define PERFORM_IN_MAIN_QUEUE(method) if ([NSThread currentThread].isMainThread) {method}else{dispatch_async(dispatch_get_main_queue(), ^{method});}
#define TEXTFIELDHASVALUE(obj) (obj == nil || obj.text == nil || obj.text.length == 0)
#define TOASTDURATION 1

#define BLUECOLOR UIColorFromRGBHex(0x56acf5)
#define GRAYCOLOR UIColorFromRGBHex(0xd5d5d5)
#define DARKBLUECOLOR UIColorFromRGBHex(0x222a46)
#define NEWBLUECOLOR UIColorFromRGBHex(0x303a5e)
#define LIGHTBLUECOLOR UIColorFromRGBHex(0x93a9d1)

#define iphone4s ([UIScreen mainScreen].bounds.size.height < 568)

#define QUITCONTROLLER(obj) if (obj.presentingViewController && !obj.navigationController) {[obj dismissViewControllerAnimated:YES completion:nil];}else{[obj.navigationController popViewControllerAnimated:YES];}

#define GETINTOCONTROLLER(controller) if (self.navigationController) {[self.navigationController pushViewController:controller animated:YES];}else{[self presentViewController:controller animated:NO completion:nil];}

UIKIT_STATIC_INLINE CGFloat ExpressionViewHeight(){
    CGFloat expressionViewHeight = 100;
    if ([DEVICEMODEL hasPrefix:@"iPad"]) {
        expressionViewHeight += 20;
    }
    return expressionViewHeight;
}

UIKIT_STATIC_INLINE CGFloat ExpressionViewContentExtraHeight(){
    CGFloat ExpressionViewContentExtraHeight = 0;
    if ([DEVICEMODEL hasPrefix:@"iPad"]) {
        ExpressionViewContentExtraHeight += 20;
    }
    return ExpressionViewContentExtraHeight;
}

UIKIT_STATIC_INLINE NSString * GetVersionText(){
    NSString * version = [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"];
    NSString * str = [NSString stringWithFormat:@"©Talkfun Live V%@",version];
    return str;
}


UIKIT_STATIC_INLINE NSArray * ExpressionsArray(){
    return @[@"aha",
             @"amaz",
             @"love",
             @"cool",
             @"pitiful",
             @"why",
             @"good",
             @"bye",
             @"hard",
             @"flower"];
}

UIKIT_STATIC_INLINE NSDictionary * GetTextMessage(NSString * text){
    NSArray * expressionsArray = ExpressionsArray();
    BOOL match = NO;
    NSRange range = NSMakeRange(text.length - 1, 1);
    for (NSString * str in expressionsArray) {
        NSString *predicateStr = [NSString stringWithFormat:@"[\\s\\S]*\\[%@\\]$",str];
        NSPredicate * predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",predicateStr];
        match = [predicate evaluateWithObject:text];
        if (match) {
            range = NSMakeRange(text.length-(str.length+2), str.length+2);
            break;
        }
    }
    return @{@"match":@(match),@"range":NSStringFromRange(range)};
}

UIKIT_STATIC_INLINE CGFloat getButtonWidth(BOOL isPlayback){
    if (!isPlayback) {
        return 85;
    }
    if (IsIPAD) {
        return 85;
    }else if (!IsIPAD&&ScreenSize.width<=320){
        return 65;
    }else{
        return 80;
    }
}

//有问题  1280048(数据)
//#define PLAYBACKID @"1296329"
//#define PLAYBACKID @"1280048"
//#define PLAYBACKID @"1275085"
//#define PLAYBACKID @"1277215"
//#define NAME [NSString stringWithFormat:@"zzzz%d",arc4random() % 999999]
#define PASSWORD @""
#define PLAYBACKID @""
#define NAME @""
//#define PASSWORD @""

#endif /* Talkfun_h */
