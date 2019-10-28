//
//  CZPlaybackVC.h
//  Chaozhi
//
//  Created by Jason_zyl on 2019/10/27.
//  Copyright © 2019 Jason_hzb. All rights reserved.
//

#import "TalkfunPlaybackViewController.h"
#import "VideoItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface CZPlaybackVC : TalkfunPlaybackViewController

/** 视频model */
@property (nonatomic,retain) VideoItem *videoItem;

@end

NS_ASSUME_NONNULL_END
