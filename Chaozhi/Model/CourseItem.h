//
//  CourseItem.h
//  Chaozhi
//
//  Created by Jason_zyl on 2019/8/2.
//  Copyright © 2019 Jason_hzb. All rights reserved.
//

#import "BaseItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface CourseItem : BaseItem

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
NS_ASSUME_NONNULL_END
