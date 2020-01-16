//
//  CZAuthorityShowVC.h
//  Chaozhi
//
//  Created by zhanbing han on 2020/1/10.
//  Copyright © 2020 Jason_hzb. All rights reserved.
//

#import "BaseVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface CZAuthorityShowVC : UIViewController

@property (nonatomic, copy) dispatch_block_t doneBlock;

@property (weak, nonatomic) IBOutlet UILabel *appNameLab;
@property (weak, nonatomic) IBOutlet UILabel *showProtocolLab;

- (IBAction)startVCClickAction:(UIButton *)sender;

@end

NS_ASSUME_NONNULL_END
