//
//  TalkfunNewChatCell.m
//  TalkfunSDKDemo
//
//  Created by Sunzn on 2017/1/24.
//  Copyright © 2017年 talk-fun. All rights reserved.
//

#import "TalkfunNewChatCell.h"
#import "ChatModel.h"
#import "MJExtension.h"
#import "UIImageView+WebCache.h"
@interface TalkfunNewChatCell ()<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *xxxxx;

@end
@implementation TalkfunNewChatCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.content setDelegate:self];
    [self.content setEditable:NO];
    self.roleLabel.clipsToBounds = YES;
     self.avatarImageView.clipsToBounds = YES;
    self.bgView.layer.borderWidth = 1.0;
    self.bgView.layer.cornerRadius = 5.0;
    self.bgContent.delegate = self;
    [self.bgContent setSelectable:YES];
    [self.bgContent setEditable:NO];
    self.bgContent.scrollEnabled = NO;
    self.bgContent.dataDetectorTypes = UIDataDetectorTypeLink;
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange {
//    NSLog(@"url :%@",URL);
    if ([[URL scheme] isEqualToString:@"talkfun"]) {
        NSString *host = [URL host];
        NSLog(@"host:%@",host);
        NSArray * comp = [host componentsSeparatedByString:@"."];
        NSString * vid = comp[0];
        NSString * name = comp.lastObject;
        if ([name isEqualToString:@"1"]) {
            self.btnBlock(NO,vid);
        }
        else if ([name isEqualToString:@"0"])
        {
            self.btnBlock(YES,vid);
        }
        
        return NO;
    }
    return YES;
}

