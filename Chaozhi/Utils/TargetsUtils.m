//
//  TargetsUtils.m
//  Chaozhi
//
//  Created by Jason_zyl on 2019/7/27.
//  Copyright © 2019 Jason_hzb. All rights reserved.
//

#import "TargetsUtils.h"

@implementation TargetsUtils

/** 主题色 */
+ (UIColor *)getAppThemeColor {
    if ([AppChannel integerValue] == 1) { //超职
        return RGBValue(0xC31A1F); //红
    } else if ([AppChannel integerValue] == 2) { //学智
        return RGBValue(0x42AFD9); //浅蓝
    }
    return RGBValue(0xC31A1F);
}

/** 极光key */
+ (NSString *)getPushKey {
    if ([AppChannel integerValue] == 1) { //超职
        return @"4f61ceadf98f55845bf8b36f";
    } else if ([AppChannel integerValue] == 2) { //学智
        return @"4f61ceadf98f55845bf8b36f";
    }
    return @"4f61ceadf98f55845bf8b36f";
}

/** 友盟key */
+ (NSString *)getUMKey {
    if ([AppChannel integerValue] == 1) { //超职
        return @"5c710878b465f5fa50000071";
    } else if ([AppChannel integerValue] == 2) { //学智
        return @"5c710878b465f5fa50000071";
    }
    return @"5c710878b465f5fa50000071";
}

/** 隐私协议 */
+ (NSString *)getPrivacyProtocolUrl {
    if ([AppChannel integerValue] == 1) { //超职
        return @"#/hybrid/chaozhi/privacy";
    } else if ([AppChannel integerValue] == 2) { //学智
        return @"#/hybrid/chaozhi/privacy";
    }
    return @"#/hybrid/chaozhi/privacy";
}

@end
