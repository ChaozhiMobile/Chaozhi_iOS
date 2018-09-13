//
//  OptionBarController.h
//  SuperMarket
//
//  Created by hanzhanbing on 16/7/15.
//  Copyright © 2016年 柯南. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OptionBarController : UIViewController

@property (nonatomic,assign)BOOL showLineView;//分割线
@property (nonatomic,assign)BOOL showBottomView;//底部线
@property (nonatomic,strong)NSArray *controllersArr;
@property (nonatomic,assign)CGRect frame;
@property (nonatomic,strong)UIColor *linecolor;
@property (nonatomic,strong)UIColor *selectedViewColor;
@property (nonatomic,strong)UIColor *selectedTextColor;
@property (nonatomic,assign)int currentPage;//当前页

typedef void(^SegmentClickBlock)(NSInteger currentIndex);
@property(nonatomic, copy)SegmentClickBlock clickBlock;

- (instancetype)initWithFrame:(CGRect)frame andSubViewControllers:(NSArray *)controllersArr andParentViewController:(UIViewController *)viewController andSelectedViewColor:(UIColor *)selectedViewColor andSelectedTextColor:(UIColor *)selectedTextColor andShowSeperateLine:(BOOL)showSeperateLine andShowBottomLine:(BOOL)showBottomLine andCurrentPage:(int)page;

@end
