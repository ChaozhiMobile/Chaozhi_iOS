//
//  OptionsBarItem.h
//  SuperMarket
//
//  Created by hanzhanbing on 16/7/15.
//  Copyright © 2016年 柯南. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OptionsBarItem : UIControl

@property (nonatomic,copy)NSString *title;
@property (nonatomic,retain)UIColor *textColor;
@property (nonatomic,retain)UIFont *textFont;
@property (nonatomic,assign)BOOL showSeprateLine;
@property (nonatomic,assign)NSInteger index;

-(instancetype)initWithFrame:(CGRect)frame;

-(void)setShowSeprateLine:(BOOL)showSeprateLine;

@end
