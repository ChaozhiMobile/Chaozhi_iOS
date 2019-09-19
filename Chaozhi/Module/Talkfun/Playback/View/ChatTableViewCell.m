//
//  ChatTableViewCell.m
//  Talkfun_demo
//
//  Created by moruiquan on 16/1/25.
//  Copyright © 2016年 talk-fun. All rights reserved.
//

#import "ChatTableViewCell.h"
#import "PlaybackChatModel.h"
#import "MJExtension.h"

#define BEGIN_FLAG @"["
#define END_FLAG @"]"
#define KFacialSizeHeight 18
#define KFacialSizeWidth  18
#define MAX_WIDTH [UIScreen mainScreen].bounds.size.width - 40


@interface ChatTableViewCell()

@property (nonatomic,copy) NSString *TalkfunRoomTitle;
@property (nonatomic,copy) NSString *TalkfunPlayback;
@property (nonatomic,copy) NSString *TalkfunStreamAll;
@property (nonatomic,copy) NSString *TalkfunStreamVideo;
@property (nonatomic,copy) NSString *TalkfunStreamAudio;
@property (nonatomic,copy) NSString *TalkfunMemberRoleSpadmin;
@property (nonatomic,copy) NSString *TalkfunMemberRoleAdmin;
@property (nonatomic,copy) NSString *TalkfunMemberRoleUser;
@property (nonatomic,copy) NSString *TalkfunMemberRoleGuest;



@end


@implementation ChatTableViewCell




- (void)awakeFromNib {
    // Initialization code
    
    [super awakeFromNib];
}

- (void)setModel:(PlaybackChatModel *)Model
{  _Model =Model;
    
    self.TalkfunRoomTitle         = @"TalkfunRoomTitle";
    self.TalkfunPlayback          = @"TalkfunPlayback";

    self.TalkfunStreamAll         = @"TalkfunStreamAll";
    self.TalkfunStreamVideo       = @"TalkfunStreamVideo";
    self.TalkfunStreamAudio       = @"TalkfunStreamAudio";

    self.TalkfunMemberRoleSpadmin = @"spadmin";
    self.TalkfunMemberRoleAdmin   = @"admin";
    self.TalkfunMemberRoleUser    = @"user";
    self.TalkfunMemberRoleGuest   = @"guest";
    
    
    
    NSString * nameTime = [self getUserNameAndTimeWith:[Model mj_keyValues]];
    NSString * temp = nameTime;
    
    //=============== 用户说的话 ===================
    nameTime = [NSString stringWithFormat:@"%@",temp];
    
    //=============== 如果是老师说的话 =================
    if ([Model.role isEqualToString:_TalkfunMemberRoleSpadmin]) {
        nameTime = [NSString stringWithFormat:@"老师%@",temp];
    }
    //=============== 如果是助教说的话 =================
    else if ([Model.role isEqualToString:_TalkfunMemberRoleAdmin])
    {
        nameTime = [NSString stringWithFormat:@"助教%@",temp];
    }
    
    
//    CGRect rect = [nameTime boundingRectWithSize:CGSizeMake(self.frame.size.width, 9999) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil];
    
    //距离顶部高度
    UIView * nameTimeView = [[UIView alloc] initWithFrame:CGRectMake(5, 2, self.frame.size.width, 20)];
    
    //MARK:老师的发言才调用
    if ([Model.role isEqualToString:_TalkfunMemberRoleSpadmin] || [Model.role isEqualToString:_TalkfunMemberRoleAdmin]) {
        NSArray * strArray;
        if ([Model.role isEqualToString:_TalkfunMemberRoleSpadmin]) {
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
        if ([Model.role isEqualToString:_TalkfunMemberRoleAdmin]) {
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
        UILabel * nameTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 20)];
        nameTimeLabel.text      = nameTime;
        nameTimeLabel.textColor = [UIColor lightGrayColor];
        nameTimeLabel.font      = [UIFont systemFontOfSize:12];
        
        [nameTimeView addSubview:nameTimeLabel];
        
    }
    [self.contentView addSubview:nameTimeView];
    
    //MARK:说话内容
    NSString * msg = Model.message;
    UIView * returnView;
    
    NSString * msgString = msg;
    for (NSString * name in self.expressionDict) {
        
        msgString = [msgString stringByReplacingOccurrencesOfString:name withString:self.expressionDict[name]];
        
    }
    if (msgString == msg) {
        CGRect rect         = [msgString boundingRectWithSize:CGSizeMake(self.frame.size.width - 20, 99999) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];
        UILabel * label     = [[UILabel alloc] initWithFrame:CGRectMake(20, 22, rect.size.width, rect.size.height)];
        label.text          = msgString;
        label.numberOfLines = 0;
        label.font          = [UIFont systemFontOfSize:13];
        returnView          = label;
    }else
    {
        msg = msgString;
        returnView = [self assembleMessageAtIndex:msg];
    }
    //加到cell上面
    [self.contentView addSubview:returnView];
    
    //cell的颜色
    self.backgroundColor =[UIColor clearColor];
    
    if ([self.selectedArray[self.number] integerValue] == 1) {
        self.backgroundColor = [UIColor colorWithRed:200 / 255.0 green:200 / 255.0 blue:200 / 255.0 alpha:1];
    }

}


- (NSString *)getUserNameAndTimeWith:(NSDictionary *)params
{
    NSString * userName  = params[@"nickname"];
    NSString * starttime = params[@"starttime"];
    NSInteger time       = [starttime integerValue];
    NSInteger hour       = time / 3600;
    NSInteger minutes    = (time - hour * 3600) / 60;
    NSInteger second     = time - minutes * 60 - hour * 3600;
    
    return [NSString stringWithFormat:@"%@:(%02ld:%02ld:%02ld)",userName,(long)hour,(long)minutes,(long)second];
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

- (UIView *)assembleMessageAtIndex:(NSString *)message
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
                UIImageView * img    = [[UIImageView alloc]initWithImage:[UIImage imageNamed:imageName]];
                img.frame            = CGRectMake(upX, upY, KFacialSizeWidth, KFacialSizeHeight);
                [returnView addSubview:img];
                upX                  = KFacialSizeWidth+upX;
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
                    CGRect rect        = [temp boundingRectWithSize:CGSizeMake(150, 40) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];
                    //                    CGSize size = [temp sizeWithFont:fon constrainedToSize:CGSizeMake(150, 40)];
                    UILabel * la       = [[UILabel alloc] initWithFrame:CGRectMake(upX,upY,rect.size.width,rect.size.height)];
                    la.font            = fon;
                    la.text            = temp;
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
    
    returnView.frame = CGRectMake(20.0f,25.0f, X, Y); //@ 需要将该view的尺寸记下，方便以后使用
    
    return returnView;
}


@end
