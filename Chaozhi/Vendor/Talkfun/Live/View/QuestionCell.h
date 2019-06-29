//
//  QuestionCell.h
//  Talkfun_demo
//
//  Created by moruiquan on 16/1/26.
//  Copyright © 2016年 talk-fun. All rights reserved.
//

#import <UIKit/UIKit.h>
@class QuestionModel;
@interface QuestionCell : UITableViewCell

@property (nonatomic,strong ) QuestionModel       *Model;
@property (nonatomic,copy   ) NSString            * temp;
@property (nonatomic,copy   ) NSString            * nameTime;
@property (nonatomic,assign ) NSInteger           number;
@property (nonatomic,strong ) NSMutableArray      * heightArray;
@property (nonatomic,strong ) NSMutableDictionary * answerHeightDict;
@property (nonatomic,copy   ) NSString            * xid;

@end
