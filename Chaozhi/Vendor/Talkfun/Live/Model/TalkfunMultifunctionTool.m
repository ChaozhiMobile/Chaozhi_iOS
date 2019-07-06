

#import "TalkfunMultifunctionTool.h"
#import <AVFoundation/AVFoundation.h>
#import "TalkfunMultifunctionButton.h"

@interface TalkfunMultifunctionTool()
@property(nonatomic,strong)NSMutableArray*buttonArray;
@property(nonatomic,strong)NSTimer                    *timer;//定时器2 秒后隐藏
@property(nonatomic,strong)NSTimer                    *timer2;//定时器2 秒后隐藏
@property(nonatomic,strong)TalkfunMultifunctionButton *  immediateButton;
@end
@implementation TalkfunMultifunctionTool


- (NSMutableArray*)buttonArray
{
    if (_buttonArray==nil) {
        _buttonArray = [NSMutableArray array];
    }
    return _buttonArray;
    
}
+ (UIColor *)colorWithHexString: (NSString *)color alpha:(CGFloat)alpha
{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    // 判断前缀
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    // 从六位数值中找到RGB对应的位数并转换
    NSRange range;
    range.location = 0;
    range.length = 2;
    //R、G、B
    NSString *rString = [cString substringWithRange:range];
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:alpha];
}

+(NSString*)getLiveDuration:(id)obj
{
    NSString *hour = @"";
    NSString *minute = @"";
    NSString *second = @"";
    
    if(obj[@"hour"]&&obj[@"minute"]&&obj[@"second"]) {
        //前面加0
        if ( [obj[@"hour"] integerValue]<10) {
            hour =  [@"0" stringByAppendingString:obj[@"hour"]];
        }else{
            hour = obj[@"hour"];
        }
        //前面加0
        if ( [obj[@"minute"] integerValue]<10) {
            minute =  [@"0" stringByAppendingString:obj[@"minute"]];
        }else{
            minute = obj[@"minute"];
        }
        //前面加0
        if ( [obj[@"second"] integerValue]<10) {
            second =  [@"0" stringByAppendingString:obj[@"second"]];
        }else{
            second = obj[@"second"];
        }
    }
    NSString * dateContent = [[NSString alloc] initWithFormat:@"%@:%@:%@", hour, minute, second];
    
    return dateContent;
}


- (void)presentViewController:(UIViewController*)ViewController  content:(NSString*)content  actionWithTitle:(NSString*)title
{
    if (SYSTEM_VERSION >= 8.0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:@"提示" message:content preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                
                if (_clickEventBlock) {
                    _clickEventBlock(@"取消");
                }
                
            }];
            
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                
                if (_clickEventBlock) {
                    _clickEventBlock(title);
                }
                
            }];
            [alertCtrl addAction:cancel];
            [alertCtrl addAction:okAction];
            
            [ViewController presentViewController:alertCtrl animated:YES completion:nil];
            
        });
        
        
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:content delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:title,nil];
            alert.delegate = self;
            
            [alert show];
            
        });
    }
    
}

#pragma mark -- alertView代理
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *btnTitle = [alertView buttonTitleAtIndex:buttonIndex];
    
    if (_clickEventBlock) {
        _clickEventBlock(btnTitle);
    }
    
}


//简单提示
- (void)presentViewController:(UIViewController*)ViewController content:(NSString*)content
{
    if (SYSTEM_VERSION >= 8.0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:@"温馨提示" message:content preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                
                if (_clickEventBlock) {
                    _clickEventBlock(@"确定");
                }
                
                
            }];
            [alertCtrl addAction:okAction];
            [ViewController presentViewController:alertCtrl animated:YES completion:nil];
            
        });
        
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:content delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] ;
            [alert show];
            
        });
    }
}



