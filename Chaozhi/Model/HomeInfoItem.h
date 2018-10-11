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
@class HomeTeacherItem;


@interface HomeInfoItem : BaseItem
@property (nonatomic , retain) NSArray <HomeActivityItem *>*activity_list;
@property (nonatomic , retain) NSArray <HomeBannerItem *>*banner_list;
@end

@interface HomeActivityItem :BaseItem
@property (nonatomic , retain) NSString* status ;
@property (nonatomic , retain) NSString* img ; //test-aci-api.chaozhiedu.com/api/file/10710,
@property (nonatomic , retain) NSString* content ;// <p>超职教育是由超职时代（北京）教育科技有限公司所打造的综合性在线教育平台，多年来主要来以提供快乐、高效、超值的课程体验为服务宗旨，课程推出至今，高质量与好口碑是我们的核心发展前提，在课程建设方面，我们不断完善，加强环节把控，严密针对学员自身条件推出不同课型，有效提升学员短期内的成长进度，加强与学员的情感联系，努力为学员提供售前售后的极致体验。</p ><p><br></p ><p><br></p >,
@property (nonatomic , retain) NSString* ID;// 1,
@property (nonatomic , retain) NSString* category_id ;// 2,
@property (nonatomic , retain) NSString* title ;// 超职教育是由超职时代（北京）教育科技有限公司所打造的综合性在线教育平台,
@property (nonatomic , retain) NSString* ct ;// 2018-08-23 00:42:39,
@property (nonatomic , retain) NSString* ut ;// 2018-08-26 00:00:53,
@property (nonatomic , retain) NSString* subtitle ;// 超职教育是由超职时代（北京）教育科技有限公司所打造的综合性在线教育平台，多年来主要来以提供快乐、高效、超值的课程体验为服务宗旨，课程推出至今，高质量与好口碑是我们的核心发展前提，在课程建设方面，我们不,
@property (nonatomic , retain) NSString* news_category_id ;// 1

@end

@interface HomeBannerItem :BaseItem
@property (nonatomic , retain) NSString* flag ;
@property (nonatomic , retain) NSString* ID ;
@property (nonatomic , retain) NSString* title ;
@property (nonatomic , retain) NSString* content ;
@property (nonatomic , retain) NSString* img;//test-aci-api.chaozhiedu.com/api/file/10792,
@property (nonatomic , retain) NSString* param ;

@end


@interface HomeCategoryItem : BaseItem
@property (nonatomic , retain) NSArray <HomeFeatureProductItem *>*feature_product_list;
@property (nonatomic , retain) NSArray <HomeTryVideoItem *>*try_video_list;
@property (nonatomic , retain) NSArray <HomeTeacherItem *>*teacher_list;
@end

@interface HomeFeatureProductItem : BaseItem
@property (nonatomic , retain) NSString* ID;// : 31,
@property (nonatomic , retain) NSString* review_num ;//: 5,
@property (nonatomic , retain) NSString* description ;//: <p style="text-align: center; "><img src="//aci-api.chaozhiedu.com/api/file/26841" alt="心理咨询师-VIP火箭班" style="max-width:100%;"><br></p><p><br></p>,
@property (nonatomic , retain) NSString* status ;//: 1,
@property (nonatomic , retain) NSString* category_id ;//: 2,
@property (nonatomic , retain) NSString* tags ;//: 名师密训,结业证书,心理实操课2.0,真题解析2.0,考前预测,终身学习,不过退费,线下沙龙,VIP服务,私人心理医生,
@property (nonatomic , retain) NSString* img ;//: //test-aci-api.chaozhiedu.com/api/file/31390,
@property (nonatomic , retain) NSString* sub_name ;//: 独家通关秘籍,
@property (nonatomic , retain) NSString* price ;//: 5880.00,
@property (nonatomic , retain) NSString* syllabus;
@property (nonatomic , retain) NSString* original_price ;//: 6880.00,
@property (nonatomic , retain) NSString* name ;//: ACI注册心理咨询师  VIP火箭班,
@property (nonatomic , retain) NSString* purchase ;//: 0
@end

@interface HomeTryVideoItem : BaseItem
@property (nonatomic , retain) NSString* teacher ;//: 小跃老师,
@property (nonatomic , retain) NSString* img ;//: https://www.chaozhiedu.com/static/images/vedio-pic.png,
@property (nonatomic , retain) NSString* title ;//: 婚姻公开课,
@property (nonatomic , retain) NSString* src ;//: https://open.talk-fun.com/playout/PTk2OigjbipoIi8.html?st=VpPmVb32XJ80sVZcwYVATA&e=1539772257&from=cms101341,
@property (nonatomic , retain) NSString* time ;//: 43:12
@end

@interface HomeTeacherItem : BaseItem
@property (nonatomic , retain) NSString* ID;//: 9,
@property (nonatomic , retain) NSString* name;// "郭聪荣",
@property (nonatomic , retain) NSString* photo; //test-aci-api.chaozhiedu.com/api/file/10751",
@property (nonatomic , retain) NSString* info;// "心理学硕士，心理专家。北京中医药大学心理讲师，共青团心理辅导员培训与督导师 。"
@end


