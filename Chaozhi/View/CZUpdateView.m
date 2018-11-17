//
//  CZUpdateView.m
//  Chaozhi
//
//  Created by Jason_zyl on 2018/11/17.
//  Copyright © 2018年 Jason_hzb. All rights reserved.
//

#import "CZUpdateView.h"

@implementation CZUpdateView

- (instancetype)initWithBugDetail:(NSString *)details withType:(UpdateType)type {
    self = [super init];
    
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        self.size = CGSizeMake(autoScaleW(260), autoScaleW(214));
        
        self.layer.cornerRadius = 5;
        [self.layer setMasksToBounds:YES];
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"update_bg"]];
        imageView.frame = CGRectMake(0, 0, autoScaleW(260), autoScaleW(90));
        [self addSubview:imageView];
        
        UIButton *rejectBtn = [UIButton new];
        [rejectBtn setTitle:@"以后再说" forState:UIControlStateNormal];
        rejectBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [rejectBtn setTitleColor:RGB(181, 181, 181) forState:UIControlStateNormal];
        rejectBtn.layer.cornerRadius = 5;
        rejectBtn.layer.borderColor = RGB(222, 222, 222).CGColor;
        rejectBtn.layer.borderWidth = 1;
        [rejectBtn addTarget:self action:@selector(reject) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:rejectBtn];
        
        UIButton *rateBtn = [UIButton new];
        [rateBtn setTitle:@"立即升级" forState:UIControlStateNormal];
        rateBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [rateBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        rateBtn.backgroundColor = RGB(0, 207, 31);
        rateBtn.layer.cornerRadius = 5;
        [rateBtn addTarget:self action:@selector(update) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:rateBtn];
        
        UITextView *textView = [UITextView new];
        textView.text = details;
        textView.editable = NO;
        [self addSubview:textView];
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = autoScaleW(8);// 字体的行间距
        NSDictionary *attributes = @{
                                     NSFontAttributeName:[UIFont systemFontOfSize:12],
                                     NSForegroundColorAttributeName:RGBValue(0x646464),
                                     NSParagraphStyleAttributeName:paragraphStyle
                                     };
        textView.attributedText = [[NSAttributedString alloc] initWithString:textView.text attributes:attributes];
        
        if (type == UpdateTypeSelect) {
            [rejectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self).offset(autoScaleW(16));
                make.bottom.mas_equalTo(self).offset(-autoScaleW(20));
                make.size.mas_equalTo(CGSizeMake(autoScaleW(100), autoScaleW(34)));
            }];
            
            [rateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(self).offset(-autoScaleW(16));
                make.bottom.mas_equalTo(self).offset(-autoScaleW(20));
                make.size.mas_equalTo(CGSizeMake(autoScaleW(100), autoScaleW(34)));
            }];
        }
        else {
            [rateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(self);
                make.bottom.mas_equalTo(self).offset(-autoScaleW(20));
                make.size.mas_equalTo(CGSizeMake(autoScaleW(100), autoScaleW(34)));
            }];
        }
        
        [textView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self).offset(autoScaleW(16));
            make.right.mas_equalTo(self).offset(-autoScaleW(16));
            make.top.mas_equalTo(imageView.mas_bottom).offset(autoScaleW(10));
            make.bottom.mas_equalTo(rateBtn.mas_top).offset(-autoScaleW(10));
        }];
    }
    
    return self;
}

- (void)reject {
    if (self.delegate && [self.delegate respondsToSelector:@selector(updateRejectBtnClicked)]) {
        [self.delegate updateRejectBtnClicked];
    }
}

- (void)update {
    if (self.delegate && [self.delegate respondsToSelector:@selector(updateBtnClicked)]) {
        [self.delegate updateBtnClicked];
    }
}

@end
