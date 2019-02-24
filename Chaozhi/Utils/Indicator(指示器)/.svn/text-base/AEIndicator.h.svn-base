//
//  AEIndicator.h
//  ArtEast
//
//  Created by yibao on 16/9/22.
//  Copyright © 2016年 北京艺宝网络文化有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AEIndicator : UIView
{
    UIImageView *imageView;
    UILabel *Infolabel;
}

@property (nonatomic, assign) NSString *loadtext;
@property (nonatomic, readonly) BOOL isAnimating;

- (void)startAnimation;
- (void)stopAnimationWithLoadText:(NSString *)text withType:(BOOL)type;
- (void)setLoadText:(NSString *)text;

+ (AEIndicator *)sharedIndicator;

@end
