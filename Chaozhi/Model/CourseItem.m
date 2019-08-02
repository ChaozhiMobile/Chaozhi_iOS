//
//  CourseItem.m
//  Chaozhi
//
//  Created by Jason_zyl on 2019/8/2.
//  Copyright © 2019 Jason_hzb. All rights reserved.
//

#import "CourseItem.h"

@implementation CourseItem

- (void)setImg:(NSString *)img {
    if (_img != img) {
        if ([img containsString:@"http"]) {
            _img = img;
        } else {
            _img = [NSString stringWithFormat:@"http:%@",img];
        }
    }
}

@end