#pragma mark    申请摄像头权限
+(void)applyCamera:(void (^)(BOOL granted))callback
{
    // 用户同意获取数据
    NSString *mediaType = AVMediaTypeVideo;//
    [AVCaptureDevice requestAccessForMediaType:mediaType completionHandler:^(BOOL granted) {
        
        if(granted){//点击允许访问时调用
            
            [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
                
                if (granted) {
                    
                    callback (YES);
                }
                else {
                    // 可以显示一个提示框告诉用户这个app没有得到允许？
                    dispatch_async(dispatch_get_main_queue(), ^{
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"请启用麦克风-设置/隐私/麦克风" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] ;
                        [alert show];
                    });
                }
            }];
            
        }
        
        else {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"请启用相机-设置/隐私/相机" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] ;
                [alert show];
            });
            
        }
        
    }];
    
}
- (void)immediate:(UIView*)view toast:(NSString *)string position:(CGPoint)position
{
    if (self.timer2) {
        [self.timer2 invalidate];
        self.timer2 = nil;
        [self.immediateButton removeFromSuperview];
        self.immediateButton = nil;
    }
    
    self.immediateButton = [TalkfunMultifunctionButton buttonWithType:UIButtonTypeCustom];
    self.immediateButton.backgroundColor = UIColorFromRGBHex(0x444444);
    [self.immediateButton setTitleColor:UIColorFromRGBHex(0xffffff) forState:UIControlStateNormal];
    self.immediateButton.layer.cornerRadius = 4;
    self.immediateButton.titleLabel.font = [UIFont systemFontOfSize:15];
    self.immediateButton.alpha = 1;
    
    if (string && [string isKindOfClass:[NSString class]] && ![string containsString:@"{"]) {
        NSArray * arr = [string componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@".?;'[]{}+_)(*&^%$#@!~`| \\。？：“？）（+——*&……%￥#@！~·"]];
        string = [arr componentsJoinedByString:@""];
    }
    
    [self.immediateButton setTitle:string forState:UIControlStateNormal];
    CGRect rect = [TalkfunMultifunctionTool getRectWithString:string size:CGSizeMake(view.frame.size.width, 40) fontSize:15];
    self.immediateButton.frame = CGRectMake(0, 0, rect.size.width + 20, 38);
    
    CGPoint point = CGPointMake(position.x, position.y +(self.immediateButton.frame.size.height/2));
    
    self.immediateButton.center = point;
    
    
    //先添加
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (view) {
            [view addSubview:self.immediateButton];
        }
        
        
    });
    
    self.timer2 = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(immediateButtonClick) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer2  forMode:NSRunLoopCommonModes];
}
- (void)immediateButtonClick
{
    [self.immediateButton removeFromSuperview];
}
- (void)addto:(UIView*)view toast:(NSString *)string position:(CGPoint)position
{
    
    TalkfunMultifunctionButton *  button = [TalkfunMultifunctionButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = UIColorFromRGBHex(0x444444);
    [button setTitleColor:UIColorFromRGBHex(0xffffff) forState:UIControlStateNormal];
    button.layer.cornerRadius = 4;
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    button.alpha = 1;
    
    if (string && [string isKindOfClass:[NSString class]] && ![string containsString:@"{"]) {
        NSArray * arr = [string componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@".?;'[]{}+_)(*&^%$#@!~`| \\。？：“？）（+——*&……%￥#@！~·"]];
        string = [arr componentsJoinedByString:@""];
    }
    
    [button setTitle:string forState:UIControlStateNormal];
    CGRect rect = [TalkfunMultifunctionTool getRectWithString:string size:CGSizeMake(view.frame.size.width, 40) fontSize:15];
    button.frame = CGRectMake(0, 0, rect.size.width + 20, 38);
    
    CGPoint point = CGPointMake(position.x, position.y +(button.frame.size.height/2));
    
    button.center = point;
    
    
    //先添加
    dispatch_async(dispatch_get_main_queue(), ^{
        button.hidden = YES;
        if (view) {
            [view addSubview:button];
        }
        
        
    });
    
    [self.buttonArray addObject:button];
    
    if(self.timer){
        return;
        
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        button.hidden = NO;
        if (view) {
            [view addSubview:button];
        }
        
    });
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(hiddenControl) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer  forMode:NSRunLoopCommonModes];
    
}


