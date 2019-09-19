//
//  TalkfunNewQuestionCell.m
//  TalkfunSDKDemo
//
//  Created by Sunzn on 2017/2/5.
//  Copyright © 2017年 talk-fun. All rights reserved.
//

#import "TalkfunNewQuestionCell.h"
#import "QuestionModel.h"
#import "MJExtension.h"
#import "TalkfunReplyCell.h"
#import "UIImageView+WebCache.h"
@implementation TalkfunNewQuestionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.roleLabel.clipsToBounds = YES;
    self.replyTableView.delegate = self;
    self.replyTableView.dataSource = self;
    self.replyTableView.scrollEnabled = NO;
    _isPlayback = NO;
    self.backgroundColor = [UIColor clearColor];
    self.replyTableView.backgroundColor = [UIColor clearColor];
    self.nameTimeLabel.textColor = LIGHTBLUECOLOR;
     self.avatarImageView.clipsToBounds = YES;
}

- (void)configCell:(NSDictionary *)dict isPlayback:(BOOL)isPlayback{
    QuestionModel * model = [QuestionModel mj_objectWithKeyValues:dict];
   
    if ([model.role isEqualToString:TalkfunMemberRoleSpadmin]) {
        self.teacherXXX.constant = -24;
        self.xxxxx.constant = 0;
        self.roleLabel.text = @"老师";
        self.roleLabelWidth.constant = 27;
        self.roleLabel.layer.cornerRadius = 3;
        self.roleLabel.backgroundColor = [UIColor redColor];
       
    }
    //=============== 如果是助教说的话 =================
    else if ([model.role isEqualToString:TalkfunMemberRoleAdmin])
    { self.teacherXXX.constant = -24;
        self.xxxxx.constant = 0;
        self.roleLabel.text = @"助教";
        self.roleLabelWidth.constant = 27;
        self.roleLabel.layer.cornerRadius = 3;
        self.roleLabel.backgroundColor = [UIColor orangeColor];
       
    }else{
        self.roleLabelWidth.constant = 0;
    }
    
    self.avatarImageView.layer.cornerRadius = 10;
    
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:[UIImage imageNamed:@"占位图"] options:0];
//    NSString * nameTime =
    self.nameTimeLabel.attributedText =  [TalkfunUtils getUserNameAndTimeWith:dict playback:isPlayback];;
//    [NSString stringWithFormat:@"%ld%@",self.number,nameTime]
    NSDictionary * contentDict = [TalkfunUtils assembleAttributeString:model.content boundingSize:CGSizeMake(CGRectGetWidth(self.frame)-48, MAXFLOAT) fontSize:13 shadow:NO];
    NSAttributedString * attr = contentDict[AttributeStr];
    NSMutableAttributedString * contentAttrStr = [[NSMutableAttributedString alloc] initWithAttributedString:attr];
    UIColor * contentColor = [UIColor whiteColor];
    [contentAttrStr addAttribute:NSForegroundColorAttributeName value:contentColor range:NSMakeRange(0, attr.length)];
    [contentAttrStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:13] range:NSMakeRange(0, attr.length)];
    self.content.attributedText = contentAttrStr;
    
    if (model.answer) {
        NSArray * answerArray = model.answer;
        [self.dataSource removeAllObjects];
        [self.dataSource addObjectsFromArray:answerArray];
        [self.replyTableView reloadData];
        self.replyTableViewHeight.constant = self.replyTableView.contentSize.height;
    }else{
        self.replyTableViewHeight.constant = 0;
    }
    
    if (isPlayback) {
        _isPlayback = YES;
        self.backgroundColor =[UIColor clearColor];
        if ([self.selectedArray[self.number] integerValue] == 1) {
            self.backgroundColor = NEWBLUECOLOR;
//            self.backgroundColor = [UIColor colorWithRed:200 / 255.0 green:200 / 255.0 blue:200 / 255.0 alpha:1];
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TalkfunReplyCell * cell = [tableView dequeueReusableCellWithIdentifier:@"liveReplyCell"];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"TalkfunReplyCell" owner:nil options:nil][0];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    [cell configCell:self.dataSource[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary * dict = self.dataSource[indexPath.row];
    if ([dict isKindOfClass:[NSDictionary class]]) {
        NSDictionary * info = [TalkfunUtils assembleAttributeString:dict[@"content"] boundingSize:CGSizeMake(CGRectGetWidth(self.frame)-48, MAXFLOAT) fontSize:13 shadow:NO];
        NSString * rectStr = info[TextRect];
        CGRect rect = CGRectFromString(rectStr);
        CGFloat height = rect.size.height+15+16;
        return height;
    }
    else{
        return 0;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray new];
    }
    return _dataSource;
}

@end
