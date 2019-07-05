//
//  HomeInfoItem.h
//  Chaozhi
//
//  Created by zhanbing han on 2018/10/11.
//  Copyright © 2018年 Jason_hzb. All rights reserved.
//

#import "BaseItem.h"

@class HomeBannerItem;
@class HomeActivityItem;
@class HomeFeatureProductItem;
@class HomeTryVideoItem;
@class HomeWeikeItem;
@class HomeTeacherItem;
@class HomeNewsItem;

@interface HomeInfoItem : BaseItem

@property (nonatomic , retain) NSArray <HomeActivityItem *>*activity_list;
@property (nonatomic , retain) NSArray <HomeBannerItem *>*banner_list;

@end

@interface HomeActivityItem :BaseItem

@property (nonatomic , copy) NSString* status ;
@property (nonatomic , copy) NSString* img ; //test-aci-api.chaozhiedu.com/api/file/10710,
@property (nonatomic , copy) NSString* content ;// <p>超职教育是由超职时代（北京）教育科技有限公司所打造的综合性在线教育平台，多年来主要来以提供快乐、高效、超值的课程体验为服务宗旨，课程推出至今，高质量与好口碑是我们的核心发展前提，在课程建设方面，我们不断完善，加强环节把控，严密针对学员自身条件推出不同课型，有效提升学员短期内的成长进度，加强与学员的情感联系，努力为学员提供售前售后的极致体验。</p ><p><br></p ><p><br></p >,
@property (nonatomic , copy) NSString* ID;// 1,
@property (nonatomic , copy) NSString* category_id ;// 2,
@property (nonatomic , copy) NSString* title ;// 超职教育是由超职时代（北京）教育科技有限公司所打造的综合性在线教育平台,
@property (nonatomic , copy) NSString* ct ;// 2018-08-23 00:42:39,
@property (nonatomic , copy) NSString* ut ;// 2018-08-26 00:00:53,
@property (nonatomic , copy) NSString* subtitle ;// 超职教育是由超职时代（北京）教育科技有限公司所打造的综合性在线教育平台，多年来主要来以提供快乐、高效、超值的课程体验为服务宗旨，课程推出至今，高质量与好口碑是我们的核心发展前提，在课程建设方面，我们不,
@property (nonatomic , copy) NSString* news_category_id ;// 1

@end

@interface HomeBannerItem :BaseItem

@property (nonatomic , copy) NSString* flag ;
@property (nonatomic , copy) NSString* ID ;
@property (nonatomic , copy) NSString* title ;
@property (nonatomic , copy) NSString* content ;
@property (nonatomic , copy) NSString* img;//test-aci-api.chaozhiedu.com/api/file/10792,
@property (nonatomic , copy) NSString* param ;

@end


@interface HomeCategoryItem : BaseItem

@property (nonatomic , retain) NSArray <HomeFeatureProductItem *>*feature_product_list;
@property (nonatomic , retain) NSArray <HomeTryVideoItem *>*try_video_list;
@property (nonatomic , retain) NSArray <HomeWeikeItem *>*weike_list;
@property (nonatomic , retain) NSArray <HomeTeacherItem *>*teacher_list;

@end

@interface HomeFeatureProductItem : BaseItem

@property (nonatomic , copy) NSString* ID ;// : 31,
@property (nonatomic , copy) NSString* review_num ;//: 5,
@property (nonatomic , copy) NSString* review_star ;//星级
@property (nonatomic , copy) NSString* description ;//: <p style="text-align: center; "><img src="//aci-api.chaozhiedu.com/api/file/26841" alt="心理咨询师-VIP火箭班" style="max-width:100%;"><br></p><p><br></p>,
@property (nonatomic , copy) NSString* status ;//: 1,
@property (nonatomic , copy) NSString* category_id ;//: 2,
@property (nonatomic , copy) NSString* tags ;//: 名师密训,结业证书,心理实操课2.0,真题解析2.0,考前预测,终身学习,不过退费,线下沙龙,VIP服务,私人心理医生,
@property (nonatomic , copy) NSString* img ;//: //test-aci-api.chaozhiedu.com/api/file/31390,
@property (nonatomic , copy) NSString* sub_name ;//: 独家通关秘籍,
@property (nonatomic , copy) NSString* price ;//: 5880.00,
@property (nonatomic , copy) NSString* syllabus;
@property (nonatomic , copy) NSString* original_price ;//: 6880.00,
@property (nonatomic , copy) NSString* name ;//: ACI注册心理咨询师  VIP火箭班,
@property (nonatomic , copy) NSString* purchase ;//: 0

