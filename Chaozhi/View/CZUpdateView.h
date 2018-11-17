//
//  CZUpdateView.h
//  Chaozhi
//
//  Created by Jason_zyl on 2018/11/17.
//  Copyright © 2018年 Jason_hzb. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, UpdateType) {
    UpdateTypeSelect = 0,    //选择升级
    UpdateTypeForce,        //默认升级
};


@protocol UpdateViewDelegate <NSObject>

- (void)updateRejectBtnClicked;
- (void)updateBtnClicked;

@end

@interface CZUpdateView : UIView

- (instancetype)initWithBugDetail:(NSString *)details withType:(UpdateType)type;

@property (nonatomic, assign) id<UpdateViewDelegate> delegate;

@end
