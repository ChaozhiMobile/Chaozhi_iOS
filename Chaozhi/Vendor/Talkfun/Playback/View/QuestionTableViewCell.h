//
//  quizTableViewCell.h
//  Talkfun_demo
//
//  Created by 莫瑞伟 on 16/1/26.
//  Copyright © 2016年 talk-fun. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PlaybackQuestionModel;
@interface QuestionTableViewCell : UITableViewCell

@property (nonatomic ,strong ) PlaybackQuestionModel * Model;
@property (nonatomic,assign  ) NSInteger             number;
@property (nonatomic,strong  ) NSDictionary          * expressionDict;
@property (nonatomic,strong  ) NSMutableDictionary   * answerHeightDict;
@property (nonatomic,strong  ) NSMutableArray        * heightArray;
@property (nonatomic,strong  ) NSMutableArray        * selectedArray;

@end
