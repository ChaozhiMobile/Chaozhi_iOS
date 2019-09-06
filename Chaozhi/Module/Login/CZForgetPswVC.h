//
//  CZForgetPswVC.h
//  Chaozhi
//
//  Created by Jason_zyl on 2018/9/17.
//  Copyright © 2018年 Jason_zyl. All rights reserved.
//

#import "BaseVC.h"

@interface CZForgetPswVC : BaseVC

@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *codeTF;
@property (weak, nonatomic) IBOutlet UIButton *codeBtn;
@property (weak, nonatomic) IBOutlet UITextField *pswNewTF;
@property (weak, nonatomic) IBOutlet UIButton *changePswBtn;

@end
