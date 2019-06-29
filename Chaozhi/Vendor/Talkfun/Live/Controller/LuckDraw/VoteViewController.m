//
//  VoteViewController.m
//  Talkfun_demo
//
//  Created by talk－fun on 16/1/16.
//  Copyright © 2016年 talk-fun. All rights reserved.
//

#import "VoteViewController.h"
#import "UIImageView+WebCache.h"
#import "UIImageView+Exten.h"
#import "ckickUILabel.h"
#define noDisableHorizontalScrollTag 836914

#define DisableHorizontalScrollTag 836913
@interface VoteViewController ()<UIScrollViewDelegate,UIGestureRecognizerDelegate>


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *prompHigh;
@property (weak, nonatomic ) IBOutlet UILabel            *successLabel;
@property (weak, nonatomic ) IBOutlet UIImageView        *tick;
@property (weak, nonatomic ) IBOutlet NSLayoutConstraint *topSpaceConstraint;
//@property (weak, nonatomic ) IBOutlet NSLayoutConstraint *scrollViewToBottomConstraint;

@property (weak, nonatomic ) IBOutlet UIButton           *voteBtn;
@property ( nonatomic )  UIScrollView       *scrollView;
@property (weak, nonatomic ) IBOutlet UILabel            *nickName;
@property (weak, nonatomic ) IBOutlet UILabel            *voteTitle;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *voteTitleHeightConstraint;

@property (weak, nonatomic ) IBOutlet UIImageView        *voteImage;
@property (weak, nonatomic ) IBOutlet UILabel            *vote;
@property (nonatomic,assign) int                btnCount;
@property (nonatomic,copy  ) NSString           * imageName;
@property (nonatomic,copy  ) NSString           * selectImageName;
@property (nonatomic,assign) int                optional;
@property (nonatomic,strong) UIAlertView        * alertView;


//问题的唯一标识vid
@property (nonatomic,copy) NSString * vid;

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property ( nonatomic)  UIView * pictureContainer ;


//是否存在 照片
@property(nonatomic,assign)BOOL photosExist;

@property ( nonatomic)UIImageView *imageView;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *promptWidth;


@property(strong,nonatomic)UIImageView *enlargeImaegView;

@property(nonatomic,strong) SDWebImageManager *manager;

@property(nonatomic,strong)NSString *imageUrl;

@property(nonatomic,strong)NSDictionary*params;

//投票类型与结果
@property (nonatomic,strong)NSString *voteType;


@property(nonatomic,strong)NSMutableArray *scrollViewArray;

@property(nonatomic,strong)NSMutableDictionary *vidDict;//保存自己投票的唯一标识符与答案
@end


@implementation VoteViewController

- (NSMutableDictionary*) vidDict
{
    if (_vidDict==nil) {
        _vidDict = [NSMutableDictionary dictionary];
    }
    return _vidDict;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.params = [[NSDictionary alloc]init];
    self.scrollViewArray = [[NSMutableArray alloc]init];
    self.alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
}

