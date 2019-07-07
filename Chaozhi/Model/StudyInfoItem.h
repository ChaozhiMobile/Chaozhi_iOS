//
//  StudyInfoItem.h
//  Chaozhi
//
//  Created by Jason_zyl on 2018/10/19.
//  Copyright © 2018年 Jason_hzb. All rights reserved.
//

#import "BaseItem.h"

@class NewestInfoItem;
@class LiveItem;
@class LearnCourseItem;
@class YuekaoItem;

@interface StudyInfoItem : BaseItem

@property (nonatomic, copy) NSString *ID; //订单id
@property (nonatomic, copy) NSString *product_id; //产品id
@property (nonatomic, copy) NSString *product_name; //产品名称
@property (nonatomic, copy) NSString *endtime; //支付时间
@property (nonatomic, copy) NSString *product_img; //产品图片
@property (nonatomic, copy) NSString *user_time; //上课节数，单位节
@property (nonatomic, copy) NSString *user_question; //完成总题数
@property (nonatomic, copy) NSString *product_sub_name; //产品副标题
@property (nonatomic, retain) NewestInfoItem *newest_info; //课程最新信息
/** 阅读协议 */
@property (nonatomic,copy) NSString *is_agreement_confirm;

@end

@interface NewestInfoItem : BaseItem

@property (nonatomic,retain) NSArray *live_list; //直播数组
@property (nonatomic,retain) NSArray *learn_course_list; //最新学习课程数组
@property (nonatomic,retain) YuekaoItem *exam_month; //月考信息

@end


@interface LiveItem : BaseItem

@property (nonatomic, copy) NSString *ID; //直播id
@property (nonatomic, copy) NSString *live_id; //直播编号
@property (nonatomic, copy) NSString *live_name; //直播名称
@property (nonatomic, copy) NSString *teacher; //直播老师
@property (nonatomic, copy) NSString *live_st; //直播开始时间
@property (nonatomic, copy) NSString *live_et; //直播结束时间
@property (nonatomic, copy) NSString *live_url; //回放地址
@property (nonatomic, copy) NSString *status; //直播状态 -1 已结束，使用回放地址 0 未开始 1 正在直播中，使用另外接口访问直播地址

@end

@interface LearnCourseItem : BaseItem

@property (nonatomic, copy) NSString *ID; //课时id
@property (nonatomic, copy) NSString *tid; //课时编号，用于展示该课程是第几节
@property (nonatomic, copy) NSString *name; //课程名称
@property (nonatomic, copy) NSString *view_url; //课程观看地址
@property (nonatomic, copy) NSString *ut; //课程学习时间
@property (nonatomic, copy) NSString *live_id; //视频id playbackID
@property (nonatomic, copy) NSString *type; //类型 1录播 2回放/直播

@end

@interface YuekaoItem : BaseItem

@property (nonatomic, copy) NSString *status; //0 未考试 1已考试
@property (nonatomic, copy) NSString *score; //考试得分 -1代表未参加考试
@property (nonatomic, copy) NSString *course_id; //课程id
@property (nonatomic, copy) NSString *ID; //月考id
@property (nonatomic, copy) NSString *month; //月
@property (nonatomic, copy) NSString *difficulty; //1
@property (nonatomic, copy) NSString *rank; //2
@property (nonatomic, copy) NSString *date; //日期
@property (nonatomic, copy) NSString *question_num; //月考题数
@property (nonatomic, copy) NSString *year; //年
@property (nonatomic, copy) NSString *name; //月考名称

@end
