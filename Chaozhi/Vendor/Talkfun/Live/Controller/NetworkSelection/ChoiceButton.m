
//
//  Created by Mac on 15/12/14.
//  Copyright © 2015年 com.moruiwei.www. All rights reserved.
//

#import "ChoiceButton.h"
#import "NetworkModel.h"
@interface ChoiceButton()
/** 图片 */
@property (nonatomic, weak) UIImageView *iconView;

/** 名字 */
@property (nonatomic, weak) UILabel *nameLabel;
@property (nonatomic, weak) UILabel *priceLabel;
@end
@implementation ChoiceButton

/** init方法内部会自动调用initWithFrame:方法 */
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {

        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = [UIFont systemFontOfSize:15];
        self.titleLabel.textColor = [UIColor blackColor];
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
    }
    return self;
}
/**
 * 当前控件的frame发生改变的时候就会调用
 * 这个方法专门用来布局子控件，设置子控件的frame
 */
- (void)layoutSubviews
{
    // 一定要调用super方法
    [super layoutSubviews];
    
    CGFloat imageViewW = 20;
    CGFloat imageViewH = 20;
    CGFloat imageViewX = 18;
    CGFloat imageViewY = (self.bounds.size.height - imageViewH) * 0.5;
    
    self.imageView.frame = CGRectMake(imageViewX, imageViewY, imageViewW,imageViewH);
    
    CGFloat titleX = CGRectGetMaxX(self.imageView.frame)-7;
    CGFloat titleW = self.bounds.size.width - titleX ;
    CGFloat titleH = self.bounds.size.height;
    CGFloat titleY = 0;
    
    if (self.imageView.image == nil) {
        
        self.titleLabel.frame = self.bounds;
        
    }
    else
    {
        
        self.titleLabel.frame = CGRectMake(titleX, titleY, titleW, titleH);
    
    }

    
}

- (void)setNetwork:(NetworkModel *)Network
{
    _Network = Network;
    
    [self setImage:[UIImage imageNamed:Network.key] forState:UIControlStateNormal];
    [self setTitle:Network.name forState:UIControlStateNormal];
 
}


@end