- (SDWebImageManager *)manager
{  if(_manager ==nil)
{
    _manager = [SDWebImageManager sharedManager];
}
    return _manager;
    
}
- (void)setPictureContainerFrame
{
    
    //    self.imageView.frame = CGRectMake(0, 0, self.pictureContainer.frame.size.width, self.pictureContainer.frame.size.height);
    //    self.imageView.backgroundColor = [UIColor whiteColor];;
    //    self.imageView.contentMode =  UIViewContentModeScaleAspectFit;
    
    // 发送请求   弱引用
    __weak typeof(self) weakSelf = self;
    //
    //下载图片
    [self.manager loadImageWithURL:[NSURL URLWithString:self.imageUrl] options:32 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        
    } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
        
        
        
        //原图 小于imageView
        if (image.size.height<weakSelf.pictureContainer.frame.size.height&&image.size.width<weakSelf.pictureContainer.frame.size.width ) {
            weakSelf.imageView.contentMode = UIViewContentModeScaleAspectFill;
            
            CGFloat imageX = (weakSelf.pictureContainer.frame.size.width -image.size.width)/2;
            CGFloat imageY = (weakSelf.pictureContainer.frame.size.height -image.size.height)/2;
            
            weakSelf.imageView.frame = CGRectMake(imageX, imageY, image.size.width,image.size.height);
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.imageView.image = image;
            });
            
            
        }else{
            
            //以高小于宽   橫图片
            if (image.size.height<image.size.width) {
                weakSelf.imageView.contentMode = UIViewContentModeScaleAspectFit;
                
                CGFloat imageViweW =  weakSelf.pictureContainer.frame.size.width;
                
                CGSize temp = CGSizeMake(imageViweW, image.size.height  *(imageViweW/image.size.width) );
                
                if(temp.height<= weakSelf.pictureContainer.frame.size.height){
                    
                    CGFloat imageX = (weakSelf.pictureContainer.frame.size.width -imageViweW)/2;
                    
                    weakSelf.imageView.frame = CGRectMake(imageX, 0, imageViweW, temp.height);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        weakSelf.imageView.image = image;
                    });
                    
                }else{
                    weakSelf.imageView.contentMode = UIViewContentModeScaleAspectFit;
                    CGFloat imageH = weakSelf.pictureContainer.frame.size.height;
                    
                    CGSize temp =CGSizeMake(image.size.width  *(imageH/image.size.height), imageH);
                    
                    CGFloat imageX = (weakSelf.pictureContainer.frame.size.width -temp.width)/2;
                    weakSelf.imageView.frame = CGRectMake(imageX, 0, temp.width, imageH);
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        weakSelf.imageView.image = image;
                    });
                }
                
                // 高大于宽   竖图片
            }else{
                
                weakSelf.imageView.contentMode = UIViewContentModeScaleAspectFit;
                CGFloat imageH = weakSelf.pictureContainer.frame.size.height;
                
                CGSize temp =CGSizeMake(image.size.width  *(imageH/image.size.height), imageH);
                
                
                if (temp.width<= weakSelf.pictureContainer.frame.size.width) {
                    
                    CGFloat imageX = (weakSelf.pictureContainer.frame.size.width -temp.width)/2;
                    
                    weakSelf.imageView.frame = CGRectMake(imageX, 0, temp.width, imageH);
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        weakSelf.imageView.image = image;
                    });
                    
                }else{
                    weakSelf.imageView.contentMode = UIViewContentModeScaleAspectFit;
                    CGFloat imageW =  weakSelf.pictureContainer.frame.size.width;
                    CGSize temp = CGSizeMake(imageW, image.size.height  *(imageW/image.size.width) );
                    CGFloat imageX = (weakSelf.pictureContainer.frame.size.width -imageW)/2;
                    weakSelf.imageView.frame = CGRectMake(imageX, 0, imageW, temp.height);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        weakSelf.imageView.image = image;
                    });
                }
                
            }
        }
        
        
        
    }];
    
    
    //下载图片
    //        [self.manager downloadImageWithURL:[NSURL URLWithString:self.imageUrl]  options:32 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
    //        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
    //
    //
    //            dispatch_async(dispatch_get_main_queue(), ^{
    //                                        self.imageView.image = image;
    //                                    });
    //
    //        }];
    
    
}


- (void)DisableHorizontalScroll:(BOOL)hide{
    
    if(hide)
    {
        //垂直方向的滚动条
        self.scrollView.tag = noDisableHorizontalScrollTag;
        
    }else{
        
        self.scrollView.tag = DisableHorizontalScrollTag;
    }
    [self.scrollView flashScrollIndicators];
}


//删除最后一个字符
-(NSString*) removeLastOneChar:(NSString*)origin
{
    NSString* cutted;
    if([origin length] > 0){
        cutted = [origin substringToIndex:([origin length]-1)];// 去掉最后一个","
    }else{
        cutted = origin;
    }
    return cutted;
}


//- (NSMutableAttributedString*)fontAttributeNameStr:(NSString*)str
//{
//    //        NSString *text = @"正确的答案是:,你是15号";
//    // 1.创建NSMutableAttributedString实例
//    NSMutableAttributedString *fontAttributeNameStr = [[NSMutableAttributedString alloc]initWithString:str];
//
//    // 2.添加属性
//    [fontAttributeNameStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:8] range:NSMakeRange(0, 8)];
//
//    [fontAttributeNameStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Courier-BoldOblique" size:15] range:NSMakeRange(8, str.length - 8)];
//
//    [fontAttributeNameStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(8, str.length - 8)];
//
//    return fontAttributeNameStr;
//}


