//
//  TalkfunItem.h
//  Chaozhi
//
//  Created by Jason_zyl on 2019/6/28.
//  Copyright © 2019 Jason_hzb. All rights reserved.
//

#import "BaseItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface TalkfunItem : BaseItem

/**
 * {
 "access_key": "b7748a14a561fa456cd25e9ecc11d4f1",
 "access_token": "ImNkhDZzYWYkVWYkNjZwkjM1QzM0ETZ3MTM3cDN0ITZ8xHf9JSN3UTM0EzX5QDM5MzNiojIl1WYuJnIsAjOiEmIs01W6Iic0RXYiwiN1gTN4QDM0UTM6ISZtlGdnVmciwiI3cjN4EDO5MjI6ICZphnIskjM5ETM6ICZpBnIsAjOiQWanJCL1cTNxQTM6ICZp9VZzJXdvNmIsIiI6IichRXY2FmIsAjOiIXZk5WZnJCL2UjN0ETNwQTNxojIlJXawhXZiwSO0ATOzcjOiQWat92byJCLiETM1YjKqoiKygTMiojIl1WYut2Yp5mIsIiclNXdiojIlx2byJCLigzMyATMiojIklWdiwSOykTMxojIkl2XyVmb0JXYwJye",
 "miniprogramUrl": "https://open.talk-fun.com/room.php?ak=b7748a14a561fa456cd25e9ecc11d4f1",
 "liveUrl": "http://open.talk-fun.com/room.php?ak=b7748a14a561fa456cd25e9ecc11d4f1",
 "liveVideoUrl": "http://open.talk-fun.com/liveout.php?code=eyJyb29taWQiOiI3MzkwNDkiLCJzaWduIjoiNDFlZjFlYzlkNDJmMWIzMDhhY2U4ZGU1MDk5YTNiYWEifQ==&uid=10238&nickname=182%2A%2A%2A%2A6511&volume=",
 "playbackOutUrl": ""
 }
 */

@property (nonatomic, copy) NSString *access_key;
@property (nonatomic, copy) NSString *access_token; //欢拓视频访问token
@property (nonatomic, copy) NSString *miniprogramUrl;
@property (nonatomic, copy) NSString *liveUrl;
@property (nonatomic, copy) NSString *liveVideoUrl;
@property (nonatomic, copy) NSString *playbackOutUrl;

@end

NS_ASSUME_NONNULL_END
