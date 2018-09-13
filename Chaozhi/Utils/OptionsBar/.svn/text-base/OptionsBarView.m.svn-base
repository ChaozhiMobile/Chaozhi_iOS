//
//  OptionsBarView.m
//  SuperMarket
//
//  Created by hanzhanbing on 16/7/15.
//  Copyright © 2016年 柯南. All rights reserved.
//

#import "OptionsBarView.h"
#import "OptionsBarItem.h"
#import "BottomLineView.h"

@interface OptionsBarView()<UIScrollViewDelegate>{
    NSMutableArray *itemWidths;
    CGFloat offx;
    CGFloat space;
    CGFloat itemsWidth;
    CGFloat totalWidth;
    NSMutableArray *lineXArr;
}
@property (nonatomic,weak)UIScrollView *mainView;
@property (nonatomic,weak)BottomLineView *bottonLineView;
@end

@implementation OptionsBarView

-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if(self){
        UIScrollView *mainView=[[UIScrollView alloc]initWithFrame:CGRectZero];
        self.mainView=mainView;
        mainView.delegate=self;
        mainView.showsHorizontalScrollIndicator=NO;
        [self addSubview:mainView];
    }
    return self;
}

/**
 *  设置是否带分割线
 */
-(void)setShowSeprateLine:(BOOL)showSeprateLine{
    if(_showSeprateLine!=showSeprateLine){
        _showSeprateLine=showSeprateLine;
    }
}

/**
 *  设置是否带底部线
 */
-(void)setShowBottomLine:(BOOL)showBottomLine{
    if(_showBottomLine!=showBottomLine){
        _showBottomLine=showBottomLine;
    }
}

/**
 *  获取字符串的长度
 *
 *  @return size
 */
-(CGSize)widthWithTitle:(NSString *)title{
    NSDictionary *attribute=[NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:15] forKey:NSFontAttributeName];
    return [title sizeWithAttributes:attribute];
}

/**
 *  设置titles
 */
-(void)setTitles:(NSArray *)titles{
    if(_titles!=titles){
        _titles=titles;
    }
    [self setItemWidthsWith:titles];
}

/**
 *  设置ItemWidths
 */
-(void)setItemWidthsWith:(NSArray *)titles{
    itemWidths=[NSMutableArray array];
    for (NSString *titleStr in titles) {
        CGSize size = [self widthWithTitle:titleStr];
        NSNumber *width=[NSNumber numberWithFloat:size.width];
        [itemWidths addObject:width];
        itemsWidth = itemsWidth+size.width;
    }
    BOOL result=[self adjustTotalWidth];
    [self setActualItemWidth:result];
}

/**
 *  判断itemWidths是否超过整个屏幕的宽度
 */
-(BOOL)adjustTotalWidth{
    //左右各offx，中间space
    if (itemWidths.count<=5) { //一行最多显示5个
        offx = (WIDTH/itemWidths.count-30)/2;
        space = (WIDTH-offx*2-itemsWidth)/(itemWidths.count-1);
    } else {
        if (HEIGHT==736) { //plus
            offx = 20;
        } else {
            offx = 15;
        }
        space = (WIDTH-offx-165)/5;
    }
    totalWidth=offx*2;
    for (NSNumber *number in itemWidths) {
        CGFloat width=[number floatValue];
        totalWidth+=width+space;
    }
    totalWidth -=space;
    if(totalWidth<=WIDTH){
        return NO;
    }else{
        return YES;
    }
}

/**
 *  设置每一个item具体的长度
 */
-(void)setActualItemWidth:(BOOL)result{
    NSMutableArray *temp=[NSMutableArray array];
    if(!result){
        [itemWidths enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSNumber *width=(NSNumber *)obj;
            CGFloat new=[width floatValue]/totalWidth*WIDTH;
            NSNumber *newWidth=[NSNumber numberWithFloat:new];
            [temp addObject:newWidth];
        }];
        itemWidths=temp;
        totalWidth=WIDTH;
    }
    self.mainView.contentSize=CGSizeMake(totalWidth, 42);
    [self setUpAllItems];
}

/**
 *  生成所有的Items和下划线
 */