- (void)configCell:(NSDictionary *)dict{
//    self.bgView.hidden = YES;
//    self.roleLabel.hidden = YES;
//    self.nameTimeLabel.hidden = YES;
//    self.content.hidden = YES;
  
    ChatModel *model = [ChatModel mj_objectWithKeyValues:dict];
    
    //抽奖 投票 踢人 广播 禁言
    NSString * vote_new     = model.vote_new;
    NSString * vote_pub     = model.vote_pub;
    NSString * lottery_stop = model.lottery_stop;
    NSString * broadcast    = model.broadcast;
    NSString * chat_disable = model.chat_disable;
    NSString * member_kick  = model.member_kick;
    
    NSString * allString = nil;
    
    //投票
    if (vote_new || vote_pub) {
        [self isChatMsg:NO];
        NSString * appendStr = vote_new?@"投票":[model.isShow isEqualToString:@"0"]?@"":@"查看结果";
        
        if([vote_new hasSuffix:@"点名"]){
            allString = vote_new;
        }
        
       else if (vote_pub) {
           if([vote_pub hasPrefix:@"点名结束"]||[vote_pub hasPrefix:@"通知:"]){
               
//               self.bgImageView.hidden = YES;
               allString = vote_pub;
           }else{
                allString = [NSString stringWithFormat:@"%@%@",vote_pub,[model.isShow isEqualToString:@"0"]?@"":@"查看结果"];
           }
           
           
        }else
            allString = [NSString stringWithFormat:@"%@投票",vote_new];
        
        NSString * nickname = model.nickname;
        NSRange range = NSMakeRange(0, 0);
        
        if (nickname) {
             range =  [allString rangeOfString:nickname];
        }
       
        //设置字符串属性
        NSDictionary * contentDict = [TalkfunUtils assembleAttributeString:allString boundingSize:CGSizeMake(CGRectGetWidth(self.frame)-55, CGFLOAT_MAX) fontSize:14 shadow:NO];
        NSMutableAttributedString * mStr = [[NSMutableAttributedString alloc] initWithAttributedString:contentDict[AttributeStr]];
//        NSMutableAttributedString * mStr = [[NSMutableAttributedString alloc] initWithString:allString];
        [mStr addAttributes:@{NSForegroundColorAttributeName:[UIColor lightGrayColor],NSFontAttributeName:[UIFont systemFontOfSize:12]} range:NSMakeRange(0, allString.length)];
        [mStr addAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:[UIFont boldSystemFontOfSize:12]} range:range];
        
        if (appendStr && ![appendStr isEqualToString:@""]&& ![vote_new hasSuffix:@"点名"]&&![vote_pub hasPrefix:@"点名结束"]&&![vote_pub hasPrefix:@"通知:"]) {
            NSRange appendStrRange = [allString rangeOfString:appendStr];
            [mStr addAttribute:NSLinkAttributeName
                         value:[NSString stringWithFormat:@"talkfun://%@.%@",model.vid,[appendStr isEqualToString:@"投票"]?@"1":@"0"]
                         range:appendStrRange];
            [mStr addAttribute:NSForegroundColorAttributeName
                           value:[UIColor blueColor]
                           range:appendStrRange];
            [mStr addAttribute:NSUnderlineStyleAttributeName
                           value:@(NSUnderlineStyleSingle)
                           range:appendStrRange];
            [mStr endEditing];
        }
        
        CGRect rect = [allString boundingRectWithSize:CGSizeMake(self.frame.size.width - 80, 9999) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];
        
        if (rect.size.height < 40) {
            rect.size.height = 40;
        }
        self.bgView.layer.borderColor  = [UIColor colorWithRed:255 / 255.0 green:208 / 255.0 blue:133 / 255.0 alpha:1].CGColor;
        self.bgView.backgroundColor    = [UIColor colorWithRed:255 / 255.0 green:243 / 255.0 blue:223 / 255.0 alpha:1];
        self.bgImageView.image = [UIImage imageNamed:@"vote"];
        
        self.bgContent.attributedText = mStr;
    }
    //抽奖
    else if (lottery_stop)
    {
        [self isChatMsg:NO];
        allString = lottery_stop;
        
        NSString * launch_nickname = model.launch_nickname;
        NSString * nickname        = model.nickname;
        
        NSRange range              = [allString rangeOfString:launch_nickname];
        NSRange range2             = [allString rangeOfString:nickname];
        
        //设置字符串属性
        NSDictionary * contentDict = [TalkfunUtils assembleAttributeString:allString boundingSize:CGSizeMake(CGRectGetWidth(self.frame)-55, CGFLOAT_MAX) fontSize:14 shadow:NO];
        
        NSMutableAttributedString * mStr = [[NSMutableAttributedString alloc] initWithAttributedString:contentDict[AttributeStr]];
        [mStr addAttributes:@{NSForegroundColorAttributeName:[UIColor lightGrayColor],NSFontAttributeName:[UIFont systemFontOfSize:12]} range:NSMakeRange(0, allString.length)];
        [mStr addAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:[UIFont boldSystemFontOfSize:12]} range:range];
        [mStr addAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:[UIFont boldSystemFontOfSize:12]} range:range2];
        
        self.bgView.layer.borderColor = [UIColor colorWithRed:255 / 255.0 green:208 / 255.0 blue:133 / 255.0 alpha:1].CGColor;
        self.bgView.layer.borderWidth = 1.0;
        self.bgView.layer.cornerRadius = 5.0;
        self.bgView.backgroundColor = [UIColor colorWithRed:255 / 255.0 green:243 / 255.0 blue:223 / 255.0 alpha:1];
        
        self.bgImageView.image = [UIImage imageNamed:@"notification"];
        
        self.bgContent.attributedText = mStr;
    }
    //广播
    else if (broadcast)
    {
        [self isChatMsg:NO];
        allString       = broadcast;
        NSString * mess = model.mess;
        NSRange range   = [allString rangeOfString:mess];
        //设置字符串属性
        NSDictionary * contentDict = [TalkfunUtils assembleAttributeString:allString boundingSize:CGSizeMake(CGRectGetWidth(self.frame)-55, CGFLOAT_MAX) fontSize:14 shadow:NO];
        NSMutableAttributedString * mStr = [[NSMutableAttributedString alloc] initWithAttributedString:contentDict[AttributeStr]];
//        NSMutableAttributedString * mStr = [[NSMutableAttributedString alloc] initWithString:allString];
        [mStr addAttributes:@{NSForegroundColorAttributeName:[UIColor lightGrayColor],NSFontAttributeName:[UIFont systemFontOfSize:12]} range:NSMakeRange(0, allString.length)];
        [mStr addAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:[UIFont boldSystemFontOfSize:12]} range:range];
        
        self.bgView.layer.borderColor = [UIColor colorWithRed:255 / 255.0 green:208 / 255.0 blue:133 / 255.0 alpha:1].CGColor;
        self.bgView.layer.borderWidth = 1.0;
        self.bgView.layer.cornerRadius = 5.0;
        self.bgView.backgroundColor = [UIColor colorWithRed:255 / 255.0 green:243 / 255.0 blue:223 / 255.0 alpha:1];
        
        self.bgImageView.image = [UIImage imageNamed:@"broadcast"];
        
        self.bgContent.attributedText = mStr;
        
    }
    //禁言
    else if (chat_disable)
    {
        [self isChatMsg:NO];
        allString = chat_disable;
        NSString * nickname = model.nickname;
        
        NSRange range = [allString rangeOfString:nickname];
        
        //设置字符串属性
        NSDictionary * contentDict = [TalkfunUtils assembleAttributeString:allString boundingSize:CGSizeMake(CGRectGetWidth(self.frame)-55, CGFLOAT_MAX) fontSize:14 shadow:NO];
        
        NSMutableAttributedString * mStr = [[NSMutableAttributedString alloc] initWithAttributedString:contentDict[AttributeStr]];
//        NSMutableAttributedString * mStr = [[NSMutableAttributedString alloc] initWithString:allString];
        [mStr addAttributes:@{NSForegroundColorAttributeName:[UIColor lightGrayColor],NSFontAttributeName:[UIFont systemFontOfSize:12]} range:NSMakeRange(0, allString.length)];
        [mStr addAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:[UIFont boldSystemFontOfSize:12]} range:range];
        
        self.bgView.layer.borderColor  = [UIColor colorWithRed:255 / 255.0 green:208 / 255.0 blue:133 / 255.0 alpha:1].CGColor;
        self.bgView.layer.borderWidth  = 1.0;
        self.bgView.layer.cornerRadius = 5.0;
        self.bgView.backgroundColor    = [UIColor colorWithRed:255 / 255.0 green:243 / 255.0 blue:223 / 255.0 alpha:1];
        
        self.bgImageView.image = [UIImage imageNamed:@"broadcast"];
        
        self.bgContent.attributedText = mStr;
        
    }
    //踢人
    else if (member_kick)
    {
        [self isChatMsg:NO];
        allString = member_kick;
        NSString * nickname = model.nickname;
        
        NSRange range = [allString rangeOfString:nickname];
        
        //设置字符串属性
        NSDictionary * contentDict = [TalkfunUtils assembleAttributeString:allString boundingSize:CGSizeMake(CGRectGetWidth(self.frame)-55, CGFLOAT_MAX) fontSize:14 shadow:NO];
        
        NSMutableAttributedString * mStr = [[NSMutableAttributedString alloc] initWithAttributedString:contentDict[AttributeStr]];
//        NSMutableAttributedString * mStr = [[NSMutableAttributedString alloc] initWithString:allString];
        [mStr addAttributes:@{NSForegroundColorAttributeName:[UIColor lightGrayColor],NSFontAttributeName:[UIFont systemFontOfSize:12]} range:NSMakeRange(0, allString.length)];
        [mStr addAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:[UIFont boldSystemFontOfSize:12]} range:range];
        
        self.bgView.layer.borderColor  = [UIColor colorWithRed:255 / 255.0 green:208 / 255.0 blue:133 / 255.0 alpha:1].CGColor;
        self.bgView.layer.borderWidth  = 1.0;
        self.bgView.layer.cornerRadius = 5.0;
        self.bgView.backgroundColor    = [UIColor colorWithRed:255 / 255.0 green:243 / 255.0 blue:223 / 255.0 alpha:1];
        
        self.bgImageView.image = [UIImage imageNamed:@"broadcast"];
        
        self.bgContent.attributedText = mStr;
    }else{
        [self isChatMsg:YES];
        if ([model.role isEqualToString:TalkfunMemberRoleSpadmin]) {
            self.roleLabel.text = @"老师";
            self.roleLabelWidth.constant = 27;
            self.roleLabel.layer.cornerRadius = 3;
            self.roleLabel.backgroundColor = [UIColor redColor];
            self.xxxxx.constant = -24;
        }
        //=============== 如果是助教说的话 =================
        else if ([model.role isEqualToString:TalkfunMemberRoleAdmin])
        {
            self.roleLabel.text = @"助教";
            self.roleLabelWidth.constant = 27;
            self.roleLabel.layer.cornerRadius = 3;
            self.roleLabel.backgroundColor = [UIColor orangeColor];
             self.xxxxx.constant = -24;
        }else{
            self.roleLabelWidth.constant = 0;
        }
         self.avatarImageView.layer.cornerRadius = 10;
         [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:[UIImage imageNamed:@"占位图"] options:0];
     
        self.nameTimeLabel.textColor = LIGHTBLUECOLOR;
        self.nameTimeLabel.attributedText = [TalkfunUtils getUserNameAndTimeWith:dict playback:NO];
        if (!model.msg) {
            NSInteger amount = [model.amount integerValue];
            NSMutableString * message = [NSMutableString new];
            [message appendString:@"送给老师："];
            for (int i = 0; i < amount; i ++) {
                [message appendString:@"[rose]"];
            }
            model.msg = message;
        }
        NSDictionary * contentDict = [TalkfunUtils assembleAttributeString:model.msg boundingSize:CGSizeMake(ScreenSize.width-48, CGFLOAT_MAX) fontSize:13 shadow:NO];
        NSAttributedString * attr = contentDict[AttributeStr];
        NSMutableAttributedString * contentAttrStr = [[NSMutableAttributedString alloc] initWithAttributedString:attr];
        UIColor * contentColor = [UIColor whiteColor];
//        if ([model.msg rangeOfString:@"送给老师：[S_FLOWER]"].location != NSNotFound) {
//            contentColor = [UIColor lightGrayColor];
//        }
        [contentAttrStr addAttribute:NSForegroundColorAttributeName value:contentColor range:NSMakeRange(0, attr.length)];
        [contentAttrStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:13] range:NSMakeRange(0, attr.length)];
        self.content.attributedText = contentAttrStr;
    }
}

- (void)isChatMsg:(BOOL)chatMsg{
    self.content.hidden = !chatMsg;
    self.roleLabel.hidden = !chatMsg;
    self.nameTimeLabel.hidden = !chatMsg;
    self.bgView.hidden = !self.content.hidden;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}


-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    return NO;
}






@end
