//
//  TargetsUtils.h
//  Chaozhi
//
//  Created by Jason_zyl on 2019/7/27.
//  Copyright © 2019 Jason_hzb. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TargetsUtils : NSObject

/** 主题色 */
+ (UIColor *)getAppThemeColor;

/** 极光key */
+ (NSString *)getPushKey;

/** 友盟key */
+ (NSString *)getUMKey;

/** 隐私协议 */
+ (NSString *)getPrivacyProtocolUrl;

@end

NS_ASSUME_NONNULL_END
