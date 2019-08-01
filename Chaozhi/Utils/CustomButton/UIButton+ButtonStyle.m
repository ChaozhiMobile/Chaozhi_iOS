//
//  UIButton+ButtonStyle.m
//  XMButtonStyle
//
//  Created by Facebook on 2018/4/19.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#import "UIButton+ButtonStyle.h"

@implementation UIButton (ButtonStyle)

- (void)layoutTextWithImageButtonStyle:(layoutTextWithImageButtonStyle)style withSpace:(CGFloat)space{


    
    switch (style) {
        case LayoutTextUnderImageButton:{
            
            if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {

                self.titleEdgeInsets = UIEdgeInsetsMake(self.currentImage.size.height + space,-self.currentImage.size.width, 0, 0);
                self.imageEdgeInsets = UIEdgeInsetsMake(-self.titleLabel.intrinsicContentSize.height, 0, 0,self.titleLabel.intrinsicContentSize.width);
            } else {
                self.titleEdgeInsets = UIEdgeInsetsMake(self.currentImage.size.height + space,-self.currentImage.size.width, 0, 0);
                self.imageEdgeInsets = UIEdgeInsetsMake(-self.titleLabel.frame.size.height, 0, 0,-self.titleLabel.frame.size.width);
            }
            
         
        }
            break;
        case layoutTextLeftImageButton:{
            
                if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
                    
                    self.imageEdgeInsets = UIEdgeInsetsMake(0, self.titleLabel.intrinsicContentSize.width + space, 0, -self.titleLabel.intrinsicContentSize.width - space);
                    self.titleEdgeInsets = UIEdgeInsetsMake(0,-self.currentImage.size.width, 0, self.currentImage.size.width);
                    
                }else{
                    
                    self.imageEdgeInsets = UIEdgeInsetsMake(0, self.titleLabel.frame.size.width + space, 0, -self.titleLabel.frame.size.width - space);
                    self.titleEdgeInsets = UIEdgeInsetsMake(0,-self.currentImage.size.width, 0, self.currentImage.size.width);
                }
        }
            break;
        default:
            break;
    }


}
@end
