//
//  ChatCell.m
//  Talkfun_demo
//
//  Created by moruiquan on 16/1/26.
//  Copyright © 2016年 talk-fun. All rights reserved.
//

#import "ChatCell.h"
#import "MJExtension.h"
#import "ChatModel.h"
//#import "TalkfunSDK.h"
#define BEGIN_FLAG @"["
#define END_FLAG @"]"
#define KFacialSizeWidth  18
#define KFacialSizeHeight 18
#define MAX_WIDTH [UIScreen mainScreen].bounds.size.width - 40
@interface ChatCell ()

@end
@implementation ChatCell


-(void)setModel:(ChatModel *)Model
{
    _Model = Model;


    //抽奖 投票 踢人 广播 禁言
    NSString * vote_new     = Model.vote_new;
    NSString * vote_pub     = Model.vote_pub;
    NSString * lottery_stop = Model.lottery_stop;
    NSString * broadcast    = Model.broadcast;
    NSString * chat_disable = Model.chat_disable;
    NSString * member_kick  = Model.member_kick;
    
    NSString * allString = nil;
    
    //投票
    if (vote_new || vote_pub) {
        if (vote_pub) {
            allString = vote_pub;
        }else
            allString = vote_new;
        
        NSString * nickname = Model.nickname;
        NSRange range = [allString rangeOfString:nickname];
        
        //设置字符串属性
        NSMutableAttributedString * mStr = [[NSMutableAttributedString alloc] initWithString:allString];
        [mStr addAttributes:@{NSForegroundColorAttributeName:[UIColor lightGrayColor],NSFontAttributeName:[UIFont systemFontOfSize:12]} range:NSMakeRange(0, allString.length)];
        [mStr addAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:[UIFont boldSystemFontOfSize:12]} range:range];
        
        CGRect rect = [allString boundingRectWithSize:CGSizeMake(self.frame.size.width - 80, 9999) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];
        
        if (rect.size.height < 40) {
            rect.size.height = 40;
        }
        
        UIView * bgView           = [[UIView alloc] initWithFrame:CGRectMake(5, 2, self.frame.size.width - 10, rect.size.height - 5)];
        bgView.layer.borderColor  = [UIColor colorWithRed:255 / 255.0 green:208 / 255.0 blue:133 / 255.0 alpha:1].CGColor;
        bgView.layer.borderWidth  = 1.0;
        bgView.layer.cornerRadius = 5.0;
        bgView.backgroundColor    = [UIColor colorWithRed:255 / 255.0 green:243 / 255.0 blue:223 / 255.0 alpha:1];
        
        UIImageView * image = [[UIImageView alloc] initWithFrame:CGRectMake(5, CGRectGetHeight(bgView.frame) / 2.0 - 15 / 2.0, 15, 15)];
        image.image = [UIImage imageNamed:@"vote"];
        
        [bgView addSubview:image];
        
        UILabel * label      = [[UILabel alloc] initWithFrame:CGRectMake(25, 0, rect.size.width, rect.size.height - 5)];
        label.attributedText = mStr;
        label.numberOfLines  = 0;
        
        //投票按钮
        NSString * btnTitle = @"投票";
        if (vote_pub) {
            btnTitle = @"查看结果";
        }
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        NSMutableAttributedString * aStr = [[NSMutableAttributedString alloc] initWithString:btnTitle];
        [aStr addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSUnderlineStyleAttributeName:@(1),NSForegroundColorAttributeName:[UIColor colorWithRed:0 green:178 / 255.0 blue:1 alpha:1]} range:NSMakeRange(0, btnTitle.length)];
        [btn setAttributedTitle:aStr forState:UIControlStateNormal];
        btn.frame = CGRectMake(CGRectGetMaxX(label.frame), 0, 30, rect.size.height - 5);
        
        [btn addTarget:self action:@selector(tableViewBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        NSInteger btnTag = [Model.vid integerValue];
        btn.tag          = btnTag;
        [bgView addSubview:btn];
        
        if (vote_pub) {
            btnTag = [Model.vid  integerValue];
            btn.tag = btnTag;
            btn.frame = CGRectMake(CGRectGetMaxX(label.frame), 0, 50, rect.size.height - 5);
        }
        
        if ([Model.isShow isEqualToString:@"0"]) {
            btn.hidden = YES;
        }
        
        [bgView addSubview:label];
        
        [self.contentView addSubview:bgView];
      //  return cell;
    }
    //抽奖
    else if (lottery_stop)
    {
        allString = lottery_stop;
        
        NSString * launch_nickname = Model.launch_nickname;
        NSString * nickname        = Model.nickname;

        NSRange range              = [allString rangeOfString:launch_nickname];
        NSRange range2             = [allString rangeOfString:nickname];
        
        //设置字符串属性
        NSMutableAttributedString * mStr = [[NSMutableAttributedString alloc] initWithString:allString];
        [mStr addAttributes:@{NSForegroundColorAttributeName:[UIColor lightGrayColor],NSFontAttributeName:[UIFont systemFontOfSize:12]} range:NSMakeRange(0, allString.length)];
        [mStr addAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:[UIFont boldSystemFontOfSize:12]} range:range];
        [mStr addAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:[UIFont boldSystemFontOfSize:12]} range:range2];
        
        CGRect rect = [allString boundingRectWithSize:CGSizeMake(self.frame.size.width - 40, 9999) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];
        
        if (rect.size.height < 40) {
            rect.size.height = 40;
        }
        
        //为消息加图片
        UIView * bgView = [[UIView alloc] initWithFrame:CGRectMake(5, 2, self.frame.size.width - 10, rect.size.height - 5)];
        bgView.layer.borderColor = [UIColor colorWithRed:255 / 255.0 green:208 / 255.0 blue:133 / 255.0 alpha:1].CGColor;
        bgView.layer.borderWidth = 1.0;
        bgView.layer.cornerRadius = 5.0;
        bgView.backgroundColor = [UIColor colorWithRed:255 / 255.0 green:243 / 255.0 blue:223 / 255.0 alpha:1];
        
        UIImageView * image = [[UIImageView alloc] initWithFrame:CGRectMake(5, CGRectGetHeight(bgView.frame) / 2.0 - 15 / 2.0, 15, 15)];
        image.image = [UIImage imageNamed:@"notification"];
        
        [bgView addSubview:image];
        
        UILabel * label      = [[UILabel alloc] initWithFrame:CGRectMake(25, 0, self.frame.size.width - 40, rect.size.height - 5)];
        label.attributedText = mStr;
        label.numberOfLines  = 0;
        
        [bgView addSubview:label];
        
        [self.contentView addSubview:bgView];
        //return cell;
    }
    //广播
    else if (broadcast)
    {
        allString       = broadcast;
        NSString * mess = Model.mess;
        NSRange range   = [allString rangeOfString:mess];
        //设置字符串属性
        NSMutableAttributedString * mStr = [[NSMutableAttributedString alloc] initWithString:allString];
        [mStr addAttributes:@{NSForegroundColorAttributeName:[UIColor lightGrayColor],NSFontAttributeName:[UIFont systemFontOfSize:12]} range:NSMakeRange(0, allString.length)];
        [mStr addAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:[UIFont boldSystemFontOfSize:12]} range:range];
        
        CGRect rect = [allString boundingRectWithSize:CGSizeMake(self.frame.size.width - 40, 9999) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];
        
        if (rect.size.height < 40) {
            rect.size.height = 40;
        }
        //为消息加图片
        UIView * bgView = [[UIView alloc] initWithFrame:CGRectMake(5, 2, self.frame.size.width - 10, rect.size.height - 5)];
        bgView.layer.borderColor = [UIColor colorWithRed:255 / 255.0 green:208 / 255.0 blue:133 / 255.0 alpha:1].CGColor;
        bgView.layer.borderWidth = 1.0;
        bgView.layer.cornerRadius = 5.0;
        bgView.backgroundColor = [UIColor colorWithRed:255 / 255.0 green:243 / 255.0 blue:223 / 255.0 alpha:1];
        
        UIImageView * image = [[UIImageView alloc] initWithFrame:CGRectMake(5, CGRectGetHeight(bgView.frame) / 2.0 - 15 / 2.0, 15, 15)];
        image.image = [UIImage imageNamed:@"broadcast"];
        
        [bgView addSubview:image];
        
        UILabel * label      = [[UILabel alloc] initWithFrame:CGRectMake(25, 0, self.frame.size.width - 40, rect.size.height - 5)];
        label.attributedText = mStr;
        label.numberOfLines  = 0;
        
        [bgView addSubview:label];
        
        [self.contentView addSubview:bgView];
       // return cell;
    }
    //禁言
    else if (chat_disable)
    {
        allString = chat_disable;
        NSString * nickname = Model.nickname;
        
        NSRange range = [allString rangeOfString:nickname];
        
        //设置字符串属性
        NSMutableAttributedString * mStr = [[NSMutableAttributedString alloc] initWithString:allString];
        [mStr addAttributes:@{NSForegroundColorAttributeName:[UIColor lightGrayColor],NSFontAttributeName:[UIFont systemFontOfSize:12]} range:NSMakeRange(0, allString.length)];
        [mStr addAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:[UIFont boldSystemFontOfSize:12]} range:range];
        
        CGRect rect = [allString boundingRectWithSize:CGSizeMake(self.frame.size.width - 40, 9999) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];
        
        if (rect.size.height < 40) {
            rect.size.height = 40;
        }
        
        //为消息加图片
        UIView * bgView           = [[UIView alloc] initWithFrame:CGRectMake(5, 2, self.frame.size.width - 10, rect.size.height - 5)];
        bgView.layer.borderColor  = [UIColor colorWithRed:255 / 255.0 green:208 / 255.0 blue:133 / 255.0 alpha:1].CGColor;
        bgView.layer.borderWidth  = 1.0;
        bgView.layer.cornerRadius = 5.0;
        bgView.backgroundColor    = [UIColor colorWithRed:255 / 255.0 green:243 / 255.0 blue:223 / 255.0 alpha:1];
        
        UIImageView * image = [[UIImageView alloc] initWithFrame:CGRectMake(5, CGRectGetHeight(bgView.frame) / 2.0 - 15 / 2.0, 15, 15)];
        image.image = [UIImage imageNamed:@"broadcast"];
        
        [bgView addSubview:image];
        
        UILabel * label      = [[UILabel alloc] initWithFrame:CGRectMake(25, 0, self.frame.size.width - 40, rect.size.height - 5)];
        label.attributedText = mStr;
        label.numberOfLines  = 0;
        
        [bgView addSubview:label];
        
        [self.contentView addSubview:bgView];
    //    return cell;
        
    }
    //踢人
    else if (member_kick)
    {
        allString = member_kick;
        NSString * nickname = Model.nickname;
        
        NSRange range = [allString rangeOfString:nickname];
        
        //设置字符串属性
        NSMutableAttributedString * mStr = [[NSMutableAttributedString alloc] initWithString:allString];
        [mStr addAttributes:@{NSForegroundColorAttributeName:[UIColor lightGrayColor],NSFontAttributeName:[UIFont systemFontOfSize:12]} range:NSMakeRange(0, allString.length)];
        [mStr addAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:[UIFont boldSystemFontOfSize:12]} range:range];
        
        CGRect rect = [allString boundingRectWithSize:CGSizeMake(self.frame.size.width - 40, 9999) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];
        
        if (rect.size.height < 40) {
            rect.size.height = 40;
        }
        //为消息加图片
        UIView * bgView           = [[UIView alloc] initWithFrame:CGRectMake(5, 2, self.frame.size.width - 10, rect.size.height - 5)];
        bgView.layer.borderColor  = [UIColor colorWithRed:255 / 255.0 green:208 / 255.0 blue:133 / 255.0 alpha:1].CGColor;
        bgView.layer.borderWidth  = 1.0;
        bgView.layer.cornerRadius = 5.0;
        bgView.backgroundColor    = [UIColor colorWithRed:255 / 255.0 green:243 / 255.0 blue:223 / 255.0 alpha:1];
        
        UIImageView * image = [[UIImageView alloc] initWithFrame:CGRectMake(5, CGRectGetHeight(bgView.frame) / 2.0 - 15 / 2.0, 15, 15)];
        image.image = [UIImage imageNamed:@"broadcast"];
        
        [bgView addSubview:image];
        
        UILabel * label      = [[UILabel alloc] initWithFrame:CGRectMake(25, 0, self.frame.size.width - 40, rect.size.height - 5)];
        label.attributedText = mStr;
        label.numberOfLines  = 0;
        
        [bgView addSubview:label];
        
        [self.contentView addSubview:bgView];
        //return cell;
    }
    else{
        NSString * nameTime = [self getUserNameAndTimeWith:[Model mj_keyValues]];
        NSString * temp = nameTime;
        
        //＝＝＝＝＝＝＝＝＝用户说的话＝＝＝＝＝＝＝
        nameTime = [NSString stringWithFormat:@"%@",temp];
        
        //＝＝＝＝＝＝＝如果是老师说的话＝＝＝＝＝＝＝＝
        if ([Model.role isEqualToString:TalkfunMemberRoleSpadmin]) {
            nameTime = [NSString stringWithFormat:@"老师%@",temp];
        }
        else if ([Model.role isEqualToString:TalkfunMemberRoleAdmin])
        {
            nameTime = [NSString stringWithFormat:@"助教%@",temp];
        }
        
        
        CGRect rect = [nameTime boundingRectWithSize:CGSizeMake(self.frame.size.width, 9999) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil];
        
        //距离顶部高度
        UIView * nameTimeView = [[UIView alloc] initWithFrame:CGRectMake(5, 5, rect.size.width + 30, 20)];
        
        //MARK:老师的发言才调用
        if ([Model.role isEqualToString:TalkfunMemberRoleSpadmin] || [Model.role isEqualToString:TalkfunMemberRoleAdmin]) {
            NSArray * strArray;
            if ([Model.role isEqualToString:TalkfunMemberRoleSpadmin]) {
                strArray = [nameTime componentsSeparatedByString:@"老师"];
            }else
            {
                strArray = [nameTime componentsSeparatedByString:@"助教"];
            }
            
            CGRect numberRect     = [strArray[0] boundingRectWithSize:CGSizeMake(self.frame.size.width, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil];
            UILabel * numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, numberRect.size.width, numberRect.size.height)];
            numberLabel.font      = [UIFont systemFontOfSize:12];
            numberLabel.textColor = [UIColor lightGrayColor];
            numberLabel.text      = strArray[0];
            [nameTimeView addSubview:numberLabel];
            
            CGRect teacherRect              = [@"老师" boundingRectWithSize:CGSizeMake(self.frame.size.width, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil];
            UILabel * teacherLabel          = [[UILabel alloc] initWithFrame:CGRectMake(numberRect.size.width + 5, 0, teacherRect.size.width, 20)];
            teacherLabel.text               = @"老师";
            teacherLabel.textAlignment      = NSTextAlignmentCenter;
            teacherLabel.textColor          = [UIColor whiteColor];
            teacherLabel.font               = [UIFont systemFontOfSize:12];
            teacherLabel.backgroundColor    = [UIColor redColor];
            teacherLabel.layer.cornerRadius = 5;
            teacherLabel.clipsToBounds      = YES;
            if ([Model.role isEqualToString:TalkfunMemberRoleAdmin]) {
                teacherLabel.text = @"助教";
                teacherLabel.backgroundColor = [UIColor orangeColor];
            }
            [nameTimeView addSubview:teacherLabel];
            
            CGRect nameRect     = [temp boundingRectWithSize:CGSizeMake(self.frame.size.width, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil];
            UILabel * nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(numberRect.size.width + teacherRect.size.width + 10, 0, nameRect.size.width, 20)];
            nameLabel.text      = temp;
            nameLabel.textColor = [UIColor lightGrayColor];
            nameLabel.font      = [UIFont systemFontOfSize:12];
            [nameTimeView addSubview:nameLabel];
            
        }
        else{
            //MARK:其他用户发言调用
            UILabel * nameTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.height)];
            nameTimeLabel.text      = nameTime;
            nameTimeLabel.textColor = [UIColor lightGrayColor];
            nameTimeLabel.font      = [UIFont systemFontOfSize:12];
            
            [nameTimeView addSubview:nameTimeLabel];
            
        }
        [self.contentView addSubview:nameTimeView];
        
        //说话内容
        NSString * msg = Model.msg;
        if (!msg) {
            
            NSInteger amount = [Model.amount integerValue];
            
            NSMutableString * message = [NSMutableString new];
            [message appendString:@"送给老师："];
            for (int i = 0; i < amount; i ++) {
                [message appendString:@"[rose]"];
            }
            
            msg = message;
        }
        UIView * returnView;
        
        if (SYSTEMVERSION > 8.0) {
            
            NSArray * arr1 = [msg componentsSeparatedByString:@"["];
            NSArray * arr2 = [msg componentsSeparatedByString:@"]"];
            if (arr1.count != 1 && arr2.count != 1) {
                returnView = [self assembleMessageAtIndex:msg flower:YES];
            }
            else
            {
                CGRect rect         = [msg boundingRectWithSize:CGSizeMake(self.frame.size.width - 20, 9999) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];

                UILabel * label     = [[UILabel alloc] initWithFrame:CGRectMake(20, 25, rect.size.width, rect.size.height)];
                label.text          = msg;
                label.font          = [UIFont systemFontOfSize:13];
                label.numberOfLines = 0;
                
                returnView = label;
                
            }
        }
        else
        {
            BOOL flag = NO;
            for (int i = 0; i < msg.length; i ++) {
                char c = [msg characterAtIndex:i];
                if (c == '[') {
                    flag = YES;
                }
                if (c == ']' && flag == YES) {
                    returnView = [self assembleMessageAtIndex:msg flower:YES];
                }
            }
            if (!returnView) {
                
                CGRect rect         = [msg boundingRectWithSize:CGSizeMake(self.frame.size.width - 20, 9999) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];

                UILabel * label     = [[UILabel alloc] initWithFrame:CGRectMake(20, 25, rect.size.width, rect.size.height)];
                label.text          = msg;
                label.font          = [UIFont systemFontOfSize:13];
                label.numberOfLines = 0;
                returnView = label;
                
            }
        }
        
        [self.contentView addSubview:returnView];

        
    }


}