#pragma mark  控件ui
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    
    //公告投票结果
    if ([self.voteType isEqualToString:@"refreshUIWithResult"]) {
        
        [self initView];
        self.vid = self.params[@"vid"];
        self.imageUrl =  self.params[@"info"][@"imageUrl"];
        
        self.vote.text                             = @"投票结果";
        self.scrollView.alpha                      = 1.0;
        self.nickName.alpha                        = 1.0;
        self.voteTitle.alpha                       = 1.0;
        self.voteBtn.alpha                         = 0.0;
        self.tick.alpha                            = 0.0;
        self.successLabel.alpha                    = 0.0;
        
        NSString * type = @"单选";
        if (self.optional != 1) {
            type = @"多选";
        }
        if (self.imageUrl.length){
            self.voteTitle.text = [NSString stringWithFormat:@"【%@】%@",type,self.params[@"info"][@"label"]];
        }else{
            self.voteTitle.text = [NSString stringWithFormat:@"【%@】%@",type,self.params[@"info"][@"title"]];
        }
        
        NSString * nickName = [NSString stringWithFormat:@"%@ %@ 结束了投票",self.params[@"info"][@"nickname"],self.params[@"info"][@"endTime"]];
        CGRect rect         = [nickName boundingRectWithSize:CGSizeMake(self.scrollView.frame.size.width, 44) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11]} context:nil];
        CGRect frame        = self.nickName.frame;
        frame.size.height   = rect.size.height;
        self.nickName.frame = frame;
        
        NSRange range = [nickName rangeOfString:self.params[@"info"][@"nickname"]];
        
        NSMutableAttributedString * aStr = [[NSMutableAttributedString alloc] initWithString:nickName];
        [aStr addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11],NSForegroundColorAttributeName:[UIColor darkGrayColor]} range:range];
        [aStr addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10],NSForegroundColorAttributeName:[UIColor lightGrayColor]} range:NSMakeRange(range.length, nickName.length - range.length)];
        
        self.nickName.attributedText = aStr;
        
        NSArray * arr = self.params[@"statsList"];
        int sumHeight = 0;
        for (int i = 0; i < arr.count; i ++) {
            NSDictionary * dict = arr[i];
            NSString * content  = [NSString stringWithFormat:@"%c、%@",i + 'A',dict[@"op"]];
            CGRect rect         = [content boundingRectWithSize:CGSizeMake(self.scrollView.frame.size.width - 10, 99999) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil];
            ckickUILabel * label     = [[ckickUILabel alloc] initWithFrame:CGRectMake(5, sumHeight, rect.size.width, rect.size.height + 30)];
            label.font          = [UIFont systemFontOfSize:13];
            label.numberOfLines = 0;
            label.text          = [NSString stringWithFormat:@"%c、%@",i + 'A',dict[@"op"]];
            label.userInteractionEnabled = YES;
            [self.scrollViewArray addObject:label];
            [self.scrollView addSubview:label];
            
            
            
            UIImageView * grayImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(label.frame) - 8, self.scrollView.frame.size.width - 75, 5)];
            grayImageView.image         = [UIImage imageNamed:@"grayProgress"];
            [self.scrollViewArray addObject:grayImageView];
            [self.scrollView addSubview:grayImageView];
            
            UIImageView * blueImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(label.frame) - 8, [dict[@"percent"] floatValue] / 100.0 * (self.scrollView.frame.size.width - 75), 5)];
            blueImageView.image         = [UIImage imageNamed:@"blueProgress"];
            blueImageView.contentMode   = UIViewContentModeScaleAspectFill;
            blueImageView.clipsToBounds = YES;
            [self.scrollViewArray addObject:blueImageView];
            [self.scrollView addSubview:blueImageView];
            
            ckickUILabel * resultLabel = [[ckickUILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(grayImageView.frame) + 10, CGRectGetMaxY(label.frame) - 28, 50, 40)];
            resultLabel.font      = [UIFont systemFontOfSize:12];
            resultLabel.text      = [NSString stringWithFormat:@"%@(%@%%)",dict[@"opNum"],dict[@"percent"]];
            resultLabel.userInteractionEnabled = YES;
            [self.scrollViewArray addObject:resultLabel];
            [self.scrollView addSubview:resultLabel];
            
            
            
            sumHeight                   += rect.size.height + 30;
            self.scrollView.contentSize = CGSizeMake(0, sumHeight);
            if (i == (arr.count-1)) {
                if(resultLabel.frame.origin.y+resultLabel.frame.size.height-20>self.scrollView.frame.size.height)
                    [self DisableHorizontalScroll:YES];
            }else{
                [self DisableHorizontalScroll:NO];
            }
     
        }

           int optional =      [self.params[@"optional"] intValue];
        
          NSString  *  answer = self.params[@"info"][@"answer"];
        
          NSString *correctAnswer = @"";
         if(answer.length>0){
             //多项
             if (optional != 1) {
                 
                 
                 NSArray *b = [answer componentsSeparatedByString:@","];
                 
                 for (NSString *nub in b) {
                     
                     correctAnswer = [correctAnswer stringByAppendingString:[NSString stringWithFormat:@"%c 、", [nub intValue] + 'A']]  ;
                     correctAnswer= [self removeLastOneChar:correctAnswer];
                     
                 }
                 correctAnswer = [@"正确答案是: " stringByAppendingString:correctAnswer]  ;
                 //              NSLog(@"正确答案是:%@",abc);

             }else{
                 //单项
                 correctAnswer =    [NSString stringWithFormat:@"正确答案是: %c ", [answer intValue] + 'A'];
                 
                 //                NSLog(@"单项正确答案是: %@",abc);
             }

         }else if(answer.length==0){
             correctAnswer =    [NSString stringWithFormat:@"正确答案是: "];
         }
        
        NSMutableArray *optionsArray0 = self.vidDict[self.params[@"info"][@"vid"]?self.params[@"info"][@"vid"]:@"nill"];
        
        NSString *wrongAnswer
 = @"";
        
        if (optionsArray0.count> 0) {
            if (optionsArray0.count> 1) {
                
                for (NSString *g in optionsArray0) {
                    
                    wrongAnswer = [wrongAnswer stringByAppendingString:[NSString stringWithFormat:@"%c 、", [g intValue] + 'A']]  ;
                    wrongAnswer= [self removeLastOneChar:wrongAnswer];
                    
                    
                }
                wrongAnswer = [@"你的答案是: " stringByAppendingString:wrongAnswer];
                //             NSLog(@"选择的答案是: %@",ggg);
            }else{
                if(optionsArray0[0]){
                    //单项
                    wrongAnswer =    [NSString stringWithFormat:@"你的答案是: %c ",[optionsArray0[0] intValue]  + 'A'];
                    //                NSLog(@"选择的答案是: %@",ggg);
                }
                
            }

        }else {
              wrongAnswer =    [NSString stringWithFormat:@"你的答案是: "];
        }
        

        

        
        //正确的答案是
        ckickUILabel * No     = [[ckickUILabel alloc] initWithFrame:CGRectMake(0, 0, self.voteBtn.frame.size.width , self.voteBtn.frame.size.height/2)];

         No.backgroundColor =  self.scrollView.backgroundColor;
         No.text = wrongAnswer;
         No.font          = [UIFont systemFontOfSize:8];

        [self.voteBtn addSubview:No];
        [self.scrollViewArray addObject:No];
        No.textAlignment = NSTextAlignmentLeft;
        
        
        
        
        //选择的答案是
        ckickUILabel * OK     = [[ckickUILabel alloc] initWithFrame:CGRectMake(0, self.voteBtn.frame.size.height/2, self.voteBtn.frame.size.width , self.voteBtn.frame.size.height/2)];
        OK.font          = [UIFont systemFontOfSize:8];
        OK.backgroundColor =  self.scrollView.backgroundColor;
        OK.text          = correctAnswer;
        OK.textColor =[UIColor redColor];
        OK.textAlignment = NSTextAlignmentLeft;
        [self.voteBtn addSubview:OK];
        [self.scrollViewArray addObject:OK];
        self.voteBtn.alpha = 1;
        
        
        //投票开始
    }
    
    else if ([self.voteType isEqualToString:@"refreshUIWithParams"]){
        NSLog(@"dispatch_async = %@", [NSThread currentThread]);
        [self initView];
        
        self.voteBtn.alpha                         = 1.0;
        self.vote.text                             = @"投票中...";
        self.topSpaceConstraint.constant           = self.view.frame.size.height / 2.0 - 150;
        self.scrollView.alpha                      = 1.0;
        self.nickName.alpha                        = 1.0;
        self.voteTitle.alpha                       = 1.0;
        self.tick.alpha                            = 0.0;
        self.successLabel.alpha                    = 0.0;
        
        
        NSString * nickName = [NSString stringWithFormat:@"%@ %@ 发起了投票",self.params[@"info"][@"nickname"],self.params[@"info"][@"startTime"]];
        CGRect rect         = [nickName boundingRectWithSize:CGSizeMake(self.scrollView.frame.size.width, 44) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11]} context:nil];
        CGRect frame        = self.nickName.frame;
        frame.size.height   = rect.size.height;
        self.nickName.frame = frame;
        
        NSRange range = [nickName rangeOfString:self.params[@"info"][@"nickname"]];
        
        NSMutableAttributedString * aStr = [[NSMutableAttributedString alloc] initWithString:nickName];
        [aStr addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11],NSForegroundColorAttributeName:[UIColor darkGrayColor]} range:range];
        [aStr addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10],NSForegroundColorAttributeName:[UIColor lightGrayColor]} range:NSMakeRange(range.length, nickName.length - range.length)];
        
        self.nickName.attributedText = aStr;
        NSArray * arr                = self.params[@"opList"];
        self.btnCount                = (int)arr.count;
        
        NSString * type        = @"单选";
        self.imageName         = @"circleUnselect";
        self.selectImageName   = @"circleSelect";
        self.optional          = [self.params[@"optional"] intValue];
        self.alertView.message = [NSString stringWithFormat:@"最多只能选 %d 项",self.optional];
        if (self.optional != 1) {
            type                 = @"多选";
            self.imageName       = @"rectUnselect";
            self.selectImageName = @"rectSelect";
        }
        if (self.imageUrl.length){
            self.voteTitle.text = [NSString stringWithFormat:@"【%@】%@",type,self.params[@"info"][@"label"]];
        }else{
            self.voteTitle.text = [NSString stringWithFormat:@"【%@】%@",type,self.params[@"info"][@"title"]];
        }
        int sumHeight = 0;
        for (int i = 0; i < arr.count; i ++) {
            
            NSString * content  = [NSString stringWithFormat:@"%c、%@",i + 'A',arr[i]];
            CGRect rect         = [content boundingRectWithSize:CGSizeMake(self.scrollView.frame.size.width - 45, 99999) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil];
            ckickUILabel * label     = [[ckickUILabel alloc] initWithFrame:CGRectMake(40, sumHeight, rect.size.width, rect.size.height + 20)];
            label.font          = [UIFont systemFontOfSize:13];
            label.numberOfLines = 0;
            label.text          = [NSString stringWithFormat:@"%c、%@",i + 'A',arr[i]];
            label.userInteractionEnabled = YES;
            
            label.tag        = 0-(100 + i);
            
            [self.scrollViewArray addObject:label];
            [self.scrollView addSubview:label];
            
            WeakSelf
            label.myBlock = ^(NSInteger tag){
                
                //                NSLog(@"点击的tag%i",tag);
                
                UIButton * button = (UIButton *)[weakSelf.scrollView viewWithTag:labs(tag)];
                
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf voteVCBtnClicked:button];
                });
                
            };
            
            
            
            
            UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 20, 20)];
            imageView.image         = [UIImage imageNamed:self.imageName];
            
            UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame      = CGRectMake(0, CGRectGetHeight(label.frame) / 2.0 - 20 + sumHeight, 40, 40);
            btn.tag        = 100 + i;
            [btn addTarget:self action:@selector(voteVCBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [btn addSubview:imageView];
            [self.scrollViewArray addObject:btn];
            [self.scrollView addSubview:btn];
            
            sumHeight += rect.size.height + 20;
            self.scrollView.contentSize = CGSizeMake(0, sumHeight);
            
            if (i == (arr.count-1)) {
                
                if(btn.frame.origin.y+btn.frame.size.height-20>self.scrollView.frame.size.height)
                    
                    [self DisableHorizontalScroll:YES];
                
            }else{
                [self DisableHorizontalScroll:NO];
            }
            
        }
        [self.voteBtn setBackgroundColor:[UIColor colorWithRed:212 / 255.0 green:212 / 255.0 blue:212 / 255.0 alpha:1]];
        self.voteBtn.userInteractionEnabled = NO;
        self.voteBtn.selected = NO;
        
    }
    
    
    
}
-(void)initView{
    UIInterfaceOrientation sataus=[UIApplication sharedApplication].statusBarOrientation;
    //    NSLog(@"sataus===%i",sataus);
    for (UIView* subView in self.scrollViewArray)
    {
        [subView removeFromSuperview];
    }
    
    [self.scrollView removeFromSuperview];
    [self.pictureContainer removeFromSuperview];
    self.scrollView = nil;
    self.pictureContainer = nil;
    self.enlargeImaegView = nil;
    self.imageView.image = [UIImage imageNamed:@""];
    self.imageView = nil;
    self.vid  = nil;
    self.imageUrl = nil;
    self.vid = self.params[@"vid"];
    self.imageUrl =  self.params[@"info"][@"imageUrl"];
    
    //有照片
    if (self.imageUrl.length>1){
        self.photosExist = YES;
        self.pictureContainer = [[UIView alloc]init];
        
        [self.containerView addSubview:self.pictureContainer];
        self.imageView = [[UIImageView alloc]init];
        [self.pictureContainer addSubview:self.imageView];
        
        
        self.scrollView = [[UIScrollView alloc]init];
        self.scrollView.backgroundColor = [UIColor colorWithRed:214 / 255.0 green:214 / 255.0 blue:214 / 255.0 alpha:1];
        [self.containerView addSubview:self.scrollView];
        
        self.imageView.userInteractionEnabled = YES;
        // 点按
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector( fullScreen:)];
        tap.delegate = self;
        [self.imageView addGestureRecognizer:tap];
        
        //没有照片
    }else{
        self.photosExist = NO;
        self.scrollView = [[UIScrollView alloc]init];
        self.scrollView.backgroundColor = [UIColor colorWithRed:214 / 255.0 green:214 / 255.0 blue:214 / 255.0 alpha:1];
        [self.containerView addSubview:self.scrollView];
    }
    
    if (self.photosExist) {
        //坚屏
        if (sataus==1) {
            self.pictureContainer.frame = CGRectMake(0, 0,self.promptWidth.constant-16,self.containerView.frame.size.height /2 -4);
            [self setPictureContainerFrame];
            self.scrollView.frame = CGRectMake(0, self.pictureContainer.frame.size.height +8,self.view.frame.size.width*0.75 -16,self.pictureContainer.frame.size.height);
        }
        //橫屏
        else  if (sataus==3){
            
            self.pictureContainer.frame = CGRectMake(0, 0,self.promptWidth.constant /2 - 16  ,self.containerView.frame.size.height );
            
            [self setPictureContainerFrame];
            self.scrollView.frame = CGRectMake(self.pictureContainer.frame.size.width +8,  0 ,self.pictureContainer.frame.size.width,self.pictureContainer.frame.size.height);
        }
        
    }else{
        self.scrollView.frame = CGRectMake(0, 0, self.promptWidth.constant-16, self.containerView.frame.size.height-4);
    }
    
    
    
    //垂直方向的滚动条
    self.scrollView.showsVerticalScrollIndicator = YES;
    //内容大小
    self.scrollView.contentSize = CGSizeMake( 0, (self.btnCount+1)*40);
    self.scrollView.showsHorizontalScrollIndicator = NO;
    
    
}