@end

@interface HomeTryVideoItem : BaseItem

@property (nonatomic , copy) NSString* teacher ;//: 小跃老师,
@property (nonatomic , copy) NSString* img ;//: https://www.chaozhiedu.com/static/images/vedio-pic.png,
@property (nonatomic , copy) NSString* title ;//: 婚姻公开课,
@property (nonatomic , copy) NSString* src ;//: https://open.talk-fun.com/playout/PTk2OigjbipoIi8.html?st=VpPmVb32XJ80sVZcwYVATA&e=1539772257&from=cms101341,
@property (nonatomic , copy) NSString* time ;//: 43:12
@property (nonatomic , copy) NSString* live_id;
@property (nonatomic , copy) NSString* access_token;

@end

@interface HomeWeikeItem : BaseItem

@property (nonatomic , copy) NSString* ID;//: 13,
@property (nonatomic , copy) NSString* title;//: 测试咨询1,
@property (nonatomic , copy) NSString* teacher_id;//: 17,
@property (nonatomic , copy) NSString* teacher_name;//: 王依蕾,
@property (nonatomic , copy) NSString* play_url;//: https://outin-5e71f4ec537b11e98d2e00163e1c7426.oss-cn-shanghai.aliyuncs.com/sv/37848961-16a01e307e1/37848961-16a01e307e1.mp4?Expires=1554908328&OSSAccessKeyId=LTAItL9Co9nUDU5r&Signature=%2FAu%2Ba3E8DZgs2%2FxZP7eBlVq6TmY%3D,
@property (nonatomic , copy) NSString* cover ;//: //test-aci-api.chaozhiedu.com/api/file/11096,
@property (nonatomic , copy) NSString* video ;//: 4ea2efd8c6634a7dae5c199c0a4c9265
@property (nonatomic , copy) NSString* play_num ;//: 4

@end

@interface HomeTeacherItem : BaseItem

@property (nonatomic , copy) NSString* ID;//: 9,
@property (nonatomic , copy) NSString* name;// "郭聪荣",
@property (nonatomic , copy) NSString* photo; //test-aci-api.chaozhiedu.com/api/file/10751",
@property (nonatomic , copy) NSString* info;// "心理学硕士，心理专家。北京中医药大学心理讲师，共青团心理辅导员培训与督导师 。"

@end

@interface HomeNewsListItem : BaseItem

@property (nonatomic , assign) NSInteger total;;
@property (nonatomic , retain) NSArray <HomeNewsItem *>* rows;

@end

@interface HomeNewsItem : BaseItem

@property (nonatomic , copy) NSString* status;// : 1,
@property (nonatomic , copy) NSString* img;// : //test-aci-api.chaozhiedu.com/api/file/10722,
@property (nonatomic , copy) NSString* content ;//:
@property (nonatomic , copy) NSString* ID ;//: 4,
@property (nonatomic , copy) NSString* category_id ;//: 2,
@property (nonatomic , copy) NSString* title ;//: “一带一路”今后这么建设,
@property (nonatomic , copy) NSString* ct ;//: 2018-08-28 14:47:24,
@property (nonatomic , copy) NSString* ut ;//: 2018-08-28 14:47:24,
@property (nonatomic , copy) NSString* subtitle ;//: 广西防城港一男子参加开海节后就发生了一件怪事，他驾车在斑马线前停了半个多小时不肯走，说斑马线上有行人，这是发生了什么事呢？　　8月18号，是防城港市2018年北部湾开海节，为了确保活动期间道路畅通有序,
@property (nonatomic , copy) NSString* news_category_id ;//: 1

@end


