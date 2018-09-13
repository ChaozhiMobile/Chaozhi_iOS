//
//  LogShowView.m
//  Chaozhi
//  Notes：
//
//  Created by Jason_hzb on 2018/5/29.
//  Copyright © 2018年 小灵狗出行. All rights reserved.
//

#import "LogShowView.h"

@interface LogShowView() {
    UIButton *_logBtn;
}
@end

@implementation LogShowView

+ (instancetype)shareInstance {
    static LogShowView *singleton = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleton = [[LogShowView alloc] init];
    });
    return singleton;
}

- (id)init {
    self = [super init];
    if (self) {
        [self initViews];
    }
    return self;
}

- (void)initViews {
    self.frame = CGRectMake(autoScaleW(20), HEIGHT-autoScaleW(64), autoScaleW(44), autoScaleW(44));
    _logBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, autoScaleW(44), autoScaleW(44))];
    [_logBtn setTitle:@"调试" forState:0];
    _logBtn.backgroundColor = [UIColor whiteColor];
    [_logBtn setTitleColor:kBlueColor forState:UIControlStateNormal];
    _logBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [_logBtn.layer setCornerRadius:autoScaleW(10.0)];
    
    [Utils setViewShadowStyle:_logBtn];
    [_logBtn addTarget:self action:@selector(showInfo) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_logBtn];
    self.clipsToBounds = YES;
    _textViews = [[UITextView alloc]initWithFrame:CGRectMake(15, 30, WIDTH-30, HEIGHT-60)];
    _textViews.layer.cornerRadius = 10;
    _textViews.layer.shadowOffset =  CGSizeMake(0, 0); //阴影偏移量
    _textViews.layer.shadowOpacity = 0.2; //透明度
    _textViews.layer.shadowColor =  [UIColor blackColor].CGColor; //阴影颜色
    _textViews.layer.shadowRadius = 6; //模糊度
    _textViews.text = @"";
    _textViews.font = [UIFont systemFontOfSize:15];
    _textViews.editable = NO;
    _textViews.hidden = YES;
    [self addSubview:_textViews];
    [self addSubview:_logBtn];
    
    UIButton *clearBtn = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH-autoScaleW(64), HEIGHT-autoScaleW(64),  autoScaleW(44), autoScaleW(44))];
    [clearBtn setTitle:@"清除" forState:0];
    clearBtn.backgroundColor = [UIColor whiteColor];
    [clearBtn setTitleColor:kBlueColor forState:UIControlStateNormal];
    clearBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [clearBtn.layer setCornerRadius:autoScaleW(10.0)];
    [Utils setViewShadowStyle:clearBtn];
    [clearBtn addTarget:self action:@selector(clearLog) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:clearBtn];
    
    _logBtn.borderColor = [UIColor lightGrayColor];
    clearBtn.borderColor = [UIColor lightGrayColor];
}

- (void)showInfo {
    if (self.width>60) {
        self.frame = CGRectMake(autoScaleW(20), HEIGHT-autoScaleW(64), autoScaleW(44), autoScaleW(44));
        _logBtn.top = 0;
        _logBtn.left = 0;
        _textViews.hidden = YES;
    }else{
        self.frame = CGRectMake(0, 0, WIDTH, HEIGHT);
        _logBtn.top = self.height-autoScaleW(64);
        _textViews.hidden = NO;
        _logBtn.left = autoScaleW(20);
    }
}

- (void)clearLog {
    _textViews.text = @"";
}

@end
