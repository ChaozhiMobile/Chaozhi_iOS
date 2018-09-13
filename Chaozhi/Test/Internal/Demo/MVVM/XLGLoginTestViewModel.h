//
//  XLGLoginTestViewModel.h
//  Chaozhi
//  Notes：
//
//  Created by MEyo on 2018/5/14.
//  Copyright © 2018年 小灵狗出行. All rights reserved.
//

#import "MEViewModel.h"

@interface XLGLoginTestViewModel : MEViewModel

@property (nonatomic, strong) RACSubject *successObject;
@property (nonatomic, strong) RACSubject *failureObject;
@property (nonatomic, strong) RACSubject *errorObject;
    
- (id)buttonIsValid;
- (void)login;
    
// property
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *password;

// signal
@property (nonatomic, strong) RACSignal *connectionErrors;
    
@end
