

#import "UIImageView+Exten.h"

#define noDisableHorizontalScrollTag 836914

@implementation UIImageView (UIImageView_Exten)
- (void) setAlpha:(CGFloat)alpha {

    if (self.superview.tag == noDisableHorizontalScrollTag) {

        [super setAlpha:1.0];

    }else{
          [super setAlpha:alpha];
    }
  
}
@end
