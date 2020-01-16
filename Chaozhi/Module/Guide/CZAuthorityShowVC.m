//
//  CZAuthorityShowVC.m
//  Chaozhi
//
//  Created by zhanbing han on 2020/1/10.
//  Copyright © 2020 Jason_hzb. All rights reserved.
//

#import "CZAuthorityShowVC.h"
#import "UILabel+RichText.h"

@interface CZAuthorityShowVC ()

@end

@implementation CZAuthorityShowVC

// 不支持转屏
- (BOOL)shouldAutorotate {
    return NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _appNameLab.text = AppName;
    NSString *nameStr = @"超职";
    if ([AppChannel isEqualToString:@"2"]) { //学智
        nameStr = @"学智";
    }
    NSString *str1 = [NSString stringWithFormat:@"《%@用户服务协议》",nameStr];
    NSString *str2 = [NSString stringWithFormat:@"《%@用户隐私政策》",nameStr];
    _showProtocolLab.text = [NSString stringWithFormat:@"您可以在系统设置中关闭以上权限，请在使用前查看并同意完整的%@和%@。",str1,str2];
    
    NSRange range1 = [_showProtocolLab.text rangeOfString:@"《"];
    range1 = NSMakeRange(range1.location, str1.length);
    NSRange range2 = NSMakeRange(range1.location+str1.length+1, str2.length);;
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:_showProtocolLab.text];
    [attributeString addAttribute:NSForegroundColorAttributeName value:RGBValue(0xE23C46) range:range1];
    [attributeString addAttribute:NSForegroundColorAttributeName value:RGBValue(0xE23C46) range:range2];
    
    //调整行距
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 3;
    paragraphStyle.baseWritingDirection = NSWritingDirectionLeftToRight;
    [attributeString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, _showProtocolLab.text.length)];
    _showProtocolLab.attributedText = attributeString;
    _showProtocolLab.font = [UIFont systemFontOfSize:autoScaleW(13)];
    
    [_showProtocolLab clickRichTextWithStrings:@[str1,str2] clickAction:^(NSString * _Nonnull string, NSRange range, NSInteger index) {
        if ([string isEqualToString:str1]) {
            NSString *url = [h5Url() stringByAppendingString:H5_UserProtocal];
            if ([AppChannel isEqualToString:@"2"]) { //学智
                url = H5_UserProtocal;
            }
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
        }
        else if ([string isEqualToString:str2]) {
            NSString *url = [h5Url() stringByAppendingString:H5_Privacy];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
        }
    }];
}

- (IBAction)startVCClickAction:(UIButton *)sender {
    if (_doneBlock) {
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"AgreeAuthority"];;
        self.doneBlock();
    }
}

@end