//MARK:投票发起
- (void)refreshUIWithParams:(NSDictionary *)params
{
    self.voteType = @"refreshUIWithParams";
    self.params = params;
    self.promptWidth.constant = [UIScreen mainScreen].bounds.size.width*0.75;
    self.prompHigh.constant = [UIScreen mainScreen].bounds.size.height *0.75;
    
    //    NSLog(@"[UIScreen mainScreen].bounds.size.width%f",[UIScreen mainScreen].bounds.size.width);
    //    NSLog(@"高%f",[UIScreen mainScreen].bounds.size.height);
}
- (void)extiClict

{
    [self.enlargeImaegView removeFromSuperview];
    
}
//点击放大图片
- (void)fullScreen:(UILongPressGestureRecognizer *)click
{
    self.enlargeImaegView.image = [UIImage imageNamed:@""];
    [self.enlargeImaegView removeFromSuperview];
    
    self.enlargeImaegView  = [[UIImageView alloc]init];
    self.enlargeImaegView .backgroundColor  = [UIColor blackColor];
    self.enlargeImaegView .frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    self.enlargeImaegView .contentMode = UIViewContentModeScaleAspectFit;
    self.enlargeImaegView .image = [self.imageView.image copy];
    self.enlargeImaegView .userInteractionEnabled = YES;
    self.enlargeImaegView.userInteractionEnabled = YES;
    // 点按
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(extiClict)];
    tap.delegate = self;
    [self.enlargeImaegView addGestureRecognizer:tap];
    [self.view addSubview:  self.enlargeImaegView ];
    
}
//MARK:投票结果
- (void)refreshUIWithResult:(NSDictionary *)params
{
    self.params = params;
    self.voteType = @"refreshUIWithResult";
    self.promptWidth.constant = [UIScreen mainScreen].bounds.size.width*0.75;
    self.prompHigh.constant = [UIScreen mainScreen].bounds.size.height *0.75;
}

