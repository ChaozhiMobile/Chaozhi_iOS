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
    if ([AppChannel isEqualToString:@"2"]) { //超职
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
    paragraphStyle.lineSpacing = 5;
    paragraphStyle.baseWritingDirection = NSWritingDirectionLeftToRight;
    [attributeString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, _showProtocolLab.text.length)];
    _showProtocolLab.attributedText = attributeString;
    
    [_showProtocolLab clickRichTextWithStrings:@[str1,str2] clickAction:^(NSString * _Nonnull string, NSRange range, NSInteger index) {
        if ([string isEqualToString:str1]) {
            NSString *url = [h5Url() stringByAppendingString:H5_UserProtocal];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
//            [BaseWebVC showWithContro:self withUrlStr:H5_UserProtocal withTitle:@"用户服务协议" isPresent:YES];
        }
        else if ([string isEqualToString:str2]) {
            NSString *url = [h5Url() stringByAppendingString:H5_Privacy];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
//            [BaseWebVC showWithContro:self withUrlStr:H5_Privacy withTitle:@"用户隐私政策" isPresent:YES];
        }
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)startVCClickAction:(UIButton *)sender {
    if (_doneBlock) {
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"agreeAuthority"];;
        self.doneBlock();
    }
}
@end
