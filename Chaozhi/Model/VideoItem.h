//
//  VideoItem.h
//  Chaozhi
//
//  Created by Jason_zyl on 2019/7/4.
//  Copyright © 2019 Jason_hzb. All rights reserved.
//

#import "BaseItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface VideoItem : BaseItem

@property (nonatomic, copy) NSString *type; //类型 1录播 2直播
@property (nonatomic, copy) NSString *product_id; //产品id
@property (nonatomic, copy) NSString *live_id; //视频id playbackID
@property (nonatomic, copy) NSString *time; //播放进度时长，单位秒
@property (nonatomic, copy) NSString *total_time; //播放总时长，单位秒

@end

NS_ASSUME_NONNULL_END
