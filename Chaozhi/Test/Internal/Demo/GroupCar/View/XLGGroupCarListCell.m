//
//  XLGGroupCarListCell.m
//  Chaozhi
//  Notes：
//
//  Created by MEyo on 2018/6/11.
//  Copyright © 2018年 小灵狗出行. All rights reserved.
//

#import "XLGGroupCarListCell.h"

@interface XLGGroupCarListCell ()

@property (nonatomic, strong) UIImageView *carTypeImageView; // 油/电标志
@property (nonatomic, strong) UIImageView *carImageView;

@property (nonatomic, strong) UILabel *carTypeLabel;   //车辆型号
@property (nonatomic, strong) UILabel *licenseLabel;   //车牌

@property (nonatomic, strong) UIButton *stateButton;   //车辆状态/使用

@end

@implementation XLGGroupCarListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self setupView];
    }
    return self;
}

- (void)setupView {
    
    _carImageView = ({
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:imageView];
        
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(12);
            make.centerY.equalTo(self.contentView);
            make.size.mas_equalTo(CGSizeMake(100, 80));
        }];
        
        imageView;
    });
    
    _carTypeImageView = ({
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:imageView];
        
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.top.mas_equalTo(self.carImageView);
            make.size.mas_equalTo(CGSizeMake(15, 15));
        }];
        
        imageView;
    });
    
    _carTypeLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.textColor = [UIColor colorWithHexString:@"0x05C247"];
        label.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:label];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(30);
            make.left.equalTo(self.carImageView.mas_right).offset(9);
        }];
        
        label;
    });
    
    _licenseLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = [UIColor colorWithHexString:@"0x565454"];
        [self.contentView addSubview:label];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.carTypeLabel);
            make.top.equalTo(self.carTypeLabel.mas_bottom).offset(9);
        }];
        
        label;
    });
    
    _stateButton = ({
        UIButton *button = [UIButton new];
        button.layer.cornerRadius = 5;
        button.titleLabel.textColor = [UIColor whiteColor];
        button.titleLabel.font = [UIFont systemFontOfSize:13];
        
        [self.contentView addSubview:button];
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.contentView).offset(-12);
            make.centerY.equalTo(self.contentView);
            make.size.mas_equalTo(CGSizeMake(100, 34));
        }];
        
        button;
    });
}

- (void)setModel:(id)model {
    
    self.carImageView.image = [UIImage imageNamed:@"icon_chexing"];
    self.carTypeImageView.image = [UIImage imageNamed:@"icon_electric"];
    
    self.carTypeLabel.text = @"北汽EC180";
    self.licenseLabel.text = @"浙B192LS";
    
    
    NSString *text = (NSString *)model;
    
    if ([text isEqualToString:@"1" ]) {
        self.stateButton.backgroundColor = [UIColor colorWithHexString:@"0x05C247"];
        
        NSMutableAttributedString *attributedString = [self customLabelText:@"我要用车"];
        
        [self.stateButton setAttributedTitle:attributedString forState:UIControlStateNormal];
    }
    else {
        self.stateButton.backgroundColor = [UIColor colorWithHexString:@"0xFDAD00"];
        
        NSMutableAttributedString *attributedString = [self customLabelText:@"使用中"];
        
        [self.stateButton setAttributedTitle:attributedString forState:UIControlStateNormal];
    }
}

- (NSMutableAttributedString *)customLabelText:(NSString *)text {
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text attributes:@{NSKernAttributeName:@(3)}];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [text length])];
    
    return attributedString;
}

@end
