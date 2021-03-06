//
//  Config.h
//  Chaozhi
//  Notes：接口地址【文档：http://39.106.129.114/showdoc/web/#/1 密码：123456】
//  IM接口地址【文档：https://documenter.getpostman.com/view/7465408/SVmr2MAf?version=latest】
//  腾讯IM官方地址：https://cloud.tencent.com/document/product/269/37190
//  测试账号：18268686511/15737936517/15068850958/18621799526/18888643622 密码：123456 112233 zxcvbnm
//  客服系统：http://kf-dev.chaozhiedu.com:88 admin/admin/qwer1234 aci-edu/8888/qwer1234
//  欢拓SDK文档：http://open.talk-fun.com/docs/ios/precondition.html
//
//  Created by Jason_hzb on 2018/5/29.
//  Copyright © 2018年 小灵狗出行. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Config : NSObject

#pragma mark - ---------------接口地址---------------

NSString *domainUrl(void);

#pragma mark - ---------------H5地址---------------

NSString *h5Url(void);

#pragma mark - ---------------IM地址---------------

NSString *imUrl(void);

#pragma mark - ---------------IM KEY---------------

int imKey(void);

#pragma mark - ---------------接口名称---------------

#define URL_PhoneCaptcha @"api/phone-captcha" //获取验证码
#define URL_Login @"api/user/login" //登录
#define URL_Reg @"api/user/reg" //注册
#define URL_Reset @"api/user/reset" //重置密码
#define URL_UserInfo @"api/user/info" //用户信息
#define URL_AppHome @"api/app/home" //首页
#define URL_CategoryList @"api/category/list" //课程分类
#define URL_ProductList @"api/product/list" //课程列表
#define URL_CourseList @"api/course/list" //已购课程列表
#define URL_NewsList @"api/news/list" //首页的新知
#define URL_CheckVersion @"api/app/check-version" //版本更新
#define URL_Notify @"api/notify/notify" //提醒状态
#define URL_MyTeacher @"api/user/teacher" //我的班主任 ?token=xxx
#define URL_IapPayCheck @"api/pay/iap-pay" //内购凭证验证
#define URL_ConfirmAgreement @"api/orders/confirm-agreement"//协议确认
#define URL_OrdersAgreement @"api/orders/agreement" //订单协议
#define URL_LiveToken @"api/userlive/token" //视频token接口
#define URL_LiveProgress @"api/userlive/progress" //视频进度更新接口
#define URL_ResetAnswer @"api/question/reset-answer" //月考重置答案
#define URL_LiveReviewInfo @"api/userlive/review-info" //直播评价信息
#define URL_LiveReview @"api/userlive/review" //直播评价
#define URL_TeacherList @"api/user/teacher" //我的班主任列表
#define URL_IMInfo @"api/user/im" //我的im信息
#define URL_IMLogin @"api/user/im-login" //im登录
#define URL_IMQuery_status @"v1/education/query_status"//查询状态

#pragma mark - ---------------H5名称---------------

#define H5_MyInfo @"#/hybrid/me/info" //我的-个人中心
#define H5_Orders @"#/hybrid/orders" //我的-课程订单
#define H5_Message @"#/hybrid/message" //我的-我的消息
#define H5_Coupon @"#/hybrid/coupon" //我的-我的优惠券
#define H5_Feedback @"#/hybrid/feedback" //我的-问题反馈
#define H5_About @"#/hybrid/chaozhi/about" //我的-关于超职教育
#define H5_MyFav @"#/hybrid/me/fav" //我的-我的收藏
#define H5_Apply @"#/hybrid/me/apply" //我的-报考资料

#define H5_Question @"#/hybrid/study/library/" //学习-题库【学习课程id】
#define H5_Doc @"#/hybrid/study/doc/" //学习-资料【学习课程id】
#define H5_Live @"#/hybrid/study/live/" //学习-直播【学习课程id】
#define H5_Video @"#/hybrid/study/video/" //学习-录播【学习课程id】

#define H5_Infinite @"#/hybrid/Infinite" //无限

#define H5_InfiniteNews @"#/hybrid/infinite/news/" //首页-每日新知【新知id】
#define H5_StoreProduct @"#/hybrid/store/product/" //首页-课程【课程id】
#define H5_Store @"#/hybrid/store/" //首页-推荐课程列表【课程分类id】
#define H5_Demo @"#/hybrid/demo/" //首页-公开课开始试听【课程分类id】
#define H5_TeacherDetail @"#/hybrid/teacher/" //首页-教师详情
#define H5_StoreFree @"#/hybrid/store/free" //首页-更多公开课
#define H5_WeikeDetail @"#/hybrid/vike/play/" //首页-微课视频详情
#define H5_WeikeList @"#/hybrid/vike/list" //首页-更多微信视频

#define H5_MonthlyResult @"#/hybrid/study/library/monthly/result/" //月考考试结果
#define H5_MonthlyAnswer @"#/hybrid/study/library/monthly/answer/" //月考考试
#define H5_MonthlyList @"#/hybrid/study/library/monthly/" //月考列表

@end
