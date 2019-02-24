//
//  XLGLoginTestViewModel.m
//  Chaozhi
//  Notes：
//
//  Created by MEyo on 2018/5/14.
//  Copyright © 2018年 小灵狗出行. All rights reserved.
//

#import "XLGLoginTestViewModel.h"

@interface XLGLoginTestViewModel ()
    
@property (nonatomic, strong, readwrite) RACSignal *validLoginSignal;

@end

@implementation XLGLoginTestViewModel

- (instancetype)init {
    
    if (self = [super init]) {
        
        self.username = @"";
        self.password = @"";
        
        _successObject = [RACSubject subject];
        _failureObject = [RACSubject subject];
        _errorObject = [RACSubject subject];
    }
    
    return self;
}
    
- (id)buttonIsValid {
    
    RACSignal *phoneSignal = [RACObserve(self, username) filter:^BOOL(NSString *phone) {
        NSLog(@"%@ - %@", self.username, phone)
        return phone;
    }];
    
    RACSignal *passwordSignal =[RACObserve(self, password) filter:^BOOL(NSString *password) {
        NSLog(@"%@ & %@", self.password, password)
        return password;
    }];
    
    RACSignal *isValid = [RACSignal combineLatest:@[phoneSignal, passwordSignal]
                                           reduce:^(NSString *isPhoneCorrect, NSString *isPasswordCorrect) {
                                               NSLog(@"%@ + %@", isPhoneCorrect, isPasswordCorrect)
                                               return @(isPhoneCorrect.length == 11 && isPasswordCorrect.length > 0);
                                           }];
    return isValid;
}
    
- (void)login {
    
    [_successObject sendNext:nil];
}
@end