//====================== 图文混排 =====================
- (void)getImageRange:(NSString*)message :(NSMutableArray*)array {
    NSRange range = [message rangeOfString:BEGIN_FLAG];
    NSRange range1 = [message rangeOfString:END_FLAG];
    //判断当前字符串是否还有表情的标志。
    if (range.length > 0 && range1.length > 0) {
        if (range.location > 0) {
            [array addObject:[message substringToIndex:range.location]];
            [array addObject:[message substringWithRange:NSMakeRange(range.location, range1.location+1-range.location)]];
            NSString * str = [message substringFromIndex:range1.location+1];
            [self getImageRange:str :array];
        }else {
            NSString * nextstr = [message substringWithRange:NSMakeRange(range.location, range1.location+1-range.location)];
            //排除文字是“”的
            if (![nextstr isEqualToString:@""]) {
                [array addObject:nextstr];
                NSString * str = [message substringFromIndex:range1.location + 1];
                [self getImageRange:str :array];
            }else {
                return;
            }
        }
        
    }
    else if (message != nil) {
        [array addObject:message];
    }
}


- (UIView *)assembleMessageAtIndex:(NSString *)message flower:(BOOL)isFlower
{
    NSMutableArray * array = [[NSMutableArray alloc] init];
    [self getImageRange:message :array];
    UIView * returnView = [[UIView alloc] initWithFrame:CGRectZero];
    NSArray * data      = array;
    UIFont * fon        = [UIFont systemFontOfSize:13.0f];
    CGFloat upX         = 0;
    CGFloat upY         = 0;
    CGFloat X           = 0;
    CGFloat Y           = 0;
    if (data) {
        for (int i = 0;i < [data count]; i++) {
            NSString * str = [data objectAtIndex:i];
            if ([str hasPrefix:BEGIN_FLAG] && [str hasSuffix:END_FLAG])
            {
                if (upX >= MAX_WIDTH)
                {
                    upY = upY + KFacialSizeHeight;
                    upX = 0;
                    X   = 150;
                    Y   = upY;
                }
                
                NSString * imageName = [str substringWithRange:NSMakeRange(1, str.length - 2)];
                UIImageView * img = [[UIImageView alloc]initWithImage:[UIImage imageNamed:imageName]];
                img.frame = CGRectMake(upX, upY, KFacialSizeWidth, KFacialSizeHeight);
                [returnView addSubview:img];
                upX=KFacialSizeWidth+upX;
                if (X < 150) X = upX;
                
                
            } else {
                for (int j = 0; j < [str length]; j++) {
                    NSString * temp = [str substringWithRange:NSMakeRange(j, 1)];
                    if (upX >= MAX_WIDTH)
                    {
                        upY = upY + KFacialSizeHeight;
                        upX = 0;
                        X   = 150;
                        Y   = upY;
                    }
                    CGRect rect = [temp boundingRectWithSize:CGSizeMake(150, 40) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];
                    //                    CGSize size = [temp sizeWithFont:fon constrainedToSize:CGSizeMake(150, 40)];
                    UILabel * la = [[UILabel alloc] initWithFrame:CGRectMake(upX,upY,rect.size.width,rect.size.height)];
                    la.font = fon;
                    la.text = temp;
                    if (isFlower) {
                        la.textColor = [UIColor lightGrayColor];
                    }
                    else
                    {
                        la.textColor = [UIColor blackColor];
                    }
                    la.textAlignment   = NSTextAlignmentCenter;
                    la.backgroundColor = [UIColor clearColor];
                    [returnView addSubview:la];
                    upX                = upX + rect.size.width;
                    if (X < 150) {
                        X = upX;
                    }
                }
            }
        }
    }
    
    returnView.frame = CGRectMake(20.0f,28.0f, X, Y); //@ 需要将该view的尺寸记下，方便以后使用
    
    return returnView;
}




//=============== 获取时间和用户名 ======================
//=============== 获取时间和用户名 ======================
- (NSString *)getUserNameAndTimeWith:(NSDictionary *)params
{
    NSString * userName = params[@"nickname"];
    NSString * time     = params[@"time"];
    if (params[@"amount"]) {
        return [NSString stringWithFormat:@"%@:(%@)",userName,time];
    }
    NSTimeInterval timeInterval    = [time doubleValue];
    NSDate *detaildate             = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"HH:mm"];

    NSString * currentDateStr      = [dateFormatter stringFromDate: detaildate];
    
    return [NSString stringWithFormat:@"%@:(%@)",userName,currentDateStr];
}


- (void)tableViewBtnClicked:(UIButton *)btn
{
    NSString * vid = [NSString stringWithFormat:@"%ld",(long)btn.tag];
    if ([btn.titleLabel.text isEqualToString:@"投票"]) {
        self.btnBlock(NO,vid);
    }
    else if ([btn.titleLabel.text isEqualToString:@"查看结果"])
    {
        self.btnBlock(YES,vid);
    }
}
//
@end