-(void)setUpAllItems{
    CGFloat itemX=offx;
    lineXArr=[NSMutableArray array];
    for (NSInteger i=0; i<self.titles.count; i++) {
        if(i==self.titles.count-1&&_showSeprateLine){
            _showSeprateLine=!_showSeprateLine;
        }
        [lineXArr addObject:[NSNumber numberWithFloat:itemX]];
        OptionsBarItem *item=[[OptionsBarItem alloc]initWithFrame:CGRectMake(itemX, 0, [itemWidths[i] floatValue], 42)];
        item.tag = 10000+i;
        if (i==0) {
            item.backgroundColor=_selectedViewColor;
            item.textColor = _selectedTextColor;
        }
        item.title=self.titles[i];
        item.showSeprateLine=_showSeprateLine;
        item.index=i;
        if (i==self.titles.count-1) {
            itemX+=[itemWidths[i] floatValue]+offx;
        } else {
            itemX+=[itemWidths[i] floatValue]+space;
        }
        
        [self.mainView addSubview:item];
        [item addTarget:self action:@selector(clickItem:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    //定义初始的index
    _currentIndex=0;
    CGFloat lineWidth=[itemWidths[_currentIndex] floatValue];
    BottomLineView *line=[[BottomLineView alloc]initWithFrame:CGRectMake(0, 42-3.5, lineWidth, 3.5)];
    line.lineColer = _bottomLineColor;
    self.bottonLineView=line;
    self.bottonLineView.hidden = !_showBottomLine;
    [self.mainView addSubview:line];
}

/**
 *  按钮的响应事件(重点)
 */
-(void)clickItem:(OptionsBarItem *)item{
    //    self.currentIndex=item.index;
    
    for (int i = 0; i<self.titles.count; i++) {
        OptionsBarItem *barItem = [self viewWithTag:10000+i];
        if (barItem.tag == item.tag) {
            barItem.textColor = _selectedTextColor;
            barItem.backgroundColor=_selectedViewColor;
        } else {
            barItem.backgroundColor=_selectedViewColor;
            //barItem.textColor = AEColor(134, 134, 134, 1);
            barItem.textColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.6];
        }
    }
    
    if([self.delegate respondsToSelector:@selector(lhOptionBarView:didSelectedItemWithCurrentIndex:)]){
        [self.delegate lhOptionBarView:self didSelectedItemWithCurrentIndex:item.index];
    }
}

/**
 *  判断点击的方向
 *
 *  @param index <#item description#>
 */
-(void)adjustSelectedCurrentIndex:(NSInteger)index{
    if(index>_currentIndex){ //右
        _currentIndex=index;
        if(self.currentIndex<self.titles.count-1){
            CGFloat lineX=[lineXArr[_currentIndex+1]floatValue];
            CGFloat width=[itemWidths[_currentIndex+1]floatValue];
            if((lineX+width)>WIDTH){
                CGFloat temp= lineX+width-WIDTH;
                [self.mainView setContentOffset:CGPointMake(temp, 0) animated:YES];
            }
        } else {
            [self.mainView setContentOffset:CGPointMake(totalWidth-WIDTH, 0) animated:YES];
        }
    }
    if(index<_currentIndex){ //左
        _currentIndex=index;
        if(_currentIndex>0){
            CGFloat lineX=[lineXArr[_currentIndex]floatValue];
            CGFloat width=[itemWidths[_currentIndex-1]floatValue];
            if((lineX-width)>WIDTH){
                CGFloat temp= lineX+width-WIDTH;
                [self.mainView setContentOffset:CGPointMake(temp, 0) animated:YES];
            }
            if(lineX>WIDTH&&(lineX-width)<WIDTH){
                [self.mainView setContentOffset:CGPointMake(0, 0) animated:YES];
            }
            if(lineX<WIDTH){
                if (index!=itemWidths.count-2) { //倒数第二个不滑
                    [self.mainView setContentOffset:CGPointMake(0, 0) animated:YES];
                }
            }
        } else {
            [self.mainView setContentOffset:CGPointMake(0, 0) animated:YES];
        }
    }
}

-(void)setCurrentIndex:(NSInteger)currentIndex{
    [self adjustSelectedCurrentIndex:currentIndex];
    [UIView animateWithDuration:0.2 animations:^{
        CGFloat lineWidth=[itemWidths[_currentIndex]floatValue];
        CGFloat lineX=[lineXArr[_currentIndex]floatValue];
        self.bottonLineView.frame=CGRectMake(lineX-10, 42-3.5, lineWidth+20, 3.5);
    }];
    for (int i = 0; i<self.titles.count; i++) {
        OptionsBarItem *barItem = [self viewWithTag:10000+i];
        if (barItem.tag == 10000+currentIndex) {
            barItem.textColor = _selectedTextColor;
            barItem.backgroundColor=_selectedViewColor;
        } else {
            barItem.backgroundColor=_selectedViewColor;
            //barItem.textColor = AEColor(134, 134, 134, 1);
            barItem.textColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.6];
        }
    }
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.mainView.frame=self.bounds;
}

@end
