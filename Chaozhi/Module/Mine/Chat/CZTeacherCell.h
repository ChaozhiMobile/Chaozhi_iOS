//
//  CZTeacherCell.h
//  Chaozhi
//
//  Created by zhanbing han on 2019/10/16.
//  Copyright © 2019 Jason_hzb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TUnReadView.h"
#import "TUIConversationCellData.h"
#import "CZLabel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CZTeacherCell : UITableViewCell
/**
 *  头像视图。
 *  当该会话为1对1好友会话时，头像视图为用户头像。
 *  当该会话为群聊时，头像视图为群头像。
 */
@property (nonatomic, strong) UIImageView *headImageView;

/**
 *  会话标题
 *  当该会话为1对1好友会话时，标题为好友的备注，若对应好友没有备注的话，则显示好友 ID。
 *  当该会话为群聊时，标题为群名称。
 */
@property (nonatomic, strong) UILabel *titleLabel;

/**
 *  会话消息概览（下标题）
 *  概览负责显示对应会话最新一条消息的内容/类型。
 *  当最新的消息为文本消息/系统消息时，概览的内容为消息的文本内容。
 *  当最新的消息为多媒体消息时，概览的内容为对应的多媒体形式，如：“动画表情” / “[文件]” / “[语音]” / “[图片]” / “[视频]” 等。
 *  若当前会话有草稿时，概览内容为：“[草稿]XXXXX”，XXXXX为草稿内容。
 */
@property (nonatomic, strong) UILabel *subTitleLabel;

/**
 *  时间标签
 *  负责在会话单元中显示最新消息的接收/发送时间。
 *  对于当天的消息，以 “HH：MM”的格式显示时间。
 *  对于非当天的消息，则显示消息收/发当天为星期几。
 */
@property (nonatomic, strong) UILabel *timeLabel;

/**
 *  未读视图
 *  如果当前会话有消息未读的话，则在会话单元右侧显示红底白字的原型图标来展示未读数量。
 */
@property (nonatomic, strong) TUnReadView *unReadView;

/**
 *  会话消息数据源
 *  存储会话单元所需的一系列信息与数据。包含会话头像、会话类型（1对1/群组）、会话标题、未读计数等等。
 *  数据源还会负责部分数据的获取与处理。
 *  数据源的详细信息请参考 \Section\Conversation\Cell\TUIConversationCellData.h
 */
@property (nonatomic, strong) TUIConversationCellData *convData;

/**
 * 班主任课程标签
 */
@property (nonatomic, strong) CZLabel *courseNameLabel;
/** <#object#> */
@property (nonatomic,assign) BOOL isTop;

@end

NS_ASSUME_NONNULL_END