//MARK:选项按钮
- (void)voteVCBtnClicked:(UIButton *)btn
{
    if (btn.selected) {
        UIImageView * imageView = (UIImageView *)btn.subviews.firstObject;
        imageView.image         = [UIImage imageNamed:self.imageName];
        btn.selected            = NO;
    }
    else
    {
        int count = 0;
        for (int i = 0; i < self.btnCount; i ++) {
            UIButton * button = (UIButton *)[self.scrollView viewWithTag:100 + i];
            if (button.selected == YES) {
                count ++;
            }
        }
        if (count == self.optional && self.optional != 1) {
            [self.alertView show];
            return;
        }
        UIImageView * imageView = (UIImageView *)btn.subviews.firstObject;
        imageView.image = [UIImage imageNamed:self.selectImageName];
        btn.selected = YES;
    }
    int count = 0;
    for (int i = 0; i < self.btnCount; i ++) {
        UIButton * button = (UIButton *)[self.scrollView viewWithTag:100 + i];
        if (button.selected == YES) {
            count ++;
        }
    }
    if (count == 0) {
        [self.voteBtn setBackgroundColor:[UIColor colorWithRed:212 / 255.0 green:212 / 255.0 blue:212 / 255.0 alpha:1]];
        self.voteBtn.userInteractionEnabled = NO;
        self.voteBtn.selected = NO;
    }
    else
    {
        [self.voteBtn setBackgroundColor:[UIColor colorWithRed:0 / 255.0 green:180 / 255.0 blue:255 / 255.0 alpha:1]];
        self.voteBtn.userInteractionEnabled = YES;
        self.voteBtn.selected = YES;
    }
    
    if (self.optional == 1) {
        for (int i = 0; i < self.btnCount; i ++) {
            UIButton * button = (UIButton *)[self.scrollView viewWithTag:100 + i];
            if (button.selected == YES && button != btn) {
                UIImageView * imageView = (UIImageView *)button.subviews.firstObject;
                imageView.image = [UIImage imageNamed:self.imageName];
                button.selected = NO;
            }
        }
    }
}

//MARK:投票按钮事件
- (IBAction)voteBtnClicked:(UIButton *)sender {
    
    if (!sender.selected) {
        return;
    }
     NSMutableArray * optionsArray0 = [NSMutableArray new];
    NSMutableArray * optionsArray = [NSMutableArray new];
    for (int i = 0; i < self.btnCount; i ++) {
        UIButton * button = (UIButton *)[self.scrollView viewWithTag:100 + i];
        if (button.selected) {
            [optionsArray addObject:@(i + 1)];
             [optionsArray0 addObject:@(i)];
        }
    }

    [self.vidDict setObject:optionsArray0 forKey:self.params[@"vid"]?self.params[@"vid"]:@"nill"];
    
  
    
    if (self.voteBlock) {
        self.voteBlock(self.vid,optionsArray);
    }
    
}

//删除键按钮事件
- (IBAction)deleteBtnClicked:(UIButton *)sender {
    
    [UIView animateWithDuration:0.5 animations:^{
        
        self.view.alpha = 0.0;
        
    } completion:^(BOOL finished) {
        
        [self.view removeFromSuperview];
        
    }];
    
}

- (void)dealloc
{
    
}
- (void)removeFromSuperview
{
    [self.view removeFromSuperview];
}
@end
