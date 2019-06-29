//
//  ChapterMOdel.h
//  Talkfun_demo
//
//  Created by moruiquan on 16/1/25.
//  Copyright © 2016年 talk-fun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChapterModel : NSObject
//章节
@property (nonatomic,copy  ) NSString       *course;
@property (nonatomic,copy  ) NSString       *page;
@property (nonatomic,copy  ) NSString       *starttime;
@property (nonatomic,copy  ) NSString       *thumb;
@property (nonatomic,copy  ) NSString       *title;

@property (nonatomic,assign) BOOL           rotated;
@property (nonatomic,strong) NSMutableArray * selectedArray;
//序号
@property (nonatomic,assign) NSInteger      number;

@end
