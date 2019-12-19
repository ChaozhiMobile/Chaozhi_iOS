//
//  CZVerticalLabel.h
//  Chaozhi
//
//  Created by Jason_zyl on 2019/12/19.
//  Copyright © 2019 Jason_hzb. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM (NSInteger ,VerticalAlignment){
    VerticalAlignmentTop = 0,  //上居中
    VerticalAlignmentMiddle, //中居中
    VerticalAlignmentBottom //低居中
};

NS_ASSUME_NONNULL_BEGIN

@interface CZVerticalLabel : UILabel

@property (nonatomic,assign)VerticalAlignment verticalAlignment;

@end

NS_ASSUME_NONNULL_END
