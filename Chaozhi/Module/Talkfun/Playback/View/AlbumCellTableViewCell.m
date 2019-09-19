//
//  AlbumCellTableViewCell.m
//  TalkfunSDKDemo
//
//  Created by moruiwei on 16/5/17.
//  Copyright © 2016年 talk-fun. All rights reserved.
//

#import "AlbumCellTableViewCell.h"
#import "AlbumModel.h"
#import "UIImageView+WebCache.h"
@interface AlbumCellTableViewCell()
/** 文字 */
@property (nonatomic, weak) UILabel *tex;

@property (nonatomic ,assign)int hour;//时
@property (nonatomic ,assign)int minute;//分
@property (nonatomic ,assign)int sec;//秒

@property (nonatomic,assign) NSInteger  number1;

@end
@implementation AlbumCellTableViewCell
/**
 *  添加子控件（把有可能显示的子控件都加进去）
 */
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        int hour = 0;
        _hour= hour;
        
        int minute = 0;
        _minute = minute;
        
        int sec = 0;
        _minute = sec;
        
        
        self.number1 = 0;
    }
    return self;
}

NSString *shi;
NSString *fen;
NSString *miao;
- (void)setModel:(AlbumModel *)Model
{
    _Model = Model;
    
    int time = [Model.duration intValue];
    
    self.hour =  time/3600%24;
    self.minute =  time/60%60;
    self.sec = time%60;
   
    if (self.hour<10) {
         shi = [NSString stringWithFormat:@"0%d",self.hour];
    }else{
         shi = [NSString stringWithFormat:@"%d",self.hour];
    }
   
    
    if (self.minute<10) {
        fen = [NSString stringWithFormat:@"0%d",self.minute];
    }else{
        fen = [NSString stringWithFormat:@"%d",self.minute];
    }
    
    if (self.sec<10) {
         miao = [NSString stringWithFormat:@"0%d",self.sec];
    }else{
         miao = [NSString stringWithFormat:@"%d",self.sec];
    }
    
    
  
    
    self.name.textColor = [UIColor whiteColor];
    self.name.text = Model.title;
    self.time.textColor = [UIColor whiteColor];
    self.time.text = [NSString stringWithFormat:@"%2@:%2@:%2@",shi,fen,miao];
    self.backgroundColor = [UIColor clearColor];
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:Model.img_small]];
 
 
    
    if (self.rotated) {
        self.time.hidden = YES;
   
        
        CGRect frame = self.name.frame;
        
        frame.size.height = 56;
        self.name.frame= frame;
      
        self.with.constant = 50;
        
    }
    else
    {
        self.with.constant = self.frame.size.width - 90;
        CGRect frame = self.name.frame;
        
        frame.size.height = 18;
        self.name.frame= frame;
        
        self.time.hidden = NO;
       
    }
    
    
    
    //cell的颜色
    self.backgroundColor =[UIColor clearColor];
    
    if ([self.selectedArray[self.number] integerValue] == 1) {
        self.backgroundColor = NEWBLUECOLOR;
//        self.backgroundColor = [UIColor colorWithRed:200 / 255.0 green:200 / 255.0 blue:200 / 255.0 alpha:1];
    }
    
}



@end