////停止定时器
- (void)stopTime{
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    
    if (self.timer2) {
        [self.timer2 invalidate];
        self.timer2 = nil;
    }
}


- (void)hiddenControl
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.buttonArray.count>0) {
            TalkfunMultifunctionButton *  button = self.buttonArray[0];
            
            button.hidden = NO;
            [button removeFromSuperview];
            //两秒后删除自己
            [self.buttonArray removeObjectAtIndex:0];
            //停止定时器
            if (self.timer) {
                [self.timer invalidate];
                self.timer = nil;
            }
            
            if (self.buttonArray.count>0) {
                
                TalkfunMultifunctionButton *  vc = self.buttonArray[0];
                vc.hidden = NO;
                
                self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(hiddenControl) userInfo:nil repeats:YES];
                [[NSRunLoop mainRunLoop] addTimer:self.timer  forMode:NSRunLoopCommonModes];
                
            }
            
        }
        
    });
    
}

+ (CGRect)getRectWithString:(NSString *)string size:(CGSize)size fontSize:(CGFloat)fontSize
{
    if ([string isKindOfClass:[NSString class]]) {
        NSStringDrawingOptions opts = NSStringDrawingUsesLineFragmentOrigin |
        NSStringDrawingUsesFontLeading;
        
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
        [style setLineBreakMode:NSLineBreakByWordWrapping];
        
        NSDictionary *attributes = @{ NSFontAttributeName : [UIFont systemFontOfSize:fontSize], NSParagraphStyleAttributeName : style };
        
        CGRect frame = [string boundingRectWithSize:size options:opts attributes:attributes context:nil];
        CGRect rect = CGRectMake(frame.origin.x, frame.origin.y, ceil(frame.size.width), ceil(frame.size.height));
        return rect;
    }
    else
    {
        return CGRectZero;
    }
}
+ (UIView *)networkUnusualView:(NSString*)content  frame:(CGRect)Frame
{
    
    UIView * networkView = [[UIView alloc] initWithFrame:Frame];
    networkView.tag = 777;
    networkView.backgroundColor = UIColorFromRGBHex(0xfff1da);
    
    NSString *  text = content;
    
    NSDictionary *attrs = @{NSFontAttributeName : [UIFont boldSystemFontOfSize:15 ] };
    
    CGSize attrsSize=[text sizeWithAttributes:attrs];
    
    UILabel * label = [[UILabel alloc] init];
    
    label.font = [UIFont systemFontOfSize:15];
    
    label.frame = CGRectMake((Frame.size.width -attrsSize.width)/2, (Frame.size.height -attrsSize.height)/2, attrsSize.width, attrsSize.height); // 修改尺寸
    label.textColor = UIColorFromRGBHex(0x666666);
    label.text = text;
    [networkView addSubview:label];
    
    UIImageView * imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_pop up_warning"]];
    imageView.frame = CGRectMake(label.frame.origin.x -22 -22, (Frame.size.height - 22) / 2, 22, 22);
    [networkView addSubview:imageView];
    
    return networkView;
}
+ (NSInteger)getChatEnable:(id)obj
{
    if ([obj[@"chat"] isKindOfClass:[NSDictionary class]]) {
        
        if (obj[@"chat"][@"enable"] ) {
            //已经禁言
            if ([obj[@"chat"][@"enable"] integerValue ]==0) {
                //聊天开启
            }else if ([obj[@"chat"][@"enable"] integerValue ]==1) {
                
                return [obj[@"chat"][@"enable"] integerValue ];
                
            }
        }
        
        
    }
    
    return 0;
}
+ (NSString*)dictionaryToJson:(NSDictionary *)dict
{
    if ([dict isKindOfClass:[NSDictionary class]]) {
        NSError *parseError = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&parseError];
        
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }else{
        return @"";
    }
    
}

@end
