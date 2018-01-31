//
//  LoginViewModel.m
//  ReactiveCocoaDemo
//
//  Created by Jason on 2018/1/31.
//  Copyright © 2018年 陆林. All rights reserved.
//

#import "LoginViewModel.h"

@interface LoginViewModel()

@property (nonatomic, strong)RACSignal *userNameSignal;
@property (nonatomic, strong)RACSignal *passwordSignal;
@property (nonatomic, strong)NSArray *requestData;

@end

@implementation LoginViewModel

- (instancetype)init {
    self = [super init ];
    if(self){
        [self initialize];
        
    }
    return self;
}

- (void)initialize {
    _userNameSignal = RACObserve(self, userName);
    _passwordSignal = RACObserve(self, password);
    _successObject = [RACSubject subject];
    _failureObject = [RACSubject subject];
    _errorObject = [RACSubject subject];
    
}

- (id)buttonIsValid {
    RACSignal *signal = [RACSignal combineLatest:@[_userNameSignal,_passwordSignal]reduce:^id (NSString *username,NSString *password){
        return @(username.length > 6 && password.length > 6);
    }];
    
    return signal;
    
}

- (void)login {
    _requestData = @[_userName,_password];
    [_successObject sendNext:_requestData];
}

@end
