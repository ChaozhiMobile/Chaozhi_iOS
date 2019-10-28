//
//  TalkfunButtonView.m
//  TalkfunSDKDemo
//
//  Created by 孙兆能 on 2016/11/23.
//  Copyright © 2016年 talk-fun. All rights reserved.
//

#import "TalkfunButtonView.h"


@implementation TalkfunButtonView

+ (id)initView{
    TalkfunButtonView * btnView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil][0];
    btnView.backgroundColor = NEWBLUECOLOR;
    
    [btnView.chatBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnView.chatBtn setTitleColor:LIGHTBLUECOLOR forState:UIControlStateSelected];
    
    [btnView.askBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnView.askBtn setTitleColor:LIGHTBLUECOLOR forState:UIControlStateSelected];
    
    [btnView.noticeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnView.noticeBtn setTitleColor:LIGHTBLUECOLOR forState:UIControlStateSelected];
    
    [btnView.albumBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnView.albumBtn setTitleColor:LIGHTBLUECOLOR forState:UIControlStateSelected];
    
    btnView.selectView.backgroundColor = [UIColor whiteColor];
    
    btnView.chatBtn.selected = YES;
    btnView.askBtn.selected = YES;
    btnView.noticeBtn.selected = YES;
    
    if (IsIPAD) {
        UIFont *font = [UIFont systemFontOfSize:15];
        btnView.chatBtn.titleLabel.font = font;
        btnView.askBtn.titleLabel.font = font;
        btnView.noticeBtn.titleLabel.font = font;
        btnView.albumBtn.titleLabel.font = font;
        btnView.downloadBtn.titleLabel.font = font;
    }
    
    return btnView;
}

- (void)awakeFromNib{
    [super awakeFromNib];

    self.chatTipsView.hidden = YES;
    self.askTipsView.hidden  = YES;
    self.noticeTipsView.hidden = YES;
    self.albumBtn.hidden = YES;
    self.downloadBtn.hidden = YES;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    static int i = 0;
    if (i == 0) {
        self.selectViewLeadingSpace.constant = self.selectBtn.frame.origin.x;
        i ++;
    }
}

- (void)selectButton:(TalkfunNewButtonViewButton *)btn{
    if (btn == self.chatBtn) {
        self.chatTipsView.hidden = YES;
    }else if (btn == self.askBtn){
        self.askTipsView.hidden = YES;
    }else if (btn == self.noticeBtn){
        self.noticeTipsView.hidden = YES;
    }else if ((TalkfunNewFunctionButton *)btn == self.downloadBtn){
        return;
    }
    
    //聊天 与提问 的隐藏
    int hiddenCount = 0;
    
    if (self.chatBtn.hidden == YES) {
        hiddenCount = hiddenCount +1;
    }
    if (self.askBtn.hidden == YES) {
       
          hiddenCount = hiddenCount +1;
    }
    
    
    
    if (btn == self.chatBtn) {
        self.selectViewLeadingSpace.constant = 0;
    }else if (btn == self.askBtn){
        if (self.chatBtn.hidden) {
            self.selectViewLeadingSpace.constant = 0;
        }else{
             self.selectViewLeadingSpace.constant = btn.frame.size.width;
        }
      
    }else if (btn == self.noticeBtn){
        if (hiddenCount == 0 ) {
            self.selectViewLeadingSpace.constant = btn.frame.size.width *2;
        }else if (hiddenCount == 1 ) {
           self.selectViewLeadingSpace.constant = btn.frame.size.width;
        }else{
            self.selectViewLeadingSpace.constant = 0;
        }
    }
    
   
    self.selectBtn.selected = YES;
    self.selectBtn.backgroundColor = nil;
    self.selectBtn = btn;
    btn.selected = NO;
    [btn setBackgroundColor:DARKBLUECOLOR];
}

- (void)buttonsAddTarget:(id)target action:(SEL)action{
    [self.chatBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [self.askBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [self.noticeBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [self.albumBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [self.downloadBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

- (void)showTipsInButton:(TalkfunNewButtonViewButton *)btn{
    if (btn == self.chatBtn && self.chatBtn.selected) {
        self.chatTipsView.hidden = NO;
    }else if (btn == self.askBtn && self.askBtn.selected){
        self.askTipsView.hidden = NO;
    }else if (btn == self.noticeBtn && self.noticeBtn.selected){
        self.noticeTipsView.hidden = NO;
    }
}

static BOOL IsPlayback = NO;
- (void)isPlayback:(BOOL)isPlayback{
    IsPlayback = isPlayback;
    if (isPlayback) {
        self.downloadBtn.hidden = NO;
        [self.noticeBtn setTitle:@"章节" forState:UIControlStateNormal];
        [self.noticeBtn setTitleColor:LIGHTBLUECOLOR forState:UIControlStateSelected];
        [self.noticeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [self.noticeBtn setImage:[UIImage imageNamed:@"章节-默认"] forState:UIControlStateNormal];
        [self.noticeBtn setImage:[UIImage imageNamed:@"章节-点击"] forState:UIControlStateSelected];
    }
    self.chatBtnWidth.constant = getButtonWidth(IsPlayback);
}
- (BOOL)isPlayback{
    return IsPlayback;
}

- (void)album:(BOOL)album{
    self.albumBtn.hidden = !album;
}

@end
