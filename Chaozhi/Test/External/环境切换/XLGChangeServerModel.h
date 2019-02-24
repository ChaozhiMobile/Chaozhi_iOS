//
//  XLGChangeServerModel.h
//  SharenGo
//  Notes：环境切换model
//
//  Created by Jason_hzb on 2018/7/5.
//  Copyright © 2018年 小灵狗出行. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XLGChangeServerModel : NSObject

/*!
 *  @brief YES：选中 NO：没选中
 */
@property (nonatomic,assign) BOOL selectStatus;
/*!
 *  @brief 标题
 */
@property (nonatomic,copy) NSString *title;

@end
