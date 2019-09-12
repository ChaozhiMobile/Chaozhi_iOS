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

@property (nonatomic, copy) NSString *title; //标题
@property (nonatomic, copy) NSString *token; //欢拓视频访问token
@property (nonatomic, copy) NSString *type; //类型 (后台 1:录播; 2:回放/直播)（本地 1:录播; 2:回放; 3:直播）
@property (nonatomic, copy) NSString *product_id; //产品id
@property (nonatomic, copy) NSString *live_id; //视频id playbackID
@property (nonatomic, copy) NSString *time; //播放进度时长，单位秒
@property (nonatomic, copy) NSString *total_time; //播放总时长，单位秒

@end

NS_ASSUME_NONNULL_END
