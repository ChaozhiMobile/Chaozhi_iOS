//
//  QuestionCell.m
//  Talkfun_demo
//
//  Created by moruiquan on 16/1/26.
//  Copyright © 2016年 talk-fun. All rights reserved.
//

#import "QuestionCell.h"
#import "QuestionModel.h"
#import "MJExtension.h"
//#import "TalkfunSDK.h"
#define BEGIN_FLAG @"["
#define END_FLAG @"]"
#define KFacialSizeWidth  18
#define KFacialSizeHeight 18
#define MAX_WIDTH [UIScreen mainScreen].bounds.size.width - 40
@interface QuestionCell ()

@end
@implementation QuestionCell



- (void)setModel:(QuestionModel *)Model
{
    _Model = Model;

    
    NSString * nameTime = [self getUserNameAndTimeWith:[Model mj_keyValues]];
    NSString * temp     = nameTime;
    
    
    int sum = 0;
    for (int i = 0; i < self.number; i ++) {
        NSNumber * num = self.heightArray[i];
        if ([num isEqualToNumber:@(0.0)]) {
            sum ++;
        }
    }
    //＝＝＝＝＝＝＝＝＝用户说的话＝＝＝＝＝＝＝
    nameTime = [NSString stringWithFormat:@"%ld)%@",(long)self.number + 1 - sum,temp];
    
    //＝＝＝＝＝＝＝如果是老师说的话＝＝＝＝＝＝＝＝
    if ([Model.role isEqualToString:TalkfunMemberRoleSpadmin]) {
        nameTime = [NSString stringWithFormat:@"%ld)老师%@",(long)self.number + 1 - sum,temp];
    }
    else if ([Model.role isEqualToString:TalkfunMemberRoleAdmin])
    {
        nameTime = [NSString stringWithFormat:@"%ld)助教%@",(long)self.number + 1 - sum,temp];
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
    NSString * content = Model.content;
    UIView * returnView;
    
    if (SYSTEMVERSION > 8.0) {
        
        NSArray * arr1 = [content componentsSeparatedByString:@"["];
        NSArray * arr2 = [content componentsSeparatedByString:@"]"];
        if (arr1.count != 1 && arr2.count != 1) {
            returnView = [self assembleMessageAtIndex:content];
        }
        else
        {
            CGRect rect         = [content boundingRectWithSize:CGSizeMake(self.frame.size.width - 20, 9999) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];

            UILabel * label     = [[UILabel alloc] initWithFrame:CGRectMake(20, 25, rect.size.width, rect.size.height)];
            label.text          = content;
            label.font          = [UIFont systemFontOfSize:13];
            label.numberOfLines = 0;
            returnView          = label;
            
        }
    }
    else
    {
        BOOL flag = NO;
        for (int i = 0; i < content.length; i ++) {
            char c = [content characterAtIndex:i];
            if (c == '[') {
                flag = YES;
            }
            if (c == ']' && flag == YES) {
                returnView = [self assembleMessageAtIndex:content];
            }
        }
        if (!returnView) {
            
            CGRect rect         = [content boundingRectWithSize:CGSizeMake(self.frame.size.width - 20, 9999) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];

            UILabel * label     = [[UILabel alloc] initWithFrame:CGRectMake(20, 25, rect.size.width, rect.size.height)];
            label.text          = content;
            label.font          = [UIFont systemFontOfSize:13];
            label.numberOfLines = 0;
            returnView          = label;
            
        }
    }
    
    [self.contentView addSubview:returnView];
    
    //＝＝＝＝＝＝如果有answer（老师才有）＝＝＝＝＝＝＝＝
    if (Model.answer) {
        NSArray * answerArray = Model.answer;
        for (int i = 0; i < answerArray.count; i ++) {
            
            //同样要拿出高度才能计算相应回复在cell中的位置
            NSArray * arr = self.answerHeightDict[@(self.number)];
            CGFloat answerHeight = 0.0;
            for (int j = 0; j < i; j ++) {
                answerHeight += [arr[j] floatValue];
            }
            
            NSDictionary * dict = answerArray[i];
            NSString * answerNameTime = [self getUserNameAndTimeWith:dict];
            
            NSString * role = nil;
            UIColor * roleColor = nil;
            if ([dict[@"role"] isEqualToString:TalkfunMemberRoleAdmin]) {
                role = @"助教";
                roleColor = [UIColor orangeColor];
            }
            else if ([dict[@"role"] isEqualToString:TalkfunMemberRoleSpadmin])
            {
                role = @"老师";
                roleColor = [UIColor redColor];
            }
            NSString * newString = [NSString stringWithFormat:@"   老师%@",answerNameTime];
            
            CGRect rect                 = [newString boundingRectWithSize:CGSizeMake(self.frame.size.width, 9999) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil];
            CGFloat height              = [self.heightArray[self.number] floatValue];
            UIView * answerNameTimeView = [[UIView alloc] initWithFrame:CGRectMake(5, height + answerHeight , rect.size.width + 30, 20)];
            
            CGRect numberRect     = [@"   " boundingRectWithSize:CGSizeMake(self.frame.size.width, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil];
            UILabel * numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, numberRect.size.width, numberRect.size.height)];
            numberLabel.font      = [UIFont systemFontOfSize:12];
            numberLabel.textColor = [UIColor lightGrayColor];
            numberLabel.text      = @"   ";
            [answerNameTimeView addSubview:numberLabel];
            
            CGRect teacherRect              = [@"老师" boundingRectWithSize:CGSizeMake(self.frame.size.width, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil];
            UILabel * teacherLabel          = [[UILabel alloc] initWithFrame:CGRectMake(numberRect.size.width + 5, 0, teacherRect.size.width, 20)];
            teacherLabel.text               = role;
            teacherLabel.textAlignment      = NSTextAlignmentCenter;
            teacherLabel.textColor          = [UIColor whiteColor];
            teacherLabel.font               = [UIFont systemFontOfSize:12];
            teacherLabel.backgroundColor    = roleColor;
            teacherLabel.layer.cornerRadius = 5;
            teacherLabel.clipsToBounds      = YES;
            [answerNameTimeView addSubview:teacherLabel];
            
            CGRect nameRect     = [answerNameTime boundingRectWithSize:CGSizeMake(self.frame.size.width, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil];
            UILabel * nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(numberRect.size.width + teacherRect.size.width + 10, 0, nameRect.size.width, 20)];
            nameLabel.text      = answerNameTime;
            nameLabel.textColor = [UIColor lightGrayColor];
            nameLabel.font      = [UIFont systemFontOfSize:12];
            [answerNameTimeView addSubview:nameLabel];
            
            [self.contentView addSubview:answerNameTimeView];
            
            NSString * content = dict[@"content"];
            UIView * returnView;
            
            CGRect frame = [content boundingRectWithSize:CGSizeMake(self.frame.size.width - 20, 9999) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];
            
            UILabel * label     = [[UILabel alloc] initWithFrame:CGRectMake(20, 27, frame.size.width, frame.size.height)];
            label.text          = content;
            label.font          = [UIFont systemFontOfSize:13];
            label.numberOfLines = 0;
            returnView          = label;
            
            
            CGRect frame2    = returnView.frame;
            frame2.origin.y  = CGRectGetMaxY(answerNameTimeView.frame) + 5;
            returnView.frame = frame2;
            [self.contentView addSubview:returnView];
        }
    }
    else
    {
        NSString * xid = nil;
        if ([Model.xid isKindOfClass:[NSNumber class]]) {
            
            NSString *name = [NSString stringWithFormat:@"%@",Model.xid ];
            
            xid = name;
        }
        else
            xid = Model.xid;
        
        if (![self.xid isEqualToString:xid] && (![Model.role  isEqualToString:TalkfunMemberRoleAdmin] && ![Model.role isEqualToString:TalkfunMemberRoleSpadmin])) {
            [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        }
    }
    
}
//=============== 获取时间和用户名 ======================
- (NSString *)getUserNameAndTimeWith:(NSDictionary *)params
{
    NSString * userName            = params[@"nickname"];
    NSString * time                = params[@"time"];

    NSTimeInterval timeInterval    = [time doubleValue];
    NSDate *detaildate             = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"HH:mm"];

    NSString * currentDateStr      = [dateFormatter stringFromDate: detaildate];
    
    return [NSString stringWithFormat:@"%@:(%@)",userName,currentDateStr];
}
//====================== 图文混排 =====================
- (void)getImageRange:(NSString*)message :(NSMutableArray*)array {
    NSRange range = [message rangeOfString:BEGIN_FLAG];
    NSRange range1 = [message rangeOfString:END_FLAG];
    //判断当前字符串是否还有表情的标志。
    if (range.length>0 && range1.length>0) {
        if (range.location > 0) {
            [array addObject:[message substringToIndex:range.location]];
            [array addObject:[message substringWithRange:NSMakeRange(range.location, range1.location+1-range.location)]];
            NSString *str=[message substringFromIndex:range1.location+1];
            [self getImageRange:str :array];
        }else {
            NSString *nextstr=[message substringWithRange:NSMakeRange(range.location, range1.location+1-range.location)];
            //排除文字是“”的
            if (![nextstr isEqualToString:@""]) {
                [array addObject:nextstr];
                NSString *str=[message substringFromIndex:range1.location+1];
                [self getImageRange:str :array];
            }else {
                return;
            }
        }
        
    } else if (message != nil) {
        [array addObject:message];
    }
}

- (UIView *)assembleMessageAtIndex:(NSString *)message
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
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
            NSString *str = [data objectAtIndex:i];
            //NSLog(@"str--->%@",str);
            if ([str hasPrefix: BEGIN_FLAG] && [str hasSuffix: END_FLAG])
            {
                if (upX >= MAX_WIDTH)
                {
                    upY = upY + KFacialSizeHeight;
                    upX = 0;
                    X   = 150;
                    Y   = upY;
                }
                //NSLog(@"str(image)---->%@",str);
                NSString * imageName=[str substringWithRange:NSMakeRange(1, str.length - 2)];
                UIImageView *img=[[UIImageView alloc]initWithImage:[UIImage imageNamed:imageName]];
                img.frame = CGRectMake(upX, upY, KFacialSizeWidth, KFacialSizeHeight);
                [returnView addSubview:img];
                upX       = KFacialSizeWidth+upX;
                if (X < 150) X = upX;
                
                
            } else {
                for (int j = 0; j < [str length]; j++) {
                    NSString *temp = [str substringWithRange:NSMakeRange(j, 1)];
                    if (upX >= MAX_WIDTH)
                    {
                        upY = upY + KFacialSizeHeight;
                        upX = 0;
                        X   = 150;
                        Y   = upY;
                    }
                    CGRect rect = [temp boundingRectWithSize:CGSizeMake(150, 40) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];
                    //                    CGSize size = [temp sizeWithFont:fon constrainedToSize:CGSizeMake(150, 40)];
                    UILabel *la        = [[UILabel alloc] initWithFrame:CGRectMake(upX,upY,rect.size.width,rect.size.height)];
                    la.font            = fon;
                    la.text            = temp;
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
    
    returnView.frame = CGRectMake(20.0f,23.0f, X, Y); //@ 需要将该view的尺寸记下，方便以后使用
    //NSLog(@"%.1f %.1f", X, Y);
    return returnView;
}

@end
