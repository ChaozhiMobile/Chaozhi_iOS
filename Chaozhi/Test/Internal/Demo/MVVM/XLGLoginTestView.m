//
//  XLGLoginTestView.m
//  Chaozhi
//  Notes：
//
//  Created by MEyo on 2018/5/14.
//  Copyright © 2018年 小灵狗出行. All rights reserved.
//

#import "XLGLoginTestView.h"

@implementation XLGLoginTestView

- (void)me_setupViews {
    
    UILabel *usernameLabel = [UILabel new];
    usernameLabel.text = @"账号：";
    [self addSubview:usernameLabel];
    [usernameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(30);
        make.top.equalTo(self).offset(94);
        make.width.mas_equalTo(@57);
    }];
    
    
    _usernameTextField = ({
        UITextField *textField = [[UITextField alloc] init];
//        textField.text = @"15381930612";
        textField.placeholder = @"请输入身份证号或手机号";
        textField.clearButtonMode = UITextFieldViewModeAlways;
        [self addSubview:textField];
        
        [textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(usernameLabel);
            make.left.equalTo(usernameLabel.mas_right).offset(5);
            make.right.equalTo(self).offset(-30);
            make.height.mas_equalTo(@48);
        }];
        
        textField;
    });
    
    UIView *sepLine = [UIView new];
    sepLine.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:sepLine];
    [sepLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(25);
        make.right.equalTo(self).offset(-25);
        make.top.equalTo(self.usernameTextField.mas_bottom);
        make.height.mas_equalTo(@1);
    }];
    
    UILabel *passwordLabel = [UILabel new];
    passwordLabel.text = @"密码：";
    [self addSubview:passwordLabel];
    [passwordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(usernameLabel);
        make.top.equalTo(usernameLabel.mas_bottom).offset(30);
    }];
    
    _passwordTextField = ({
        UITextField *textField = [[UITextField alloc] init];
        textField.placeholder = @"请输入密码";
//        textField.text = @"123456";
        textField.secureTextEntry = YES;
        textField.clearButtonMode = UITextFieldViewModeAlways;
        [self addSubview:textField];
        
        [textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(passwordLabel);
            make.left.equalTo(passwordLabel.mas_right).offset(5);
            make.right.equalTo(self).offset(-30);
            make.height.mas_equalTo(@48);
        }];
        
        textField;
    });
    
    UIView *sepLine2 = [UIView new];
    sepLine2.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:sepLine2];
    [sepLine2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(25);
        make.right.equalTo(self).offset(-25);
        make.top.equalTo(self.passwordTextField.mas_bottom);
        make.height.mas_equalTo(@1);
    }];
    
    _loginButton = ({
        UIButton *button = [UIButton new];
        [button setTitle:@"登  陆" forState:UIControlStateNormal];
        [button setBackgroundColor:AppThemeColor];
        [button setBackgroundImage:[UIImage imageWithColor:AppThemeColor] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageWithColor:[UIColor lightGrayColor]] forState:UIControlStateDisabled];
        button.layer.cornerRadius = 5;
        [self addSubview:button];
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(25);
            make.right.equalTo(self).offset(-25);
            make.top.equalTo(sepLine2.mas_bottom).offset(15);
            make.height.equalTo(@45);
        }];
        
        button;
    });
    
    _registerButton = ({
        UIButton *button = [UIButton new];
        [button setTitle:@"立即注册" forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [self addSubview:button];
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.loginButton);
            make.top.equalTo(self.loginButton.mas_bottom).offset(12);
        }];
        
        button;
    });
    
    _forgetPasswordButton = ({
        UIButton *button = [UIButton new];
        [button setTitle:@"忘记密码" forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [self addSubview:button];
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.loginButton);
            make.top.equalTo(self.loginButton.mas_bottom).offset(12);
        }];
        
        button;
    });
    
}

@end
