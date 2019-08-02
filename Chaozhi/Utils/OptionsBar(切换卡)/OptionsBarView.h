//
//  OptionsBarView.h
//  SuperMarket
//
//  Created by hanzhanbing on 16/7/15.
//  Copyright © 2016年 柯南. All rights reserved.
//

#import <UIKit/UIKit.h>
@class OptionsBarView;

@protocol OptionsBarViewDelegate <NSObject>

@optional
-(void)lhOptionBarView:(OptionsBarView *)optionBarView didSelectedItemWithCurrentIndex:(NSInteger)currentIndex;
@end

@interface OptionsBarView : UIView

@property (nonatomic,assign)NSInteger currentIndex;
@property (nonatomic,strong)NSArray *titles;
@property (nonatomic,assign)BOOL showSeprateLine;
@property (nonatomic,assign)BOOL showBottomLine;
@property (nonatomic,strong)UIColor *bottomLineColor;
@property (nonatomic,strong)UIColor *selectedViewColor;
@property (nonatomic,strong)UIColor *selectedTextColor;
@property (nonatomic,assign)id<OptionsBarViewDelegate>delegate;

-(instancetype)initWithFrame:(CGRect)frame;

@end
