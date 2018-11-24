//
//  Config.h
//  Chaozhi
//  Notes：接口地址【文档：http://101.201.222.8/showdoc/web/#/1 密码：abc123】
//  测试账号：18268686511/15737936517/15068850958 密码：123456 112233
//
//  Created by Jason_hzb on 2018/5/29.
//  Copyright © 2018年 小灵狗出行. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Config : NSObject

#pragma mark - ---------------接口地址---------------

NSString *domainUrl(void);

#pragma mark - ---------------接口名称---------------

#define URL_PhoneCaptcha @"api/phone-captcha" //获取验证码
#define URL_Login @"api/user/login" //登录
#define URL_Reg @"api/user/reg" //注册
#define URL_Reset @"api/user/reset" //重置密码
#define URL_UserInfo @"api/user/info" //用户信息
#define URL_AppHome @"api/app/home" //首页
#define URL_Category @"api/app/home-category" //首页分类数据
#define URL_CategoryList @"api/category/list" //课程分类
#define URL_CourseList @"api/course/list" //已购课程列表
#define URL_NewsList @"api/news/list"//首页的新知
#define URL_CheckVersion @"api/app/check-version"//版本更新

#pragma mark - ---------------H5地址---------------

NSString *h5Url(void);

#pragma mark - ---------------H5名称---------------

#define H5_MyInfo @"#/hybrid/me/info" //我的-个人中心
#define H5_Orders @"#/hybrid/orders" //我的-课程订单
#define H5_Message @"#/hybrid/message" //我的-我的消息
#define H5_Coupon @"#/hybrid/coupon" //我的-我的优惠券
#define H5_Feedback @"#/hybrid/feedback" //我的-问题反馈
#define H5_About @"#/hybrid/chaozhi/about" //我的-关于超职教育

#define H5_Question @"#/hybrid/study/library/" //学习-题库【学习课程id】
#define H5_Doc @"#/hybrid/study/doc/" //学习-资料【学习课程id】
#define H5_Live @"#/hybrid/study/live/" //学习-直播【学习课程id】
#define H5_Video @"#/hybrid/study/video/" //学习-录播【学习课程id】

#define H5_Infinite @"#/hybrid/Infinite" //无限

#define H5_InfiniteNews @"#/hybrid/infinite/news/" //首页-每日新知【新知id】
#define H5_StoreProduct @"#/hybrid/store/product/" //首页-课程【课程id】
#define H5_Store @"#/hybrid/store/" //首页-推荐课程列表【课程分类id】
#define H5_Demo @"#/hybrid/demo/" //首页-公开课开始试听【课程分类id】

#define H5_Privacy @"#/hybrid/chaozhi/privacy" //隐私协议

@end
